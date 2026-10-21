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
--     Un token malo y uno vencido responden el mismo texto.
--   * Crear familia solo con create_family(nombre): inserta la familia
--     y al admin en la misma función. No hay política de INSERT en families.
--   * Un admin o co_admin solo puede insertar invitaciones
--     (user_id vacío y token). El primer admin es user_id = auth.uid().
--   * Un trigger impide cambiar role, familia o user_id si no eres admin,
--     no deja a la familia sin un admin activo, y nadie puede poner
--     su propio is_active en true si estaba apagado.
--   * delete_my_account_data(uid) solo la ejecuta service_role.
--     La Edge Function pasa el uid del JWT ya verificado.
--     No borra el usuario de Auth: eso lo hace la misma Edge Function
--     después, con auth.admin.deleteUser.
--   * Antes de borrar la membresía se reasignan (o se vacían, si la
--     columna lo permite) las columnas de autoría que apunten a esa
--     persona, aunque el nombre real de la columna no se conozca.
--     Así un ON DELETE CASCADE no se lleva los movimientos compartidos.
--   * Los índices se crean solo si la columna existe.
--
-- Qué pasa al eliminar una cuenta (la función no se ejecuta sola):
--   * Si esa persona es la única cuenta de la familia, se borra la
--     familia y todos sus datos.
--   * Si hay otras cuentas, el presupuesto compartido se queda.
--     Si era el único admin (aunque esté inactivo), el rol pasa a otro
--     miembro. Se borran su membresía, su perfil y sus reflexiones.
--     Los movimientos, metas y reglas se quedan, con otro autor o sin autor.
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
DROP FUNCTION IF EXISTS public.delete_my_account_data(uuid);
DROP FUNCTION IF EXISTS public.create_family(text);
DROP FUNCTION IF EXISTS public.accept_family_invitation(text);
DROP FUNCTION IF EXISTS public.guard_family_member_changes();
DROP FUNCTION IF EXISTS public._remove_member_from_shared_family(uuid, uuid, uuid);
DROP FUNCTION IF EXISTS public._delete_family_completely(uuid);
DROP FUNCTION IF EXISTS public._reassign_authorship(uuid, uuid, uuid, uuid);
DROP FUNCTION IF EXISTS public._apply_authorship_reassign(text, text, uuid, uuid);
DROP FUNCTION IF EXISTS public._null_or_reassign(text, text, uuid, uuid);
DROP FUNCTION IF EXISTS public._has_column(text, text);
DROP FUNCTION IF EXISTS public.family_member_update_allowed(uuid, uuid, uuid, text, text);
DROP FUNCTION IF EXISTS public.family_member_update_allowed(uuid, uuid, uuid, text, text, boolean);
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
-- Nadie puede encender su propio is_active.
-- Nadie puede dejar la familia sin un admin activo.
-- Un admin puede cambiar roles. El resto no puede cambiar role,
-- user_id, familia ni el token.
CREATE OR REPLACE FUNCTION public.family_member_update_allowed(
  p_id uuid,
  p_family_id uuid,
  p_user_id uuid,
  p_role text,
  p_invitation_token text,
  p_is_active boolean
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
      AND NOT (
        fm.user_id = (SELECT auth.uid())
        AND fm.is_active IS DISTINCT FROM true
        AND p_is_active IS TRUE
      )
      AND NOT (
        fm.role = 'admin'
        AND fm.is_active IS TRUE
        AND fm.user_id IS NOT NULL
        AND (
          p_role IS DISTINCT FROM 'admin'
          OR p_is_active IS DISTINCT FROM true
          OR p_user_id IS NULL
        )
        AND NOT EXISTS (
          SELECT 1
          FROM public.family_members other
          WHERE other.family_id = fm.family_id
            AND other.id <> fm.id
            AND other.role = 'admin'
            AND other.is_active IS TRUE
            AND other.user_id IS NOT NULL
        )
      )
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

-- Marca la promoción de admin que hace el borrado de cuenta.
-- Sin políticas: solo la función SECURITY DEFINER la escribe.
-- No guarda datos de la familia. Se vacía al aplicar este script.
CREATE TABLE IF NOT EXISTS public._account_deletion_guard (
  actor uuid PRIMARY KEY,
  family_id uuid NOT NULL,
  successor_id uuid NOT NULL
);

ALTER TABLE public._account_deletion_guard ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE public._account_deletion_guard FROM PUBLIC;
REVOKE ALL ON TABLE public._account_deletion_guard FROM anon;
REVOKE ALL ON TABLE public._account_deletion_guard FROM authenticated;

DELETE FROM public._account_deletion_guard;

-- Vacía o reasigna una columna de autoría. No hace nada si no hay filas.
CREATE OR REPLACE FUNCTION public._apply_authorship_reassign(
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
  v_count integer;
BEGIN
  IF p_from IS NULL OR to_regclass(format('public.%I', p_table)) IS NULL THEN
    RETURN;
  END IF;

  SELECT data_type, is_nullable
  INTO v_type, v_nullable
  FROM information_schema.columns
  WHERE table_schema = 'public'
    AND table_name = p_table
    AND column_name = p_column;

  IF v_type IS NULL THEN
    RETURN;
  END IF;

  IF v_type NOT IN ('uuid', 'text', 'character varying') THEN
    EXECUTE format(
      'SELECT count(*) FROM public.%I WHERE %I::text = $1',
      p_table, p_column
    )
    INTO v_count
    USING p_from::text;
    IF v_count > 0 THEN
      RAISE EXCEPTION
        'La columna %.% tiene un tipo que no se puede reasignar (%). No se borró la cuenta.',
        p_table, p_column, v_type;
    END IF;
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
        'UPDATE public.%I SET %I = NULL WHERE %I = $1',
        p_table, p_column, p_column
      )
      USING p_from::text;
    END IF;
    RETURN;
  END IF;

  IF v_type = 'uuid' THEN
    EXECUTE format(
      'SELECT count(*) FROM public.%I WHERE %I = $1',
      p_table, p_column
    )
    INTO v_count
    USING p_from;
  ELSE
    EXECUTE format(
      'SELECT count(*) FROM public.%I WHERE %I = $1',
      p_table, p_column
    )
    INTO v_count
    USING p_from::text;
  END IF;

  IF v_count = 0 THEN
    RETURN;
  END IF;

  IF p_to IS NULL THEN
    RAISE EXCEPTION
      'La columna %.% no acepta vacío y no hay otro miembro a quien pasar esos datos. No se borró la cuenta.',
      p_table, p_column;
  END IF;

  IF v_type = 'uuid' THEN
    EXECUTE format(
      'UPDATE public.%I SET %I = $2 WHERE %I = $1',
      p_table, p_column, p_column
    )
    USING p_from, p_to;
  ELSE
    EXECUTE format(
      'UPDATE public.%I SET %I = $2 WHERE %I = $1',
      p_table, p_column, p_column
    )
    USING p_from::text, p_to::text;
  END IF;
END;
$fn$;

-- Revisa claves foráneas y nombres habituales de autoría.
-- p_member es el id de family_members. p_uid es el usuario de Auth.
-- Si la columna acepta NULL, se vacía. Si no, pasa al miembro que se queda.
CREATE OR REPLACE FUNCTION public._reassign_authorship(
  p_member uuid,
  p_uid uuid,
  p_fallback_member uuid,
  p_fallback_user uuid
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $fn$
DECLARE
  r record;
  v_match uuid;
  v_fallback uuid;
  v_seen text[] := ARRAY[]::text[];
  v_key text;
BEGIN
  FOR r IN
    SELECT
      c.relname AS table_name,
      a.attname AS column_name,
      fns.nspname AS ref_schema,
      fc.relname AS ref_table,
      fa.attname AS ref_column,
      array_length(con.conkey, 1) AS nkeys
    FROM pg_constraint con
    JOIN pg_class c ON c.oid = con.conrelid
    JOIN pg_namespace n ON n.oid = c.relnamespace
    JOIN pg_class fc ON fc.oid = con.confrelid
    JOIN pg_namespace fns ON fns.oid = fc.relnamespace
    JOIN LATERAL unnest(con.conkey) WITH ORDINALITY AS ck(attnum, ord) ON true
    JOIN pg_attribute a
      ON a.attrelid = c.oid
     AND a.attnum = ck.attnum
     AND NOT a.attisdropped
    JOIN LATERAL unnest(con.confkey) WITH ORDINALITY AS fk(attnum, ord)
      ON fk.ord = ck.ord
    JOIN pg_attribute fa
      ON fa.attrelid = fc.oid
     AND fa.attnum = fk.attnum
     AND NOT fa.attisdropped
    WHERE con.contype = 'f'
      AND n.nspname = 'public'
      AND (
        (fns.nspname = 'public' AND fc.relname = 'family_members')
        OR (fns.nspname = 'auth' AND fc.relname = 'users')
      )
  LOOP
    IF r.table_name IN (
      'kakeibo_reflections',
      'user_profiles',
      '_account_deletion_guard'
    ) THEN
      CONTINUE;
    END IF;
    IF r.table_name = 'family_members' AND r.column_name = 'user_id' THEN
      CONTINUE;
    END IF;

    IF r.nkeys IS DISTINCT FROM 1 THEN
      RAISE EXCEPTION
        'La clave foránea de %.% es compuesta y no se puede reasignar sola. No se borró la cuenta.',
        r.table_name, r.column_name;
    END IF;

    v_key := r.table_name || '.' || r.column_name;
    IF v_key = ANY (v_seen) THEN
      CONTINUE;
    END IF;
    v_seen := array_append(v_seen, v_key);

    IF r.ref_schema = 'public'
       AND r.ref_table = 'family_members'
       AND r.ref_column = 'id' THEN
      v_match := p_member;
      v_fallback := p_fallback_member;
    ELSIF r.ref_schema = 'auth' AND r.ref_table = 'users' THEN
      v_match := p_uid;
      v_fallback := p_fallback_user;
    ELSE
      v_match := COALESCE(p_member, p_uid);
      v_fallback := COALESCE(p_fallback_member, p_fallback_user);
    END IF;

    PERFORM public._apply_authorship_reassign(
      r.table_name, r.column_name, v_match, v_fallback
    );
  END LOOP;

  FOR r IN
    SELECT *
    FROM (
      VALUES
        ('transactions', 'registered_by', 'either'),
        ('transactions', 'created_by_user_id', 'user'),
        ('transactions', 'created_by', 'user'),
        ('transactions', 'user_id', 'user'),
        ('transactions', 'author_id', 'user'),
        ('transactions', 'owner_id', 'user'),
        ('transactions', 'member_id', 'member'),
        ('savings_goals', 'registered_by', 'either'),
        ('savings_goals', 'created_by_user_id', 'user'),
        ('savings_goals', 'created_by', 'user'),
        ('savings_goals', 'user_id', 'user'),
        ('savings_goals', 'author_id', 'user'),
        ('savings_goals', 'owner_id', 'user'),
        ('savings_goals', 'member_id', 'member'),
        ('recurring_rules', 'registered_by', 'either'),
        ('recurring_rules', 'created_by_user_id', 'user'),
        ('recurring_rules', 'created_by', 'user'),
        ('recurring_rules', 'user_id', 'user'),
        ('recurring_rules', 'author_id', 'user'),
        ('recurring_rules', 'owner_id', 'user'),
        ('recurring_rules', 'member_id', 'member'),
        ('envelopes', 'assigned_member_id', 'member'),
        ('envelopes', 'owner_member_id', 'member'),
        ('envelopes', 'created_by_user_id', 'user'),
        ('envelopes', 'created_by', 'user'),
        ('envelopes', 'user_id', 'user'),
        ('accounts', 'owner_member_id', 'member'),
        ('accounts', 'assigned_member_id', 'member'),
        ('accounts', 'created_by_user_id', 'user'),
        ('accounts', 'user_id', 'user'),
        ('family_members', 'invited_by', 'either')
    ) AS names(table_name, column_name, kind)
  LOOP
    v_key := r.table_name || '.' || r.column_name;
    IF v_key = ANY (v_seen) THEN
      CONTINUE;
    END IF;
    IF r.table_name = 'family_members' AND r.column_name = 'user_id' THEN
      CONTINUE;
    END IF;
    IF NOT public._has_column(r.table_name, r.column_name) THEN
      CONTINUE;
    END IF;
    v_seen := array_append(v_seen, v_key);

    IF r.kind = 'member' AND p_member IS NOT NULL THEN
      PERFORM public._apply_authorship_reassign(
        r.table_name, r.column_name, p_member, p_fallback_member
      );
    ELSIF r.kind = 'user' AND p_uid IS NOT NULL THEN
      PERFORM public._apply_authorship_reassign(
        r.table_name, r.column_name, p_uid, p_fallback_user
      );
    ELSIF r.kind = 'either' THEN
      IF p_member IS NOT NULL THEN
        PERFORM public._apply_authorship_reassign(
          r.table_name, r.column_name, p_member, p_fallback_member
        );
      END IF;
      IF p_uid IS NOT NULL AND p_uid IS DISTINCT FROM p_member THEN
        PERFORM public._apply_authorship_reassign(
          r.table_name, r.column_name, p_uid, p_fallback_user
        );
      END IF;
    END IF;
  END LOOP;
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
  v_fallback_user uuid;
BEGIN
  SELECT id, user_id
  INTO v_fallback, v_fallback_user
  FROM public.family_members
  WHERE family_id = p_family
    AND id <> p_member
    AND user_id IS NOT NULL
    AND user_id IS DISTINCT FROM p_uid
  ORDER BY
    CASE
      WHEN role = 'admin' AND is_active THEN 0
      WHEN is_active THEN 1
      ELSE 2
    END,
    created_at ASC NULLS LAST
  LIMIT 1;

  IF v_fallback IS NULL THEN
    SELECT id
    INTO v_fallback
    FROM public.family_members
    WHERE family_id = p_family
      AND id <> p_member
    ORDER BY created_at ASC NULLS LAST
    LIMIT 1;
  END IF;

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

  -- Antes de borrar la fila: si no, un CASCADE se lleva lo compartido.
  PERFORM public._reassign_authorship(
    p_member,
    p_uid,
    v_fallback,
    v_fallback_user
  );

  DELETE FROM public.family_members WHERE id = p_member;
END;
$fn$;

-- Borra los datos de p_uid. No borra auth.users.
-- Solo service_role puede ejecutarla. Si hay sesión de usuario,
-- el uid tiene que ser el de esa sesión.
CREATE OR REPLACE FUNCTION public.delete_my_account_data(p_uid uuid)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $fn$
DECLARE
  v_uid uuid := p_uid;
  v_member record;
  v_member_ids uuid[];
  v_member_id uuid;
  v_other_count integer;
  v_other_admin boolean;
  v_successor uuid;
  v_fallback_user uuid;
  v_action text;
  v_summary jsonb := '[]'::jsonb;
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'Usuario no autenticado';
  END IF;

  IF auth.uid() IS NOT NULL AND auth.uid() IS DISTINCT FROM v_uid THEN
    RAISE EXCEPTION 'No puedes borrar la cuenta de otra persona';
  END IF;

  DELETE FROM public._account_deletion_guard WHERE actor = v_uid;

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

        -- El trigger deja pasar esta fila aunque el admin que se va
        -- esté inactivo (is_family_admin exige is_active).
        INSERT INTO public._account_deletion_guard (actor, family_id, successor_id)
        VALUES (v_uid, v_member.family_id, v_successor)
        ON CONFLICT (actor) DO UPDATE
          SET family_id = EXCLUDED.family_id,
              successor_id = EXCLUDED.successor_id;

        UPDATE public.family_members
        SET role = 'admin',
            is_active = true
        WHERE id = v_successor;

        DELETE FROM public._account_deletion_guard WHERE actor = v_uid;

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

  -- Segunda pasada: lo que todavía apunte al usuario de Auth,
  -- antes de que la Edge Function borre auth.users.
  SELECT user_id
  INTO v_fallback_user
  FROM public.family_members
  WHERE user_id IS NOT NULL
    AND user_id <> v_uid
  ORDER BY created_at ASC NULLS LAST
  LIMIT 1;

  PERFORM public._reassign_authorship(NULL, v_uid, NULL, v_fallback_user);

  DELETE FROM public._account_deletion_guard WHERE actor = v_uid;

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
    RAISE EXCEPTION 'Token de invitación inválido';
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

-- Crea la familia y al admin juntos. families_select no ve la fila
-- hasta que existe el miembro, por eso no se hace con dos INSERT del cliente.
CREATE OR REPLACE FUNCTION public.create_family(p_name text)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $fn$
DECLARE
  v_uid uuid := auth.uid();
  v_family public.families%ROWTYPE;
  v_member public.family_members%ROWTYPE;
  v_display text := 'Admin';
  v_email text;
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'Usuario no autenticado';
  END IF;

  IF p_name IS NULL OR length(btrim(p_name)) = 0 OR length(p_name) > 120 THEN
    RAISE EXCEPTION 'La familia necesita un nombre';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM public.family_members
    WHERE user_id = v_uid
      AND is_active = true
  ) THEN
    RAISE EXCEPTION 'Ya perteneces a una familia';
  END IF;

  IF to_regclass('auth.users') IS NOT NULL
     AND EXISTS (
       SELECT 1
       FROM information_schema.columns
       WHERE table_schema = 'auth'
         AND table_name = 'users'
         AND column_name = 'email'
     ) THEN
    SELECT email
    INTO v_email
    FROM auth.users
    WHERE id = v_uid;
    IF v_email IS NOT NULL AND position('@' IN v_email) > 1 THEN
      v_display := split_part(v_email, '@', 1);
    END IF;
  END IF;

  INSERT INTO public.families (name)
  VALUES (btrim(p_name))
  RETURNING * INTO v_family;

  INSERT INTO public.family_members (
    family_id,
    user_id,
    display_name,
    role,
    is_active
  )
  VALUES (
    v_family.id,
    v_uid,
    v_display,
    'admin',
    true
  )
  RETURNING * INTO v_member;

  RETURN jsonb_build_object(
    'family', to_jsonb(v_family),
    'member', to_jsonb(v_member)
  );
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

    -- Invitación: sin user_id y con token. Nadie inserta el id de otra persona.
    IF public.is_family_manager(NEW.family_id)
       AND NEW.user_id IS NULL
       AND NEW.invitation_token IS NOT NULL
       AND (
         public.is_family_admin(NEW.family_id)
         OR NEW.role IS DISTINCT FROM 'admin'
       ) THEN
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

  -- Promoción hecha por delete_my_account_data, también si el admin
  -- que se va está inactivo.
  IF EXISTS (
    SELECT 1
    FROM public._account_deletion_guard g
    WHERE g.actor IS NOT DISTINCT FROM auth.uid()
      AND g.successor_id = NEW.id
      AND g.family_id IS NOT DISTINCT FROM NEW.family_id
      AND g.family_id IS NOT DISTINCT FROM OLD.family_id
      AND NEW.role = 'admin'
      AND NEW.is_active IS TRUE
      AND NEW.user_id IS NOT DISTINCT FROM OLD.user_id
      AND NEW.family_id IS NOT DISTINCT FROM OLD.family_id
      AND NEW.invitation_token IS NOT DISTINCT FROM OLD.invitation_token
  ) THEN
    RETURN NEW;
  END IF;

  IF OLD.user_id IS NOT DISTINCT FROM auth.uid()
     AND OLD.is_active IS DISTINCT FROM true
     AND NEW.is_active IS TRUE THEN
    RAISE EXCEPTION 'No puedes reactivar tu propia cuenta';
  END IF;

  IF OLD.role = 'admin'
     AND OLD.is_active IS TRUE
     AND OLD.user_id IS NOT NULL
     AND (
       NEW.role IS DISTINCT FROM 'admin'
       OR NEW.is_active IS DISTINCT FROM true
       OR NEW.user_id IS NULL
     )
     AND NOT EXISTS (
       SELECT 1
       FROM public.family_members
       WHERE family_id = OLD.family_id
         AND id <> OLD.id
         AND role = 'admin'
         AND is_active IS TRUE
         AND user_id IS NOT NULL
     ) THEN
    RAISE EXCEPTION 'La familia debe conservar un administrador activo';
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
      RAISE EXCEPTION 'Token de invitación inválido';
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
    'public.family_member_update_allowed(uuid,uuid,uuid,text,text,boolean)',
    'public.get_my_family_id()',
    'public.accept_family_invitation(text)',
    'public.create_family(text)',
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
    'public._apply_authorship_reassign(text,text,uuid,uuid)',
    'public._reassign_authorship(uuid,uuid,uuid,uuid)',
    'public._delete_family_completely(uuid)',
    'public._remove_member_from_shared_family(uuid,uuid,uuid)',
    'public.delete_my_account_data(uuid)'
  ]
  LOOP
    EXECUTE format('REVOKE ALL ON FUNCTION %s FROM PUBLIC', fn);
    EXECUTE format('REVOKE ALL ON FUNCTION %s FROM anon', fn);
    EXECUTE format('REVOKE ALL ON FUNCTION %s FROM authenticated', fn);
    EXECUTE format('REVOKE ALL ON FUNCTION %s FROM service_role', fn);
  END LOOP;

  GRANT EXECUTE ON FUNCTION public.delete_my_account_data(uuid) TO service_role;
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

-- Sin política de INSERT: el cliente no puede crear una familia sola.
-- create_family (SECURITY DEFINER) inserta familia y admin juntos.
DROP POLICY IF EXISTS "families_insert" ON public.families;

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
  OR (
    public.is_family_manager(family_id)
    AND user_id IS NULL
    AND invitation_token IS NOT NULL
    AND (
      public.is_family_admin(family_id)
      OR role IS DISTINCT FROM 'admin'
    )
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
    invitation_token,
    is_active
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

-- ── Índices (no tocan los datos; se omiten si la columna no existe) ──────────

DO $indexes$
DECLARE
  r record;
BEGIN
  FOR r IN
    SELECT *
    FROM (
      VALUES
        ('accounts', 'family_id', 'idx_accounts_family_id'),
        ('accounts', 'owner_member_id', 'idx_accounts_owner_member_id'),
        ('envelopes', 'family_id', 'idx_envelopes_family_id'),
        ('envelopes', 'assigned_member_id', 'idx_envelopes_assigned_member_id'),
        ('family_members', 'invited_by', 'idx_family_members_invited_by'),
        ('family_members', 'user_id', 'idx_family_members_user_id'),
        ('kakeibo_reflections', 'family_id', 'idx_kakeibo_reflections_family_id'),
        ('kakeibo_reflections', 'member_id', 'idx_kakeibo_reflections_member_id'),
        ('recurring_rules', 'family_id', 'idx_recurring_rules_family_id'),
        ('recurring_rules', 'envelope_id', 'idx_recurring_rules_envelope_id'),
        ('recurring_rules', 'account_id', 'idx_recurring_rules_account_id'),
        ('savings_goals', 'family_id', 'idx_savings_goals_family_id'),
        ('sync_queue', 'family_id', 'idx_sync_queue_family_id'),
        ('transactions', 'account_id', 'idx_transactions_account_id'),
        ('transactions', 'registered_by', 'idx_transactions_registered_by'),
        ('transactions', 'created_by_user_id', 'idx_transactions_created_by_user_id')
    ) AS wanted(table_name, column_name, index_name)
  LOOP
    IF EXISTS (
      SELECT 1
      FROM information_schema.columns
      WHERE table_schema = 'public'
        AND table_name = r.table_name
        AND column_name = r.column_name
    ) THEN
      EXECUTE format(
        'CREATE INDEX IF NOT EXISTS %I ON public.%I (%I)',
        r.index_name,
        r.table_name,
        r.column_name
      );
    END IF;
  END LOOP;

  IF EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'family_members'
      AND column_name = 'invitation_token'
  ) THEN
    EXECUTE
      'CREATE INDEX IF NOT EXISTS idx_family_members_invitation_token
       ON public.family_members (invitation_token)
       WHERE invitation_token IS NOT NULL';
  END IF;
END
$indexes$;

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

  -- INSERT con user_id vacío y token es la invitación, y es correcto.
  -- Lo que no puede quedar es un SELECT o UPDATE que abra esas filas.
  IF EXISTS (
    SELECT 1
    FROM pg_policies
    WHERE schemaname = 'public'
      AND cmd IN ('SELECT', 'UPDATE', 'ALL')
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
      'create_family',
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

  IF EXISTS (
    SELECT 1
    FROM pg_policies
    WHERE schemaname = 'public'
      AND tablename = 'families'
      AND cmd = 'INSERT'
  ) THEN
    RAISE EXCEPTION 'families no debe aceptar INSERT directo: usa create_family';
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM pg_proc
    WHERE proname = 'delete_my_account_data'
      AND pronamespace = 'public'::regnamespace
      AND pronargs = 1
  ) OR EXISTS (
    SELECT 1
    FROM pg_proc
    WHERE proname = 'delete_my_account_data'
      AND pronamespace = 'public'::regnamespace
      AND pronargs = 0
  ) THEN
    RAISE EXCEPTION 'delete_my_account_data debe recibir el uid';
  END IF;

  IF has_function_privilege(
    'authenticated',
    'public.delete_my_account_data(uuid)',
    'EXECUTE'
  ) THEN
    RAISE EXCEPTION 'authenticated no debe ejecutar delete_my_account_data';
  END IF;

  IF NOT has_function_privilege(
    'service_role',
    'public.delete_my_account_data(uuid)',
    'EXECUTE'
  ) THEN
    RAISE EXCEPTION 'service_role debe ejecutar delete_my_account_data';
  END IF;

  IF to_regclass('public._account_deletion_guard') IS NULL THEN
    RAISE EXCEPTION 'Falta la marca de transferencia de admin';
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
