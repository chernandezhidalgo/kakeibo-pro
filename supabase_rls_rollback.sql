-- ============================================================
-- KakeiboPro — Deshacer el script supabase_fixes.sql
-- NO borra familias, miembros, sobres ni movimientos.
--
-- Úsalo solo si el script anterior terminó bien (viste
-- "KakeiboPro RLS OK") y la app dejó de funcionar.
--
-- Si el script anterior mostró un error, NO ejecutes esto:
-- la transacción ya deshizo los cambios.
--
-- Esto quita el trigger, la aceptación de invitaciones,
-- la creación de familia y el borrado de cuenta.
-- Las reglas de acceso seguras SE QUEDAN
-- (nadie se reactiva solo, y no se inserta el id de otra persona).
-- No vuelve a dejar las políticas viejas (esas eran inseguras).
-- Para restaurar invitaciones, crear familia y borrado de cuenta,
-- vuelve a ejecutar supabase_fixes.sql.
-- ============================================================

BEGIN;

SET LOCAL lock_timeout = '8s';
SET LOCAL statement_timeout = '60s';

DROP TRIGGER IF EXISTS trg_guard_family_member_changes ON public.family_members;
DROP FUNCTION IF EXISTS public.guard_family_member_changes();
DROP FUNCTION IF EXISTS public.delete_my_account_data();
DROP FUNCTION IF EXISTS public.delete_my_account_data(uuid);
DROP FUNCTION IF EXISTS public.create_family(text);
DROP FUNCTION IF EXISTS public.accept_family_invitation(text);
DROP FUNCTION IF EXISTS public._remove_member_from_shared_family(uuid, uuid, uuid);
DROP FUNCTION IF EXISTS public._delete_family_completely(uuid);
DROP FUNCTION IF EXISTS public._reassign_authorship(uuid, uuid, uuid, uuid);
DROP FUNCTION IF EXISTS public._apply_authorship_reassign(text, text, uuid, uuid);
DROP FUNCTION IF EXISTS public._null_or_reassign(text, text, uuid, uuid);
DROP FUNCTION IF EXISTS public._has_column(text, text);
DROP TABLE IF EXISTS public._account_deletion_guard;

-- Las políticas y las funciones is_family_member / is_family_admin
-- se conservan a propósito.

SELECT 'Rollback listo. Los datos siguen. Invitaciones, crear familia y borrado de cuenta quedan apagados hasta ejecutar supabase_fixes.sql de nuevo.' AS resultado;

COMMIT;
