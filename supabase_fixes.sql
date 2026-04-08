-- ============================================================
-- KakeiboPro — Script de correcciones Supabase
-- Fecha: 2026-04-08
-- Origen: Supabase Security & Performance Advisor
-- Ejecutar en: app.supabase.com → SQL Editor
-- ============================================================
-- RESUMEN DE ISSUES CORREGIDOS:
--   ERROR   · family_members sin RLS (tabla completamente expuesta)
--   WARN    · families_insert: WITH CHECK (true) — demasiado permisivo
--   WARN    · auth.uid() re-evaluado por fila en 9 tablas (performance)
--   WARN    · get_my_family_id: search_path mutable (riesgo de hijacking)
--   WARN    · Leaked password protection (corrección en UI — ver paso 5)
--   INFO    · Índices faltantes en foreign keys (10 tablas)
-- ============================================================


-- ============================================================
-- PASO 1: CRÍTICO — Habilitar RLS en family_members
-- Problema: tabla expuesta públicamente sin ninguna restricción.
-- ============================================================

ALTER TABLE family_members ENABLE ROW LEVEL SECURITY;

-- Leer: miembros de tu propia familia + filas de invitación pendiente
CREATE POLICY "family_members_select"
ON family_members FOR SELECT TO authenticated
USING (
  user_id = (SELECT auth.uid())
  OR
  family_id IN (
    SELECT fm.family_id FROM family_members fm
    WHERE fm.user_id = (SELECT auth.uid()) AND fm.is_active = true
  )
  OR
  (user_id IS NULL AND invitation_token IS NOT NULL)
);

-- Insertar: admins de la familia O creación del primer miembro
CREATE POLICY "family_members_insert"
ON family_members FOR INSERT TO authenticated
WITH CHECK (
  (SELECT auth.uid()) IN (
    SELECT fm.user_id FROM family_members fm
    WHERE fm.family_id = family_members.family_id
      AND fm.role IN ('admin', 'co_admin')
      AND fm.is_active = true
  )
  OR
  NOT EXISTS (
    SELECT 1 FROM family_members fm2
    WHERE fm2.family_id = family_members.family_id
  )
);

-- Actualizar: propio registro (para aceptar invitación) O admin de la familia
CREATE POLICY "family_members_update"
ON family_members FOR UPDATE TO authenticated
USING (
  user_id = (SELECT auth.uid())
  OR
  family_id IN (
    SELECT fm.family_id FROM family_members fm
    WHERE fm.user_id = (SELECT auth.uid())
      AND fm.role IN ('admin', 'co_admin')
      AND fm.is_active = true
  )
  OR
  (user_id IS NULL AND invitation_token IS NOT NULL)
);

-- Eliminar: solo admin
CREATE POLICY "family_members_delete"
ON family_members FOR DELETE TO authenticated
USING (
  family_id IN (
    SELECT fm.family_id FROM family_members fm
    WHERE fm.user_id = (SELECT auth.uid())
      AND fm.role = 'admin'
      AND fm.is_active = true
  )
);


-- ============================================================
-- PASO 2: Corregir families_insert — WITH CHECK demasiado permisivo
-- Problema: cualquier usuario (incluyendo anon) podía crear familias.
-- ============================================================

DROP POLICY IF EXISTS "families_insert" ON families;
DROP POLICY IF EXISTS "families_insert_autenticado" ON families;

CREATE POLICY "families_insert"
ON families FOR INSERT TO authenticated
WITH CHECK (
  -- Solo usuarios autenticados pueden crear una familia.
  -- El WITH CHECK (true) anterior permitía también a usuarios anónimos.
  (SELECT auth.uid()) IS NOT NULL
);


-- ============================================================
-- PASO 3: Corregir performance — auth.uid() re-evaluado por fila
-- Problema: llamar auth.uid() directamente en USING/WITH CHECK hace
-- que Postgres lo evalúe una vez POR FILA en lugar de una vez por query.
-- Solución: envolver en (SELECT auth.uid()) para convertirlo en init plan.
--
-- Aplica a las políticas "members_see_own_family" existentes en:
-- envelopes, transactions, kakeibo_reflections, sync_queue,
-- savings_goals, recurring_rules, accounts
-- Y a families_select, families_update, families_delete
-- ============================================================

-- ── families ─────────────────────────────────────────────────

DROP POLICY IF EXISTS "families_select" ON families;
CREATE POLICY "families_select"
ON families FOR SELECT TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM family_members
    WHERE family_members.family_id = families.id
      AND family_members.user_id   = (SELECT auth.uid())
      AND family_members.is_active = true
  )
);

DROP POLICY IF EXISTS "families_update" ON families;
CREATE POLICY "families_update"
ON families FOR UPDATE TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM family_members
    WHERE family_members.family_id = families.id
      AND family_members.user_id   = (SELECT auth.uid())
      AND family_members.role      IN ('admin', 'co_admin')
      AND family_members.is_active = true
  )
);

DROP POLICY IF EXISTS "families_delete" ON families;
CREATE POLICY "families_delete"
ON families FOR DELETE TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM family_members
    WHERE family_members.family_id = families.id
      AND family_members.user_id   = (SELECT auth.uid())
      AND family_members.role      = 'admin'
      AND family_members.is_active = true
  )
);

-- ── envelopes ─────────────────────────────────────────────────

DROP POLICY IF EXISTS "members_see_own_family" ON envelopes;
CREATE POLICY "members_see_own_family"
ON envelopes FOR ALL TO authenticated
USING (
  family_id IN (
    SELECT fm.family_id FROM family_members fm
    WHERE fm.user_id = (SELECT auth.uid()) AND fm.is_active = true
  )
)
WITH CHECK (
  family_id IN (
    SELECT fm.family_id FROM family_members fm
    WHERE fm.user_id = (SELECT auth.uid()) AND fm.is_active = true
  )
);

-- ── transactions ──────────────────────────────────────────────

DROP POLICY IF EXISTS "members_see_own_family" ON transactions;
CREATE POLICY "members_see_own_family"
ON transactions FOR ALL TO authenticated
USING (
  family_id IN (
    SELECT fm.family_id FROM family_members fm
    WHERE fm.user_id = (SELECT auth.uid()) AND fm.is_active = true
  )
)
WITH CHECK (
  family_id IN (
    SELECT fm.family_id FROM family_members fm
    WHERE fm.user_id = (SELECT auth.uid()) AND fm.is_active = true
  )
);

-- ── kakeibo_reflections ───────────────────────────────────────

DROP POLICY IF EXISTS "members_see_own_family" ON kakeibo_reflections;
CREATE POLICY "members_see_own_family"
ON kakeibo_reflections FOR ALL TO authenticated
USING (
  family_id IN (
    SELECT fm.family_id FROM family_members fm
    WHERE fm.user_id = (SELECT auth.uid()) AND fm.is_active = true
  )
)
WITH CHECK (
  family_id IN (
    SELECT fm.family_id FROM family_members fm
    WHERE fm.user_id = (SELECT auth.uid()) AND fm.is_active = true
  )
);

-- ── savings_goals ─────────────────────────────────────────────

DROP POLICY IF EXISTS "members_see_own_family" ON savings_goals;
CREATE POLICY "members_see_own_family"
ON savings_goals FOR ALL TO authenticated
USING (
  family_id IN (
    SELECT fm.family_id FROM family_members fm
    WHERE fm.user_id = (SELECT auth.uid()) AND fm.is_active = true
  )
)
WITH CHECK (
  family_id IN (
    SELECT fm.family_id FROM family_members fm
    WHERE fm.user_id = (SELECT auth.uid()) AND fm.is_active = true
  )
);

-- ── sync_queue ────────────────────────────────────────────────

DROP POLICY IF EXISTS "members_see_own_family" ON sync_queue;
CREATE POLICY "members_see_own_family"
ON sync_queue FOR ALL TO authenticated
USING (
  family_id IN (
    SELECT fm.family_id FROM family_members fm
    WHERE fm.user_id = (SELECT auth.uid()) AND fm.is_active = true
  )
)
WITH CHECK (
  family_id IN (
    SELECT fm.family_id FROM family_members fm
    WHERE fm.user_id = (SELECT auth.uid()) AND fm.is_active = true
  )
);

-- ── recurring_rules ───────────────────────────────────────────

DROP POLICY IF EXISTS "members_see_own_family" ON recurring_rules;
CREATE POLICY "members_see_own_family"
ON recurring_rules FOR ALL TO authenticated
USING (
  family_id IN (
    SELECT fm.family_id FROM family_members fm
    WHERE fm.user_id = (SELECT auth.uid()) AND fm.is_active = true
  )
)
WITH CHECK (
  family_id IN (
    SELECT fm.family_id FROM family_members fm
    WHERE fm.user_id = (SELECT auth.uid()) AND fm.is_active = true
  )
);

-- ── accounts ─────────────────────────────────────────────────

DROP POLICY IF EXISTS "members_see_own_family" ON accounts;
CREATE POLICY "members_see_own_family"
ON accounts FOR ALL TO authenticated
USING (
  family_id IN (
    SELECT fm.family_id FROM family_members fm
    WHERE fm.user_id = (SELECT auth.uid()) AND fm.is_active = true
  )
)
WITH CHECK (
  family_id IN (
    SELECT fm.family_id FROM family_members fm
    WHERE fm.user_id = (SELECT auth.uid()) AND fm.is_active = true
  )
);


-- ============================================================
-- PASO 4: Corregir función get_my_family_id — search_path mutable
-- Problema: sin search_path fijo, un atacante podría crear un schema
-- con objetos del mismo nombre para hacer hijacking de la función.
-- ============================================================

CREATE OR REPLACE FUNCTION public.get_my_family_id()
RETURNS uuid
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public          -- Fijar search_path para evitar hijacking
AS $$
  SELECT family_id
  FROM family_members
  WHERE user_id = (SELECT auth.uid())
    AND is_active = true
  LIMIT 1;
$$;


-- ============================================================
-- PASO 5: Índices en foreign keys (performance INFO)
-- Estos índices aceleran los JOINs y las verificaciones de FK.
-- ============================================================

-- accounts
CREATE INDEX IF NOT EXISTS idx_accounts_family_id
  ON accounts (family_id);
CREATE INDEX IF NOT EXISTS idx_accounts_owner_member_id
  ON accounts (owner_member_id);

-- envelopes
CREATE INDEX IF NOT EXISTS idx_envelopes_family_id
  ON envelopes (family_id);
CREATE INDEX IF NOT EXISTS idx_envelopes_assigned_member_id
  ON envelopes (assigned_member_id);

-- family_members
CREATE INDEX IF NOT EXISTS idx_family_members_invited_by
  ON family_members (invited_by);

-- kakeibo_reflections
CREATE INDEX IF NOT EXISTS idx_kakeibo_reflections_family_id
  ON kakeibo_reflections (family_id);
CREATE INDEX IF NOT EXISTS idx_kakeibo_reflections_member_id
  ON kakeibo_reflections (member_id);

-- recurring_rules
CREATE INDEX IF NOT EXISTS idx_recurring_rules_family_id
  ON recurring_rules (family_id);
CREATE INDEX IF NOT EXISTS idx_recurring_rules_envelope_id
  ON recurring_rules (envelope_id);
CREATE INDEX IF NOT EXISTS idx_recurring_rules_account_id
  ON recurring_rules (account_id);

-- savings_goals
CREATE INDEX IF NOT EXISTS idx_savings_goals_family_id
  ON savings_goals (family_id);

-- sync_queue
CREATE INDEX IF NOT EXISTS idx_sync_queue_family_id
  ON sync_queue (family_id);

-- transactions
CREATE INDEX IF NOT EXISTS idx_transactions_account_id
  ON transactions (account_id);
CREATE INDEX IF NOT EXISTS idx_transactions_registered_by
  ON transactions (registered_by);


-- ============================================================
-- PASO 6 (MANUAL EN UI — NO SQL):
-- Habilitar "Leaked Password Protection" en Supabase Auth
--
-- Ruta: app.supabase.com → Authentication → Settings →
--       Password section → activar "Enable Leaked Password Protection"
--
-- Esta opción verifica contraseñas contra HaveIBeenPwned.org
-- y no tiene equivalente en SQL.
-- ============================================================


-- ============================================================
-- VERIFICACIÓN FINAL
-- Ejecutar después del script para confirmar el estado.
-- ============================================================

-- 1. Confirmar que family_members tiene RLS activo
SELECT tablename, rowsecurity AS rls_activo
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename IN (
    'families','family_members','envelopes','transactions',
    'kakeibo_reflections','savings_goals','sync_queue',
    'recurring_rules','accounts'
  )
ORDER BY tablename;

-- 2. Confirmar que no quedan políticas con auth.uid() sin (SELECT ...)
-- (resultado vacío = todo corregido)
SELECT schemaname, tablename, policyname, qual, with_check
FROM pg_policies
WHERE schemaname = 'public'
  AND (qual LIKE '%auth.uid()%' OR with_check LIKE '%auth.uid()%')
  AND qual NOT LIKE '%(select auth.uid())%'
  AND with_check NOT LIKE '%(select auth.uid())%';
