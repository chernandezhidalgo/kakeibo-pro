-- ============================================================
-- KakeiboPro — Corrección de RLS (segura para datos existentes)
-- Ejecutar en: app.supabase.com → SQL Editor
-- Proyecto con datos: Familia Piloto. Este script NO borra familias,
-- miembros, sobres ni movimientos.
--
-- Es idempotente y va dentro de una transacción: si algo falla,
-- Postgres deshace todo el script. No queda a medias.
--
-- Problemas que corrige:
--   1. Las políticas de family_members consultaban family_members
--      y Postgres respondía "infinite recursion detected in policy".
--      Eso también rompía el resto de tablas.
--   2. family_members_update no tenía WITH CHECK: alguien podía
--      cambiar su propio role a admin.
--   3. Cualquier usuario autenticado veía y podía reclamar filas
--      con user_id NULL e invitation_token.
--   4. CREATE POLICY sin DROP y sin transacción.
--
-- Decisiones:
--   * is_family_member / is_family_admin / is_family_manager son
--     SECURITY DEFINER con search_path fijo. Así la política no se
--     llama a sí misma.
--   * Aceptar una invitación solo con accept_family_invitation(token).
--   * Un trigger impide cambiar role, familia o user_id si no eres admin,
--     y no deja a la familia sin administrador.
--   * delete_my_account_data() borra los datos de quien llama.
--     No borra el usuario de Auth: eso lo hace la Edge Function
--     supabase/functions/delete-account.
--
-- Qué pasa al eliminar una cuenta (la función no se ejecuta sola):
--   * Si esa persona es la única cuenta de la familia, se borra la
--     familia y todos sus datos.
--   * Si hay otras cuentas, el presupuesto compartido se queda.
--     Si era el único admin, el rol pasa a otro miembro.
--     Se borran su membresía, su perfil y sus reflexiones.
-- ============================================================

BEGIN;

SET LOCAL lock_timeout = '8s';
SET LOCAL statement_timeout = '60s';

-- ── Quitar políticas viejas (nombres antiguos y nuevos) ──────────────────────

DO $drop_policies$
DECLARE
  r record;
BEGIN
  FOR r IN
    SELECT policyname, tablename
    FROM pg_policies
    WHERE schemaname = 'public'
      AND tablename IN (
        'families',
        'family_members',
        'user_profiles',
        'envelopes',
        'transactions',
        'kakeibo_reflections',
        'savings_goals',
        'sync_queue',
        'recurring_rules',
        'accounts'
      )
  LOOP
    EXECUTE format(
      'DROP POLICY IF EXISTS %I ON public.%I',
      r.policyname,
      r.tablename
    );
  END LOOP;
END
$drop_policies$;

DROP TRIGGER IF EXISTS trg_guard_family_member_changes ON public.family_members;

DROP FUNCTION IF EXISTS public.delete_my_account_data();
DROP FUNCTION IF EXISTS public.accept_family_invitation(text);
DROP FUNCTION IF EXISTS public.guard_family_member_changes();
DROP FUNCTION IF EXISTS public._remove_member_from_shared_family(uuid, uuid, uuid);
DROP FUNCTION IF EXISTS public._delete_family_completely(uuid);
DROP FUNCTION IF EXISTS public._null_or_reassign(text, text, uuid, uuid);
DROP FUNCTION IF EXISTS public._has_column(text, text);
DROP FUNCTION IF EXISTS public.family_member_update_allowed(uuid, uuid, uuid, text, text);
DROP FUNCTION IF EXISTS public.shares_family_with(uuid);
DROP FUNCTION IF EXISTS public.family_is_empty(uuid);
DROP FUNCTION IF EXISTS public.is_family_manager(uuid);
DROP FUNCTION IF EXISTS public.is_family_admin(uuid);
DROP FUNCTION IF EXISTS public.is_family_member(uuid);

-- ── Funciones de pertenencia (rompen la recursión) ──────────────────────────

CREATE OR REPLACE FUNCTION public.is_family_member(fid uuid)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
  SELECT EXISTS (
    SELECT 1
    FROM public.family_members
    WHERE family_id = fid
      AND user_id = (SELECT auth.uid())
      AND is_active = true
  );
$fn$;

CREATE OR REPLACE FUNCTION public.is_family_admin(fid uuid)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
  SELECT EXISTS (
    SELECT 1
    FROM public.family_members
    WHERE family_id = fid
      AND user_id = (SELECT auth.uid())
      AND role = 'admin'
      AND is_active = true
  );
$fn$;

CREATE OR REPLACE FUNCTION public.is_family_manager(fid uuid)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
  SELECT EXISTS (
    SELECT 1
    FROM public.family_members
    WHERE family_id = fid
      AND user_id = (SELECT auth.uid())
      AND role IN ('admin', 'co_admin')
      AND is_active = true
  );
$fn$;

CREATE OR REPLACE FUNCTION public.family_is_empty(fid uuid)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
  SELECT NOT EXISTS (
    SELECT 1
    FROM public.family_members
    WHERE family_id = fid
  );
$fn$;

CREATE OR REPLACE FUNCTION public.shares_family_with(other_user uuid)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
  SELECT EXISTS (
    SELECT 1
    FROM public.family_members mine
    JOIN public.family_members theirs
      ON theirs.family_id = mine.family_id
    WHERE mine.user_id = (SELECT auth.uid())
      AND mine.is_active = true
      AND theirs.user_id = other_user
      AND theirs.is_active = true
  );
$fn$;

-- Compara la fila NUEVA con la que ya está guardada.
-- Un admin puede cambiar roles. El resto no puede cambiar role,
-- user_id, familia ni el token.
CREATE OR REPLACE FUNCTION public.family_member_update_allowed(
  p_id uuid,
  p_family_id uuid,
  p_user_id uuid,
  p_role text,
  p_invitation_token text
)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
  SELECT EXISTS (
    SELECT 1
    FROM public.family_members fm
    WHERE fm.id = p_id
      AND fm.family_id = p_family_id
      AND (
        public.is_family_admin(fm.family_id)
        OR (
          fm.user_id = (SELECT auth.uid())
          AND fm.role IS NOT DISTINCT FROM p_role
          AND fm.user_id IS NOT DISTINCT FROM p_user_id
          AND fm.invitation_token IS NOT DISTINCT FROM p_invitation_token
        )
        OR (
          public.is_family_manager(fm.family_id)
          AND fm.role IS NOT DISTINCT FROM p_role
          AND fm.user_id IS NOT DISTINCT FROM p_user_id
          AND fm.invitation_token IS NOT DISTINCT FROM p_invitation_token
        )
      )
  );
$fn$;

CREATE OR REPLACE FUNCTION public.get_my_family_id()
RETURNS uuid
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
  SELECT family_id
  FROM public.family_members
  WHERE user_id = (SELECT auth.uid())
    AND is_active = true
  LIMIT 1;
$fn$;

-- ── Ayudantes del borrado de cuenta (no los llama la app directo) ───────────

CREATE OR REPLACE FUNCTION public._has_column(p_table text, p_column text)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $fn$
  SELECT EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = p_table
      AND column_name = p_column
  );
$fn$;

CREATE OR REPLACE FUNCTION public._null_or_reassign(
  p_table text,
  p_column text,
  p_from uuid,
  p_to uuid
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $fn$
DECLARE
  v_type text;
  v_nullable text;
BEGIN
  SELECT data_type, is_nullable
  INTO v_type, v_nullable
  FROM information_schema.columns
  WHERE table_schema = 'public'
    AND table_name = p_table
    AND column_name = p_column;

  IF v_type IS NULL OR to_regclass(format('public.%I', p_table)) IS NULL THEN
    RETURN;
  END IF;

  IF v_nullable = 'YES' THEN
    IF v_type = 'uuid' THEN
      EXECUTE format(
        'UPDATE public.%I SET %I = NULL WHERE %I = $1',
        p_table, p_column, p_column
      )
      USING p_from;
    ELSE
      EXECUTE format(
        'UPDATE public.%I SET %I = NULL WHERE %I::text = $1',
        p_table, p_column, p_column
      )
      USING p_from::text;
    END IF;
    RETURN;
  END IF;

  IF p_to IS NULL THEN
    RAISE EXCEPTION
      'No se puede soltar % porque % no acepta vacío',
      p_column, p_table;
  END IF;

  IF v_type = 'uuid' THEN
    EXECUTE format(
      'UPDATE public.%I SET %I = $2 WHERE %I = $1',
      p_table, p_column, p_column
    )
    USING p_from, p_to;
  ELSE
    EXECUTE format(
      'UPDATE public.%I SET %I = $2 WHERE %I::text = $1',
      p_table, p_column, p_column
    )
    USING p_from::text, p_to::text;
  END IF;
END;
$fn$;

CREATE OR REPLACE FUNCTION public._delete_family_completely(p_family uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $fn$
BEGIN
  IF to_regclass('public.transactions') IS NOT NULL THEN
    DELETE FROM public.transactions WHERE family_id = p_family;
  END IF;
  IF to_regclass('public.recurring_rules') IS NOT NULL THEN
    DELETE FROM public.recurring_rules WHERE family_id = p_family;
  END IF;
  IF to_regclass('public.kakeibo_reflections') IS NOT NULL THEN
    DELETE FROM public.kakeibo_reflections WHERE family_id = p_family;
  END IF;
  IF to_regclass('public.savings_goals') IS NOT NULL THEN
    DELETE FROM public.savings_goals WHERE family_id = p_family;
  END IF;
  IF to_regclass('public.sync_queue') IS NOT NULL THEN
    DELETE FROM public.sync_queue WHERE family_id = p_family;
  END IF;
  IF to_regclass('public.envelopes') IS NOT NULL THEN
    DELETE FROM public.envelopes WHERE family_id = p_family;
  END IF;
  IF to_regclass('public.accounts') IS NOT NULL THEN
    DELETE FROM public.accounts WHERE family_id = p_family;
  END IF;

  IF public._has_column('family_members', 'invited_by') THEN
    BEGIN
      EXECUTE
        'UPDATE public.family_members SET invited_by = NULL WHERE family_id = $1'
      USING p_family;
    EXCEPTION
      WHEN not_null_violation THEN
        NULL;
    END;
  END IF;

  -- Primero quien no es admin, para que el trigger deje borrar al último admin.
  DELETE FROM public.family_members
  WHERE family_id = p_family
    AND (role IS DISTINCT FROM 'admin' OR user_id IS NULL);

  DELETE FROM public.family_members
  WHERE family_id = p_family;

  DELETE FROM public.families WHERE id = p_family;
END;
$fn$;

CREATE OR REPLACE FUNCTION public._remove_member_from_shared_family(
  p_member uuid,
  p_uid uuid,
  p_family uuid
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $fn$
DECLARE
  v_fallback uuid;
BEGIN
  SELECT id
  INTO v_fallback
  FROM public.family_members
  WHERE family_id = p_family
    AND id <> p_member
    AND user_id IS NOT NULL
  ORDER BY
    CASE WHEN role = 'admin' AND is_active THEN 0 ELSE 1 END,
    created_at ASC NULLS LAST
  LIMIT 1;

  IF to_regclass('public.kakeibo_reflections') IS NOT NULL THEN
    IF public._has_column('kakeibo_reflections', 'member_id') THEN
      EXECUTE
        'DELETE FROM public.kakeibo_reflections
         WHERE member_id::text = $1 OR member_id::text = $2'
      USING p_member::text, p_uid::text;
    END IF;
    IF public._has_column('kakeibo_reflections', 'user_id') THEN
      EXECUTE
        'DELETE FROM public.kakeibo_reflections WHERE user_id::text = $1'
      USING p_uid::text;
    END IF;
  END IF;

  PERFORM public._null_or_reassign(
    'envelopes', 'assigned_member_id', p_member, v_fallback
  );
  PERFORM public._null_or_reassign(
    'accounts', 'owner_member_id', p_member, v_fallback
  );
  PERFORM public._null_or_reassign(
    'family_members', 'invited_by', p_member, v_fallback
  );

  DELETE FROM public.family_members WHERE id = p_member;
END;
$fn$;

-- Borra los datos de auth.uid(). No borra auth.users.
CREATE OR REPLACE FUNCTION public.delete_my_account_data()
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $fn$
DECLARE
  v_uid uuid := auth.uid();
  v_member record;
  v_member_ids uuid[];
  v_member_id uuid;
  v_other_count integer;
  v_other_admin boolean;
  v_successor uuid;
  v_action text;
  v_summary jsonb := '[]'::jsonb;
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'Usuario no autenticado';
  END IF;

  SELECT coalesce(array_agg(id ORDER BY created_at ASC NULLS LAST), '{}'::uuid[])
  INTO v_member_ids
  FROM public.family_members
  WHERE user_id = v_uid;

  FOREACH v_member_id IN ARRAY v_member_ids
  LOOP
    SELECT id, family_id, role
    INTO v_member
    FROM public.family_members
    WHERE id = v_member_id;

    IF NOT FOUND THEN
      CONTINUE;
    END IF;
    SELECT count(*)
    INTO v_other_count
    FROM public.family_members
    WHERE family_id = v_member.family_id
      AND user_id IS NOT NULL
      AND user_id <> v_uid;

    IF v_other_count = 0 THEN
      PERFORM public._delete_family_completely(v_member.family_id);
      v_action := 'familia_eliminada';
    ELSE
      SELECT EXISTS (
        SELECT 1
        FROM public.family_members
        WHERE family_id = v_member.family_id
          AND role = 'admin'
          AND is_active = true
          AND user_id IS NOT NULL
          AND user_id <> v_uid
      )
      INTO v_other_admin;

      IF v_member.role = 'admin' AND NOT v_other_admin THEN
        SELECT id
        INTO v_successor
        FROM public.family_members
        WHERE family_id = v_member.family_id
          AND user_id IS NOT NULL
          AND user_id <> v_uid
        ORDER BY
          CASE
            WHEN is_active AND role = 'co_admin' THEN 0
            WHEN is_active THEN 1
            ELSE 2
          END,
          created_at ASC NULLS LAST
        LIMIT 1;

        IF v_successor IS NULL THEN
          RAISE EXCEPTION
            'No hay otro miembro a quien transferir la administración';
        END IF;

        UPDATE public.family_members
        SET role = 'admin',
            is_active = true
        WHERE id = v_successor;

        v_action := 'admin_transferido';
      ELSE
        v_action := 'membresia_eliminada';
      END IF;

      PERFORM public._remove_member_from_shared_family(
        v_member.id,
        v_uid,
        v_member.family_id
      );
    END IF;

    v_summary := v_summary || jsonb_build_array(
      jsonb_build_object(
        'family_id', v_member.family_id,
        'accion', v_action
      )
    );
  END LOOP;

  IF to_regclass('public.user_profiles') IS NOT NULL THEN
    DELETE FROM public.user_profiles WHERE id = v_uid;
  END IF;

  RETURN jsonb_build_object(
    'user_id', v_uid,
    'familias', v_summary
  );
END;
$fn$;

-- Reclama una invitación. La fila pendiente no es visible para el resto.
CREATE OR REPLACE FUNCTION public.accept_family_invitation(p_token text)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $fn$
DECLARE
  v_uid uuid := auth.uid();
  v_count integer;
  v_row public.family_members%ROWTYPE;
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'Usuario no autenticado';
  END IF;

  IF p_token IS NULL OR length(btrim(p_token)) < 8 OR length(p_token) > 200 THEN
    RAISE EXCEPTION 'Token de invitación inválido';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM public.family_members
    WHERE user_id = v_uid
      AND is_active = true
  ) THEN
    RAISE EXCEPTION 'Ya perteneces a una familia';
  END IF;

  SELECT count(*)
  INTO v_count
  FROM public.family_members
  WHERE invitation_token = btrim(p_token)
    AND user_id IS NULL;

  IF v_count <> 1 THEN
    RAISE EXCEPTION 'Token de invitación inválido';
  END IF;

  SELECT *
  INTO v_row
  FROM public.family_members
  WHERE invitation_token = btrim(p_token)
    AND user_id IS NULL
  FOR UPDATE;

  IF v_row.invitation_expires_at IS NULL
     OR v_row.invitation_expires_at <= now() THEN
    RAISE EXCEPTION 'El token de invitación ha expirado';
  END IF;

  UPDATE public.family_members
  SET user_id = v_uid,
      is_active = true,
      invitation_token = NULL,
      invitation_expires_at = NULL
  WHERE id = v_row.id
  RETURNING * INTO v_row;

  RETURN to_jsonb(v_row);
END;
$fn$;

-- ── Trigger: nadie escala su rol ni deja la familia sin admin ───────────────

CREATE OR REPLACE FUNCTION public.guard_family_member_changes()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $fn$
BEGIN
  -- Sin sesión de usuario (SQL Editor o service role de mantenimiento).
  IF auth.uid() IS NULL THEN
    IF TG_OP = 'DELETE' THEN
      RETURN OLD;
    END IF;
    RETURN NEW;
  END IF;

  IF TG_OP = 'INSERT' THEN
    IF public.family_is_empty(NEW.family_id) THEN
      IF NEW.user_id IS DISTINCT FROM auth.uid()
         OR NEW.role IS DISTINCT FROM 'admin'
         OR NEW.invitation_token IS NOT NULL
         OR NEW.is_active IS DISTINCT FROM true THEN
        RAISE EXCEPTION 'El primer miembro debe ser el administrador de la familia';
      END IF;
      RETURN NEW;
    END IF;

    IF public.is_family_admin(NEW.family_id) THEN
      RETURN NEW;
    END IF;

    IF public.is_family_manager(NEW.family_id)
       AND NEW.role IS DISTINCT FROM 'admin' THEN
      RETURN NEW;
    END IF;

    RAISE EXCEPTION 'No puedes agregar miembros a esta familia';
  END IF;

  IF TG_OP = 'DELETE' THEN
    IF OLD.role = 'admin' AND OLD.user_id IS NOT NULL THEN
      IF EXISTS (
        SELECT 1
        FROM public.family_members
        WHERE family_id = OLD.family_id
          AND id <> OLD.id
          AND user_id IS NOT NULL
      ) AND NOT EXISTS (
        SELECT 1
        FROM public.family_members
        WHERE family_id = OLD.family_id
          AND id <> OLD.id
          AND role = 'admin'
          AND is_active = true
          AND user_id IS NOT NULL
      ) THEN
        RAISE EXCEPTION 'Transfiere el rol de administrador antes de salir de la familia';
      END IF;
    END IF;
    RETURN OLD;
  END IF;

  -- Reclamar invitación: solo hacia uno mismo, sin cambiar el rol.
  IF OLD.user_id IS NULL
     AND OLD.invitation_token IS NOT NULL
     AND NEW.user_id = auth.uid()
     AND NEW.role IS NOT DISTINCT FROM OLD.role
     AND NEW.family_id IS NOT DISTINCT FROM OLD.family_id
     AND NEW.invitation_token IS NULL
     AND NEW.invitation_expires_at IS NULL
     AND NEW.is_active IS TRUE
  THEN
    IF OLD.invitation_expires_at IS NULL
       OR OLD.invitation_expires_at <= now() THEN
      RAISE EXCEPTION 'El token de invitación ha expirado';
    END IF;
    IF EXISTS (
      SELECT 1
      FROM public.family_members
      WHERE user_id = auth.uid()
        AND is_active = true
    ) THEN
      RAISE EXCEPTION 'Ya perteneces a una familia';
    END IF;
    RETURN NEW;
  END IF;

  IF NEW.family_id IS DISTINCT FROM OLD.family_id THEN
    RAISE EXCEPTION 'No puedes mover un miembro a otra familia';
  END IF;

  IF NEW.role IS DISTINCT FROM OLD.role THEN
    IF NOT public.is_family_admin(OLD.family_id) THEN
      RAISE EXCEPTION 'No puedes cambiar el rol';
    END IF;
    IF OLD.role = 'admin' AND NEW.role IS DISTINCT FROM 'admin' THEN
      IF NOT EXISTS (
        SELECT 1
        FROM public.family_members
        WHERE family_id = OLD.family_id
          AND id <> OLD.id
          AND role = 'admin'
          AND is_active = true
          AND user_id IS NOT NULL
      ) THEN
        RAISE EXCEPTION 'La familia debe conservar un administrador';
      END IF;
    END IF;
  END IF;

  IF NEW.user_id IS DISTINCT FROM OLD.user_id
     AND NOT public.is_family_admin(OLD.family_id) THEN
    RAISE EXCEPTION 'No puedes reasignar el usuario';
  END IF;

  IF NEW.invitation_token IS DISTINCT FROM OLD.invitation_token
     AND NOT public.is_family_admin(OLD.family_id) THEN
    RAISE EXCEPTION 'No puedes modificar la invitación';
  END IF;

  RETURN NEW;
END;
$fn$;

CREATE TRIGGER trg_guard_family_member_changes
BEFORE INSERT OR UPDATE OR DELETE ON public.family_members
FOR EACH ROW
EXECUTE FUNCTION public.guard_family_member_changes();

-- ── Permisos: la app autenticada sí; anónimo no. Ayudantes internos, no. ────

DO $grants$
DECLARE
  fn text;
BEGIN
  FOREACH fn IN ARRAY ARRAY[
    'public.is_family_member(uuid)',
    'public.is_family_admin(uuid)',
    'public.is_family_manager(uuid)',
    'public.family_is_empty(uuid)',
    'public.shares_family_with(uuid)',
    'public.family_member_update_allowed(uuid,uuid,uuid,text,text)',
    'public.get_my_family_id()',
    'public.accept_family_invitation(text)',
    'public.delete_my_account_data()',
    'public.guard_family_member_changes()'
  ]
  LOOP
    EXECUTE format('REVOKE ALL ON FUNCTION %s FROM PUBLIC', fn);
    EXECUTE format('REVOKE ALL ON FUNCTION %s FROM anon', fn);
    EXECUTE format('GRANT EXECUTE ON FUNCTION %s TO authenticated', fn);
    EXECUTE format('GRANT EXECUTE ON FUNCTION %s TO service_role', fn);
  END LOOP;

  FOREACH fn IN ARRAY ARRAY[
    'public._has_column(text,text)',
    'public._null_or_reassign(text,text,uuid,uuid)',
    'public._delete_family_completely(uuid)',
    'public._remove_member_from_shared_family(uuid,uuid,uuid)'
  ]
  LOOP
    EXECUTE format('REVOKE ALL ON FUNCTION %s FROM PUBLIC', fn);
    EXECUTE format('REVOKE ALL ON FUNCTION %s FROM anon', fn);
    EXECUTE format('REVOKE ALL ON FUNCTION %s FROM authenticated', fn);
  END LOOP;
END
$grants$;

-- ── RLS ──────────────────────────────────────────────────────────────────────

ALTER TABLE public.families ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.family_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.envelopes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kakeibo_reflections ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.savings_goals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sync_queue ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.recurring_rules ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.accounts ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "families_select" ON public.families;
CREATE POLICY "families_select"
ON public.families FOR SELECT TO authenticated
USING (public.is_family_member(id));

DROP POLICY IF EXISTS "families_insert" ON public.families;
CREATE POLICY "families_insert"
ON public.families FOR INSERT TO authenticated
WITH CHECK ((SELECT auth.uid()) IS NOT NULL);

DROP POLICY IF EXISTS "families_update" ON public.families;
CREATE POLICY "families_update"
ON public.families FOR UPDATE TO authenticated
USING (public.is_family_manager(id))
WITH CHECK (public.is_family_manager(id));

DROP POLICY IF EXISTS "families_delete" ON public.families;
CREATE POLICY "families_delete"
ON public.families FOR DELETE TO authenticated
USING (public.is_family_admin(id));

DROP POLICY IF EXISTS "family_members_select" ON public.family_members;
CREATE POLICY "family_members_select"
ON public.family_members FOR SELECT TO authenticated
USING (
  user_id = (SELECT auth.uid())
  OR public.is_family_member(family_id)
);

DROP POLICY IF EXISTS "family_members_insert" ON public.family_members;
CREATE POLICY "family_members_insert"
ON public.family_members FOR INSERT TO authenticated
WITH CHECK (
  (
    public.family_is_empty(family_id)
    AND user_id = (SELECT auth.uid())
    AND role = 'admin'
    AND is_active = true
    AND invitation_token IS NULL
  )
  OR public.is_family_admin(family_id)
  OR (
    public.is_family_manager(family_id)
    AND role IS DISTINCT FROM 'admin'
  )
);

DROP POLICY IF EXISTS "family_members_update" ON public.family_members;
CREATE POLICY "family_members_update"
ON public.family_members FOR UPDATE TO authenticated
USING (
  user_id = (SELECT auth.uid())
  OR public.is_family_manager(family_id)
)
WITH CHECK (
  public.family_member_update_allowed(
    id,
    family_id,
    user_id,
    role,
    invitation_token
  )
);

DROP POLICY IF EXISTS "family_members_delete" ON public.family_members;
CREATE POLICY "family_members_delete"
ON public.family_members FOR DELETE TO authenticated
USING (
  public.is_family_admin(family_id)
  AND user_id IS DISTINCT FROM (SELECT auth.uid())
);

DROP POLICY IF EXISTS "user_profiles_select" ON public.user_profiles;
CREATE POLICY "user_profiles_select"
ON public.user_profiles FOR SELECT TO authenticated
USING (
  id = (SELECT auth.uid())
  OR public.shares_family_with(id)
);

DROP POLICY IF EXISTS "user_profiles_insert" ON public.user_profiles;
CREATE POLICY "user_profiles_insert"
ON public.user_profiles FOR INSERT TO authenticated
WITH CHECK (id = (SELECT auth.uid()));

DROP POLICY IF EXISTS "user_profiles_update" ON public.user_profiles;
CREATE POLICY "user_profiles_update"
ON public.user_profiles FOR UPDATE TO authenticated
USING (id = (SELECT auth.uid()))
WITH CHECK (id = (SELECT auth.uid()));

DROP POLICY IF EXISTS "user_profiles_delete" ON public.user_profiles;
CREATE POLICY "user_profiles_delete"
ON public.user_profiles FOR DELETE TO authenticated
USING (id = (SELECT auth.uid()));

DROP POLICY IF EXISTS "members_all" ON public.envelopes;
CREATE POLICY "members_all"
ON public.envelopes FOR ALL TO authenticated
USING (public.is_family_member(family_id))
WITH CHECK (public.is_family_member(family_id));

DROP POLICY IF EXISTS "members_all" ON public.transactions;
CREATE POLICY "members_all"
ON public.transactions FOR ALL TO authenticated
USING (public.is_family_member(family_id))
WITH CHECK (public.is_family_member(family_id));

DROP POLICY IF EXISTS "members_all" ON public.kakeibo_reflections;
CREATE POLICY "members_all"
ON public.kakeibo_reflections FOR ALL TO authenticated
USING (public.is_family_member(family_id))
WITH CHECK (public.is_family_member(family_id));

DROP POLICY IF EXISTS "members_all" ON public.savings_goals;
CREATE POLICY "members_all"
ON public.savings_goals FOR ALL TO authenticated
USING (public.is_family_member(family_id))
WITH CHECK (public.is_family_member(family_id));

DROP POLICY IF EXISTS "members_all" ON public.sync_queue;
CREATE POLICY "members_all"
ON public.sync_queue FOR ALL TO authenticated
USING (public.is_family_member(family_id))
WITH CHECK (public.is_family_member(family_id));

DROP POLICY IF EXISTS "members_all" ON public.recurring_rules;
CREATE POLICY "members_all"
ON public.recurring_rules FOR ALL TO authenticated
USING (public.is_family_member(family_id))
WITH CHECK (public.is_family_member(family_id));

DROP POLICY IF EXISTS "members_all" ON public.accounts;
CREATE POLICY "members_all"
ON public.accounts FOR ALL TO authenticated
USING (public.is_family_member(family_id))
WITH CHECK (public.is_family_member(family_id));

-- ── Índices (no tocan los datos) ─────────────────────────────────────────────

CREATE INDEX IF NOT EXISTS idx_accounts_family_id ON public.accounts (family_id);
CREATE INDEX IF NOT EXISTS idx_accounts_owner_member_id ON public.accounts (owner_member_id);
CREATE INDEX IF NOT EXISTS idx_envelopes_family_id ON public.envelopes (family_id);
CREATE INDEX IF NOT EXISTS idx_envelopes_assigned_member_id ON public.envelopes (assigned_member_id);
CREATE INDEX IF NOT EXISTS idx_family_members_invited_by ON public.family_members (invited_by);
CREATE INDEX IF NOT EXISTS idx_family_members_user_id ON public.family_members (user_id);
CREATE INDEX IF NOT EXISTS idx_family_members_invitation_token
  ON public.family_members (invitation_token)
  WHERE invitation_token IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_kakeibo_reflections_family_id ON public.kakeibo_reflections (family_id);
CREATE INDEX IF NOT EXISTS idx_kakeibo_reflections_member_id ON public.kakeibo_reflections (member_id);
CREATE INDEX IF NOT EXISTS idx_recurring_rules_family_id ON public.recurring_rules (family_id);
CREATE INDEX IF NOT EXISTS idx_recurring_rules_envelope_id ON public.recurring_rules (envelope_id);
CREATE INDEX IF NOT EXISTS idx_recurring_rules_account_id ON public.recurring_rules (account_id);
CREATE INDEX IF NOT EXISTS idx_savings_goals_family_id ON public.savings_goals (family_id);
CREATE INDEX IF NOT EXISTS idx_sync_queue_family_id ON public.sync_queue (family_id);
CREATE INDEX IF NOT EXISTS idx_transactions_account_id ON public.transactions (account_id);
CREATE INDEX IF NOT EXISTS idx_transactions_registered_by ON public.transactions (registered_by);

DO $unique_members$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM public.family_members
    WHERE user_id IS NOT NULL
    GROUP BY family_id, user_id
    HAVING count(*) > 1
  ) THEN
    RAISE EXCEPTION
      'Hay la misma persona repetida dentro de una familia. No se cambió nada. Envía este mensaje a quien desarrolla la app.';
  END IF;

  CREATE UNIQUE INDEX IF NOT EXISTS idx_family_members_family_user_unique
    ON public.family_members (family_id, user_id)
    WHERE user_id IS NOT NULL;
END
$unique_members$;

-- ── Comprobaciones: si alguna falla, se deshace todo el script ──────────────

DO $verify$
DECLARE
  v_missing integer;
  v_bad integer;
BEGIN
  SELECT count(*) INTO v_missing
  FROM (
    SELECT unnest(ARRAY[
      'families',
      'family_members',
      'user_profiles',
      'envelopes',
      'transactions',
      'kakeibo_reflections',
      'savings_goals',
      'sync_queue',
      'recurring_rules',
      'accounts'
    ]) AS tablename
  ) expected
  LEFT JOIN pg_tables t
    ON t.schemaname = 'public'
   AND t.tablename = expected.tablename
   AND t.rowsecurity = true
  WHERE t.tablename IS NULL;

  IF v_missing > 0 THEN
    RAISE EXCEPTION 'RLS no quedó activo en todas las tablas';
  END IF;

  SELECT count(*) INTO v_bad
  FROM pg_policies
  WHERE schemaname = 'public'
    AND tablename = 'family_members'
    AND (
      coalesce(qual, '') ~* 'from[[:space:]]+([a-z_]+\.)?family_members'
      OR coalesce(with_check, '') ~* 'from[[:space:]]+([a-z_]+\.)?family_members'
    );

  IF v_bad > 0 THEN
    RAISE EXCEPTION 'family_members todavía se consulta a sí misma en una política';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM pg_policies
    WHERE schemaname = 'public'
      AND tablename = 'family_members'
      AND cmd = 'UPDATE'
      AND (with_check IS NULL OR btrim(with_check) = '')
  ) THEN
    RAISE EXCEPTION 'family_members UPDATE sigue sin WITH CHECK';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM pg_policies
    WHERE schemaname = 'public'
      AND (
        coalesce(qual, '') ~* 'invitation_token'
        OR coalesce(with_check, '') ~* 'invitation_token'
      )
      AND (
        coalesce(qual, '') ~* 'user_id is null'
        OR coalesce(with_check, '') ~* 'user_id is null'
      )
  ) THEN
    RAISE EXCEPTION 'Sigue habiendo una política que abre las invitaciones pendientes';
  END IF;

  SELECT count(*) INTO v_missing
  FROM (
    SELECT unnest(ARRAY[
      'is_family_member',
      'is_family_admin',
      'is_family_manager',
      'accept_family_invitation',
      'delete_my_account_data',
      'guard_family_member_changes'
    ]) AS proname
  ) expected
  LEFT JOIN pg_proc p
    ON p.proname = expected.proname
   AND p.pronamespace = 'public'::regnamespace
   AND p.prosecdef = true
  WHERE p.oid IS NULL;

  IF v_missing > 0 THEN
    RAISE EXCEPTION 'Falta una función SECURITY DEFINER';
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM pg_trigger
    WHERE tgname = 'trg_guard_family_member_changes'
      AND tgrelid = 'public.family_members'::regclass
      AND NOT tgisinternal
  ) THEN
    RAISE EXCEPTION 'Falta el trigger que impide cambiar el rol';
  END IF;
END
$verify$;

-- Resultados para leer en pantalla. La última fila debe decir
-- "KakeiboPro RLS OK".
SELECT tablename, rowsecurity AS rls_activo
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename IN (
    'families',
    'family_members',
    'user_profiles',
    'envelopes',
    'transactions',
    'kakeibo_reflections',
    'savings_goals',
    'sync_queue',
    'recurring_rules',
    'accounts'
  )
ORDER BY tablename;

SELECT tablename, policyname, cmd,
       (qual IS NOT NULL) AS tiene_using,
       (with_check IS NOT NULL) AS tiene_with_check
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, policyname;

SELECT 'KakeiboPro RLS OK' AS resultado;

COMMIT;

-- ============================================================
-- MANUAL, en la web de Supabase (no es SQL):
-- Authentication → Settings → Password →
-- activar "Enable Leaked Password Protection".
-- ============================================================
