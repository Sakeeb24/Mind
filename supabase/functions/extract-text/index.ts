// Supabase Edge Function: Extract Text
// Extracts structured text from PDF images using NVIDIA Nemotron-Parse
//
// Deploy: supabase functions deploy extract-text
// Invoke: POST /functions/v1/extract-text

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

interface ExtractTextRequest {
  documentId: string;
  pageImages: Array<{
    pageNumber: number;
    base64Image: string;
  }>;
}

interface ExtractedPage {
  pageNumber: number;
  text: string;
  boundingBoxes: Array<{
    text: string;
    class: string; // title, section, table, caption, list, footnote, bibliography, image
    x: number;
    y: number;
    width: number;
    height: number;
  }>;
}

serve(async (req: Request) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // Create Supabase client with auth
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const nemotronParseApiKey = Deno.env.get("NEMOTRON_PARSE_API_KEY")!;

    const supabase = createClient(supabaseUrl, supabaseServiceKey, {
      global: {
        headers: { Authorization: req.headers.get("Authorization")! },
      },
    });

    // Get authenticated user
    const {
      data: { user },
      error: authError,
    } = await supabase.auth.getUser();

    if (authError || !user) {
      return new Response(
        JSON.stringify({ error: "Unauthorized" }),
        { status: 401, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Parse request body
    const body: ExtractTextRequest = await req.json();

    if (!body.documentId || !body.pageImages || body.pageImages.length === 0) {
      return new Response(
        JSON.stringify({ error: "Missing required fields: documentId, pageImages" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Verify document ownership
    const { data: doc, error: docError } = await supabase
      .from("documents")
      .select("id, title")
      .eq("id", body.documentId)
      .eq("user_id", user.id)
      .single();

    if (docError || !doc) {
      return new Response(
        JSON.stringify({ error: "Document not found" }),
        { status: 404, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Process each page with Nemotron-Parse
    const extractedPages: ExtractedPage[] = [];
    const allText: string[] = [];

    for (const page of body.pageImages) {
      try {
        // Call NVIDIA Nemotron-Parse API
        const parseResponse = await fetch(
          "https://integrate.api.nvidia.com/v1/chat/completions",
          {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
              Authorization: `Bearer ${nemotronParseApiKey}`,
            },
            body: JSON.stringify({
              model: "nvidia/nemotron-parse",
              messages: [
                {
                  role: "user",
                  content: [
                    {
                      type: "image_url",
                      image_url: {
                        url: `data:image/png;base64,${page.base64Image}`,
                      },
                    },
                    {
                      type: "text",
                      text: "Extract all text from this document page. For each text block, provide: the text content, the semantic class (title, section, table, caption, list, footnote, bibliography, or body), and approximate bounding box coordinates (x, y, width, height as percentages of page dimensions). Return as JSON array.",
                    },
                  ],
                },
              ],
              max_tokens: 4096,
              temperature: 0.1,
            }),
          }
        );

        if (!parseResponse.ok) {
          console.error(`Failed to parse page ${page.pageNumber}:`, await parseResponse.text());
          // Continue with other pages instead of failing completely
          continue;
        }

        const parseResult = await parseResponse.json();
        const pageContent = parseResult.choices?.[0]?.message?.content || "";

        // Parse the response (it may be JSON or plain text)
        let boundingBoxes: ExtractedPage["boundingBoxes"] = [];
        let pageText = pageContent;

        try {
          // Try to parse as JSON if it contains bounding boxes
          const parsed = JSON.parse(pageContent);
          if (Array.isArray(parsed)) {
            boundingBoxes = parsed.map((item: any) => ({
              text: item.text || "",
              class: item.class || "body",
              x: item.x || 0,
              y: item.y || 0,
              width: item.width || 100,
              height: item.height || 10,
            }));
            pageText = parsed.map((item: any) => item.text || "").join("\n");
          }
        } catch {
          // If not JSON, use as plain text
          boundingBoxes = [];
        }

        extractedPages.push({
          pageNumber: page.pageNumber,
          text: pageText,
          boundingBoxes,
        });

        allText.push(pageText);
      } catch (pageError) {
        console.error(`Error processing page ${page.pageNumber}:`, pageError);
        // Continue with other pages
      }
    }

    // Combine all extracted text
    const fullText = allText.join("\n\n");

    // Store extracted text in Supabase
    const { error: updateError } = await supabase
      .from("documents")
      .update({
        has_extracted_text: true,
        updated_at: new Date().toISOString(),
      })
      .eq("id", body.documentId);

    if (updateError) {
      console.error("Failed to update document:", updateError);
    }

    // Store extracted pages as a JSON blob
    // Note: In production, you might want to store this in a separate table
    // or use Supabase Storage for larger documents
    const { error: storeError } = await supabase
      .from("extracted_text")
      .upsert({
        document_id: body.documentId,
        user_id: user.id,
        pages: extractedPages,
        full_text: fullText,
        page_count: extractedPages.length,
        extracted_at: new Date().toISOString(),
      });

    if (storeError) {
      console.error("Failed to store extracted text:", storeError);
      // Don't fail the request — extraction was successful
    }

    return new Response(
      JSON.stringify({
        success: true,
        documentId: body.documentId,
        pagesProcessed: extractedPages.length,
        totalTextLength: fullText.length,
        message: `Successfully extracted text from ${extractedPages.length} pages`,
      }),
      {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  } catch (error) {
    console.error("Extract text function error:", error);
    return new Response(
      JSON.stringify({ error: "Internal server error" }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
