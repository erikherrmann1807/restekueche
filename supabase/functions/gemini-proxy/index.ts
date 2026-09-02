import "jsr:@supabase/functions-js/edge-runtime.d.ts";

const GEMINI_API_KEY = Deno.env.get("GEMINI_API_KEY");
const GEMINI_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-flash-lite:generateContent";

Deno.serve(async (req) => {
  // CORS für Flutter Web (bei mobile/desktop nicht zwingend nötig, schadet aber nicht)
  if (req.method === "OPTIONS") {
    return new Response("ok", {
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
      },
    });
  }

  // Ohne Secret würde der Request bei Gemini als 400 API_KEY_INVALID landen –
  // das ist irreführend, deshalb hier direkt melden.
  if (!GEMINI_API_KEY) {
    console.error("GEMINI_API_KEY ist nicht gesetzt (supabase secrets set --env-file supabase/.env)");
    return new Response(
      JSON.stringify({ error: "GEMINI_API_KEY is not configured for this function" }),
      {
        status: 500,
        headers: { "Content-Type": "application/json", "Access-Control-Allow-Origin": "*" },
      },
    );
  }

  try {
    const body = await req.json();

    const response = await fetch(GEMINI_URL, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "x-goog-api-key": GEMINI_API_KEY,
      },
      body: JSON.stringify(body),
    });

    const data = await response.json();

    return new Response(JSON.stringify(data), {
      headers: { "Content-Type": "application/json", "Access-Control-Allow-Origin": "*" },
      status: response.status,
    });
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }
});