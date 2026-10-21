# Eliminar cuenta

La app llama a esta función desde **Configuración → Cuenta → Eliminar cuenta**.
Borra de verdad el usuario de Supabase Auth y sus datos. No es un cierre de sesión.

## Decisión si administra una familia

- **Es la única cuenta de la familia** (no hay otro `family_members.user_id`): se borra la familia completa. Sobres, movimientos, metas, reflexiones, cuentas, reglas, cola de sincronización e invitaciones pendientes. No queda un grupo sin dueño.
- **Hay otras cuentas**:
  - El presupuesto compartido se conserva. Quitar los gastos de una persona descuadraría los sobres de quienes se quedan.
  - Se borran sus reflexiones y su fila de miembro. Si existe la tabla `user_profiles`, también se borra su perfil. En el proyecto actual esa tabla no está.
  - Antes de borrar la membresía, las columnas de autoría (`registered_by`, `created_by_user_id` y las equivalentes en metas y reglas, más las claves foráneas que apunten a esa persona) se pasan a quien se queda, o quedan vacías si la columna lo permite. Así el borrado de Auth no arrastra los movimientos compartidos.
  - Si era el único administrador activo, el rol `admin` pasa al co_admin activo más antiguo. Si no hay, al otro miembro activo más antiguo. Si solo quedan miembros inactivos, al más antiguo y se reactiva. También si quien se va es admin pero está inactivo.
- En los dos casos, esta función borra después el usuario de Auth.
- La suscripción de Google Play no se cancela. Hay que hacerlo en Play → Pagos y suscripciones.

La lógica de los datos está en `public.delete_my_account_data(p_uid)` (`supabase_fixes.sql`). Solo `service_role` puede ejecutarla. Esta Edge Function comprueba el JWT de la persona, llama al RPC con la service role pasando ese uid (no un uid que venga en el cuerpo) y después llama a `auth.admin.deleteUser`.

## Qué tiene que hacer Carlos

1. Ejecutar `supabase_fixes.sql` en el SQL Editor (pasos en `INSTRUCCIONES_SQL.md`). Sin ese SQL, la función responde error.
2. Instalar la CLI de Supabase si no está: https://supabase.com/docs/guides/cli
3. En la carpeta del proyecto, vincular el proyecto:

   ```bash
   supabase login
   supabase link --project-ref TU_PROJECT_REF
   ```

4. Desplegar (el JWT se verifica; no uses `--no-verify-jwt`):

   ```bash
   supabase functions deploy delete-account
   ```

   `verify_jwt = true` está en `supabase/config.toml`. Si ese archivo choca con una configuración que ya tengas, conserva la tuya y deja el bloque `[functions.delete-account]`.

5. En el proyecto alojado de Supabase, `SUPABASE_URL`, `SUPABASE_ANON_KEY` y `SUPABASE_SERVICE_ROLE_KEY` ya existen dentro de las Edge Functions. No hace falta copiarlas a la app ni a GitHub.
   Si la función respondiera que no está configurada, en el panel: **Edge Functions → delete-account → Secrets** y confirma que esas tres variables están. No pegues la service role en Flutter.
6. Probar con una cuenta que no sea la Familia Piloto: crear familia de una sola persona, eliminar cuenta, comprobar que ya no puede entrar y que la familia desapareció.
7. Probar una familia de dos personas donde quien se va es el único admin: el otro debe quedar como admin y los sobres deben seguir.

## Qué hace el teléfono después

Si la función responde `ok`, la app borra las filas de Drift, limpia el almacenamiento seguro (deja solo la clave de SQLCipher para que la base vacía siga abriendo), revoca Gmail (`disconnect`) y cierra la sesión de Outlook (`logout`), hace `logOut` de RevenueCat en el dispositivo y cierra la sesión de Supabase.
