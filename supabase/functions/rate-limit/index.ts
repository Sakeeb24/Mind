// Supabase Edge Function: Rate Limit
// Checks and returns the current AI usage for the authenticated user
//
// Deploy: supabase functions deploy rate-limit
// Invoke: GET /functions/v1/rate-limit

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

serve(async (req: Request) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    // Create Supabase client with auth
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

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

    // Get user profile with query count
    const { data: profile, error: profileError } = await supabase
      .from("user_profiles")
      .select("daily_ai_queries, last_query_reset, subscription_tier")
      .eq("id", user.id)
      .single();

    if (profileError || !profile) {
      return new Response(
        JSON.stringify({ error: "User profile not found" }),
        { status: 404, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const today = new Date().toISOString().split("T")[0];
    let queriesUsed = profile.daily_ai_queries || 0;
    const lastReset = profile.last_query_reset;

    // Reset if it's a new day
    if (lastReset !== today) {
      queriesUsed = 0;
      await supabase
        .from("user_profiles")
        .update({ daily_ai_queries: 0, last_query_reset: today })
        .eq("id", user.id);
    }

    // Determine limits based on subscription tier
    const isPro = profile.subscription_tier === "pro";
    const dailyLimit = isPro ? -1 : 20; // -1 means unlimited

    // Calculate when the limit resets
    const tomorrow = new Date();
    tomorrow.setDate(tomorrow.getDate() + 1);
    tomorrow.setHours(0, 0, 0, 0);

    return new Response(
      JSON.stringify({
        queriesUsed,
        queriesRemaining: dailyLimit === -1 ? -1 : Math.max(0, dailyLimit - queriesUsed),
        dailyLimit,
        tier: profile.subscription_tier || "free",
        resetsAt: tomorrow.toISOString(),
        isPro,
      }),
      {
        status: 200,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  } catch (error) {
    console.error("Rate limit function error:", error);
    return new Response(
      JSON.stringify({ error: "Internal server error" }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
