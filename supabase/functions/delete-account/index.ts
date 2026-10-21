// Borra la cuenta de quien llama.
// 1. Comprueba el JWT.
// 2. Ejecuta public.delete_my_account_data() con ese usuario
//    (transfiere el admin o borra la familia si estaba solo).
// 3. Borra el usuario de Supabase Auth con la service role.
//
// La service role solo vive aquí. No va en la app.
// Hay que ejecutar supabase_fixes.sql antes de desplegar esta función.

import { createClient } from "npm:@supabase/supabase-js@2";

const corsHeaders: Record<string, string> = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return json(200, { ok: true });
  }

  if (req.method !== "POST") {
    return json(405, { error: "Método no permitido." });
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
  const anonKey = Deno.env.get("SUPABASE_ANON_KEY") ?? "";
  const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";

  if (!supabaseUrl || !anonKey || !serviceKey) {
    console.error("delete-account: faltan variables de entorno");
    return json(500, {
      error:
        "La eliminación de cuenta no está configurada. Escribe a info.kakeibopro@gmail.com.",
    });
  }

  const authHeader = req.headers.get("Authorization") ?? "";
  if (!authHeader.startsWith("Bearer ")) {
    return json(401, {
      error: "Vuelve a iniciar sesión e inténtalo de nuevo.",
    });
  }

  const userClient = createClient(supabaseUrl, anonKey, {
    global: { headers: { Authorization: authHeader } },
    auth: { persistSession: false, autoRefreshToken: false },
  });

  const { data: userData, error: userError } = await userClient.auth.getUser();
  const user = userData?.user;
  if (userError || !user) {
    console.error("delete-account: jwt rechazado");
    return json(401, {
      error: "La sesión no es válida. Vuelve a iniciar sesión.",
    });
  }

  const { data: deleted, error: rpcError } = await userClient.rpc(
    "delete_my_account_data",
  );

  if (rpcError) {
    console.error("delete-account: rpc", rpcError.message);
    return json(500, {
      error:
        "No se pudieron borrar los datos. Escribe a info.kakeibopro@gmail.com.",
    });
  }

  const reportedUserId = deleted && typeof deleted === "object"
    ? (deleted as { user_id?: string }).user_id
    : null;
  if (reportedUserId && reportedUserId !== user.id) {
    console.error("delete-account: el RPC devolvió otro usuario");
    return json(500, {
      error:
        "No se pudo confirmar el borrado. Escribe a info.kakeibopro@gmail.com.",
    });
  }

  const admin = createClient(supabaseUrl, serviceKey, {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  const { error: deleteError } = await admin.auth.admin.deleteUser(
    user.id,
    false,
  );

  if (deleteError && !/not found/i.test(deleteError.message)) {
    console.error("delete-account: auth.admin.deleteUser", deleteError.message);
    return json(500, {
      error:
        "Se borraron los datos, pero no la cuenta de acceso. Inténtalo otra vez o escribe a info.kakeibopro@gmail.com.",
    });
  }

  return json(200, { ok: true });
});

function json(status: number, body: Record<string, unknown>): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}
