// Supabase Edge Function: Chat
// AI Q&A chat about document content using NVIDIA Nemotron 3 Ultra 550B
//
// Deploy: supabase functions deploy chat
// Invoke: POST /functions/v1/chat

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

interface ChatRequest {
  documentId: string;
  message: string;
  chatHistory?: Array<{ role: string; content: string }>;
  extractedText?: string;
}

interface ChatMessage {
  role: "user" | "assistant";
  content: string;
  citations?: Array<{ page: number; text: string }>;
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
    const body: ChatRequest = await req.json();

    if (!body.documentId || !body.message) {
      return new Response(
        JSON.stringify({ error: "Missing required fields: documentId, message" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    if (body.message.length > 2000) {
      return new Response(
        JSON.stringify({ error: "Message too long (max 2000 characters)" }),
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

    // Get document title for context
    const { data: doc } = await supabase
      .from("documents")
      .select("title")
      .eq("id", body.documentId)
      .eq("user_id", user.id)
      .single();

    const docTitle = doc?.title || "Unknown Document";

    // Prepare document context
    const documentContext = body.extractedText
      ? `\n\nDocument content from "${docTitle}":\n${body.extractedText}`
      : "";

    // Build messages array for the AI
    const messages = [
      {
        role: "system",
        content: `You are an expert study assistant helping a student understand their document "${docTitle}". Answer questions clearly and concisely. When referencing specific parts of the document, mention the page number if known. Use bullet points for lists. Keep answers focused and educational. If the answer isn't in the document, say so clearly.`,
      },
      {
        role: "user",
        content: `Here is the document content for reference:${documentContext}`,
      },
    ];

    // Add chat history (last 10 messages for context)
    if (body.chatHistory && body.chatHistory.length > 0) {
      const recentHistory = body.chatHistory.slice(-10);
      messages.push(...recentHistory);
    }

    // Add current user message
    messages.push({
      role: "user",
      content: body.message,
    });

    // Call NVIDIA Nemotron 3 Ultra 550B
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
          messages,
          max_tokens: 1024,
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
    const assistantMessage = aiResult.choices?.[0]?.message?.content || "";

    if (!assistantMessage) {
      return new Response(
        JSON.stringify({ error: "Empty response from AI" }),
        { status: 502, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Extract citations from the response (simple pattern matching)
    const citationRegex = /\[Page (\d+)\]/g;
    const citations: Array<{ page: number; text: string }> = [];
    let match;
    while ((match = citationRegex.exec(assistantMessage)) !== null) {
      citations.push({
        page: parseInt(match[1]),
        text: match[0],
      });
    }

    // Save user message to database
    await supabase.from("chat_messages").insert({
      document_id: body.documentId,
      user_id: user.id,
      role: "user",
      content: body.message,
    });

    // Save assistant message to database
    await supabase.from("chat_messages").insert({
      document_id: body.documentId,
      user_id: user.id,
      role: "assistant",
      content: assistantMessage,
      citations: citations.length > 0 ? citations : null,
      model_used: "nvidia/llama-3.3-nemotron-super-49b-v1",
    });

    // Increment query count
    await supabase
      .from("user_profiles")
      .update({
        daily_ai_queries: (profile?.daily_ai_queries || 0) + 1,
        last_query_reset: today,
      })
      .eq("id", user.id);

    return new Response(
      JSON.stringify({
        message: assistantMessage,
        citations,
        model: "nvidia/llama-3.3-nemotron-super-49b-v1",
        documentTitle: docTitle,
      }),
      {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  } catch (error) {
    console.error("Chat function error:", error);
    return new Response(
      JSON.stringify({ error: "Internal server error" }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
