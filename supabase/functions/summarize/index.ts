// Supabase Edge Function: Summarize
// Summarizes document content using NVIDIA Nemotron 3 Ultra 550B
//
// Deploy: supabase functions deploy summarize
// Invoke: POST /functions/v1/summarize

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

interface SummarizeRequest {
  documentId: string;
  scope: "page" | "section" | "selection";
  pageNumber?: number;
  selectedText?: string;
  extractedText?: string;
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
    const nemotronApiKey = Deno.env.get("NEMOTRON_ULTRA_API_KEY")!;

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
    const body: SummarizeRequest = await req.json();

    if (!body.documentId || !body.scope) {
      return new Response(
        JSON.stringify({ error: "Missing required fields: documentId, scope" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Check rate limit
    const today = new Date().toISOString().split("T")[0];
    const { data: profile } = await supabase
      .from("user_profiles")
      .select("daily_ai_queries, last_query_reset")
      .eq("id", user.id)
      .single();

    if (profile) {
      // Reset counter if it's a new day
      if (profile.last_query_reset !== today) {
        await supabase
          .from("user_profiles")
          .update({ daily_ai_queries: 0, last_query_reset: today })
          .eq("id", user.id);
      } else if (profile.daily_ai_queries >= 20) {
        return new Response(
          JSON.stringify({
            error: "Daily query limit reached",
            message: "You've reached your daily limit of 20 AI queries. Try again tomorrow or upgrade to Pro.",
            limit: 20,
            used: profile.daily_ai_queries,
          }),
          { status: 429, headers: { ...corsHeaders, "Content-Type": "application/json" } }
        );
      }
    }

    // Prepare text to summarize
    let textToSummarize = "";

    if (body.selectedText) {
      textToSummarize = body.selectedText;
    } else if (body.extractedText) {
      textToSummarize = body.extractedText;
    } else {
      // Fetch extracted text from database
      const { data: extracted } = await supabase
        .from("documents")
        .select("has_extracted_text")
        .eq("id", body.documentId)
        .eq("user_id", user.id)
        .single();

      if (!extracted?.has_extracted_text) {
        return new Response(
          JSON.stringify({ error: "Document text not yet extracted. Please wait for processing to complete." }),
          { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
        );
      }

      // For now, use the extracted text passed in the request
      textToSummarize = body.extractedText || "";
    }

    if (!textToSummarize.trim()) {
      return new Response(
        JSON.stringify({ error: "No text to summarize" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Call NVIDIA Nemotron 3 Ultra 550B
    const scopeLabel = body.scope === "page" ? "this page"
      : body.scope === "section" ? "this section"
      : "this selection";

    const prompt = `You are a study assistant helping a student understand their academic material. Summarize the following ${scopeLabel} concisely. Focus on key concepts, important terms, and main ideas. Use bullet points for clarity. Keep the summary under 500 words.

Text to summarize:
${textToSummarize}

Provide a clear, concise summary that a student can use for studying.`;

    const aiResponse = await fetch(
      "https://integrate.api.nvidia.com/v1/chat/completions",
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${nemotronApiKey}`,
        },
        body: JSON.stringify({
          model: "nvidia/llama-3.3-nemotron-super-49b-v1",
          messages: [
            {
              role: "system",
              content: "You are an expert academic study assistant. Provide clear, accurate summaries of educational content.",
            },
            {
              role: "user",
              content: prompt,
            },
          ],
          max_tokens: 2048,
          temperature: 0.3,
          top_p: 0.9,
        }),
      }
    );

    if (!aiResponse.ok) {
      const errorText = await aiResponse.text();
      console.error("Nemotron API error:", errorText);
      return new Response(
        JSON.stringify({ error: "AI service temporarily unavailable. Please try again." }),
        { status: 502, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const aiResult = await aiResponse.json();
    const summary = aiResult.choices?.[0]?.message?.content || "";

    if (!summary) {
      return new Response(
        JSON.stringify({ error: "Empty response from AI" }),
        { status: 502, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Increment query count
    await supabase
      .from("user_profiles")
      .update({
        daily_ai_queries: (profile?.daily_ai_queries || 0) + 1,
        last_query_reset: today,
      })
      .eq("id", user.id);

    // Store summary in database
    const { error: insertError } = await supabase.from("summaries").insert({
      document_id: body.documentId,
      user_id: user.id,
      scope: body.scope,
      scope_reference: body.pageNumber?.toString() || body.selectedText?.substring(0, 100),
      content: summary,
      model_used: "nvidia/llama-3.3-nemotron-super-49b-v1",
    });

    if (insertError) {
      console.error("Failed to store summary:", insertError);
      // Don't fail the request — summary was generated successfully
    }

    return new Response(
      JSON.stringify({
        summary,
        model: "nvidia/llama-3.3-nemotron-super-49b-v1",
        scope: body.scope,
        pageNumber: body.pageNumber,
      }),
      {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  } catch (error) {
    console.error("Summarize function error:", error);
    return new Response(
      JSON.stringify({ error: "Internal server error" }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
