-- ============================================================
-- KakeiboPro — Script RLS (Row Level Security) para Supabase
-- Fecha: 2026-04-01
-- Instrucciones: Ejecutar en app.supabase.com → SQL Editor
-- IMPORTANTE: Ejecutar en el orden en que aparece.
-- ============================================================


-- ============================================================
-- TABLA: families
-- Cualquier usuario autenticado puede crear una familia.
-- Solo los miembros activos pueden leer/modificar su familia.
-- ============================================================

ALTER TABLE families ENABLE ROW LEVEL SECURITY;

-- Leer: solo si eres miembro activo de esa familia
CREATE POLICY "families_select_miembro"
ON families FOR SELECT TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM family_members
    WHERE family_members.family_id = families.id
      AND family_members.user_id   = auth.uid()
      AND family_members.is_active = true
  )
);

-- Crear: cualquier usuario autenticado puede fundar una familia
CREATE POLICY "families_insert_autenticado"
ON families FOR INSERT TO authenticated
WITH CHECK (true);

-- Actualizar nombre: solo admins
CREATE POLICY "families_update_admin"
ON families FOR UPDATE TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM family_members
    WHERE family_members.family_id = families.id
      AND family_members.user_id   = auth.uid()
      AND family_members.role      IN ('admin', 'co_admin')
      AND family_members.is_active = true
  )
);

-- Eliminar familia: solo admin
CREATE POLICY "families_delete_admin"
ON families FOR DELETE TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM family_members
    WHERE family_members.family_id = families.id
      AND family_members.user_id   = auth.uid()
      AND family_members.role      = 'admin'
      AND family_members.is_active = true
  )
);


-- ============================================================
-- TABLA: family_members
-- Leer: miembros de tu propia familia O filas con token de
--       invitación (para que un nuevo usuario pueda aceptar).
-- ============================================================

ALTER TABLE family_members ENABLE ROW LEVEL SECURITY;

-- Leer propios datos + miembros de tu familia + invitaciones pendientes (por token)
CREATE POLICY "family_members_select"
ON family_members FOR SELECT TO authenticated
USING (
  -- Es tu propio registro
  user_id = auth.uid()
  OR
  -- Es miembro de tu misma familia
  family_id IN (
    SELECT fm.family_id FROM family_members fm
    WHERE fm.user_id = auth.uid() AND fm.is_active = true
  )
  OR
  -- Es una invitación pendiente (user_id null, token presente)
  -- Permite que cualquier autenticado lo vea para aceptar
  (user_id IS NULL AND invitation_token IS NOT NULL)
);

-- Insertar: admin/co_admin de la familia puede agregar miembros
CREATE POLICY "family_members_insert_admin"
ON family_members FOR INSERT TO authenticated
WITH CHECK (
  -- El creador puede insertar el primer miembro (a sí mismo como admin)
  -- O un admin puede invitar a otros
  auth.uid() IN (
    SELECT fm.user_id FROM family_members fm
    WHERE fm.family_id = family_members.family_id
      AND fm.role      IN ('admin', 'co_admin')
      AND fm.is_active = true
  )
  OR
  -- Auto-inserción del primer miembro al crear la familia
  NOT EXISTS (
    SELECT 1 FROM family_members fm2
    WHERE fm2.family_id = family_members.family_id
  )
);

-- Actualizar: admin puede modificar cualquier miembro;
--             el usuario puede actualizar su propio registro
--             (necesario para acceptInvitation)
CREATE POLICY "family_members_update"
ON family_members FOR UPDATE TO authenticated
USING (
  -- Es tu propio registro (para aceptar invitación)
  user_id = auth.uid()
  OR
  -- Eres admin/co_admin de esa familia
  family_id IN (
    SELECT fm.family_id FROM family_members fm
    WHERE fm.user_id = auth.uid()
      AND fm.role    IN ('admin', 'co_admin')
      AND fm.is_active = true
  )
  OR
  -- Fila de invitación pendiente (user_id null) — para que el invitado pueda reclamarla
  (user_id IS NULL AND invitation_token IS NOT NULL)
);

-- Eliminar: solo admins
CREATE POLICY "family_members_delete_admin"
ON family_members FOR DELETE TO authenticated
USING (
  family_id IN (
    SELECT fm.family_id FROM family_members fm
    WHERE fm.user_id = auth.uid()
      AND fm.role    = 'admin'
      AND fm.is_active = true
  )
);


-- ============================================================
-- TABLA: user_profiles
-- Cada usuario gestiona su propio perfil.
-- Los miembros de la misma familia pueden leer perfiles ajenos
-- (para mostrar nombres en la UI).
-- ============================================================

ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;

-- Leer: tu propio perfil o perfiles de miembros de tu familia
CREATE POLICY "user_profiles_select"
ON user_profiles FOR SELECT TO authenticated
USING (
  id = auth.uid()
  OR
  id IN (
    SELECT fm.user_id FROM family_members fm
    WHERE fm.family_id IN (
      SELECT fm2.family_id FROM family_members fm2
      WHERE fm2.user_id = auth.uid() AND fm2.is_active = true
    )
    AND fm.user_id IS NOT NULL
  )
);

-- Insertar y actualizar: solo tu propio perfil
CREATE POLICY "user_profiles_insert"
ON user_profiles FOR INSERT TO authenticated
WITH CHECK (id = auth.uid());

CREATE POLICY "user_profiles_update"
ON user_profiles FOR UPDATE TO authenticated
USING (id = auth.uid())
WITH CHECK (id = auth.uid());

-- Eliminar: solo tu propio perfil
CREATE POLICY "user_profiles_delete"
ON user_profiles FOR DELETE TO authenticated
USING (id = auth.uid());


-- ============================================================
-- TABLA: envelopes
-- Solo los miembros activos de la familia pueden operar sobres.
-- ============================================================

ALTER TABLE envelopes ENABLE ROW LEVEL SECURITY;

-- Helper reutilizable: ¿es el usuario miembro activo de esta familia?
-- (se repite en cada tabla para no depender de funciones externas)

CREATE POLICY "envelopes_select"
ON envelopes FOR SELECT TO authenticated
USING (
  family_id IN (
    SELECT fm.family_id FROM family_members fm
    WHERE fm.user_id = auth.uid() AND fm.is_active = true
  )
);

CREATE POLICY "envelopes_insert"
ON envelopes FOR INSERT TO authenticated
WITH CHECK (
  family_id IN (
    SELECT fm.family_id FROM family_members fm
    WHERE fm.user_id = auth.uid() AND fm.is_active = true
  )
);

CREATE POLICY "envelopes_update"
ON envelopes FOR UPDATE TO authenticated
USING (
  family_id IN (
    SELECT fm.family_id FROM family_members fm
    WHERE fm.user_id = auth.uid() AND fm.is_active = true
  )
);

CREATE POLICY "envelopes_delete"
ON envelopes FOR DELETE TO authenticated
USING (
  family_id IN (
    SELECT fm.family_id FROM family_members fm
    WHERE fm.user_id = auth.uid() AND fm.is_active = true
  )
);


-- ============================================================
-- TABLA: transactions
-- ============================================================

ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "transactions_select"
ON transactions FOR SELECT TO authenticated
USING (
  family_id IN (
    SELECT fm.family_id FROM family_members fm
    WHERE fm.user_id = auth.uid() AND fm.is_active = true
  )
);

CREATE POLICY "transactions_insert"
ON transactions FOR INSERT TO authenticated
WITH CHECK (
  family_id IN (
    SELECT fm.family_id FROM family_members fm
    WHERE fm.user_id = auth.uid() AND fm.is_active = true
  )
);

CREATE POLICY "transactions_update"
ON transactions FOR UPDATE TO authenticated
USING (
  family_id IN (
    SELECT fm.family_id FROM family_members fm
    WHERE fm.user_id = auth.uid() AND fm.is_active = true
  )
);

CREATE POLICY "transactions_delete"
ON transactions FOR DELETE TO authenticated
USING (
  family_id IN (
    SELECT fm.family_id FROM family_members fm
    WHERE fm.user_id = auth.uid() AND fm.is_active = true
  )
);


-- ============================================================
-- TABLA: kakeibo_reflections
-- ============================================================

ALTER TABLE kakeibo_reflections ENABLE ROW LEVEL SECURITY;

CREATE POLICY "reflections_select"
ON kakeibo_reflections FOR SELECT TO authenticated
USING (
  family_id IN (
    SELECT fm.family_id FROM family_members fm
    WHERE fm.user_id = auth.uid() AND fm.is_active = true
  )
);

CREATE POLICY "reflections_insert"
ON kakeibo_reflections FOR INSERT TO authenticated
WITH CHECK (
  family_id IN (
    SELECT fm.family_id FROM family_members fm
    WHERE fm.user_id = auth.uid() AND fm.is_active = true
  )
);

CREATE POLICY "reflections_update"
ON kakeibo_reflections FOR UPDATE TO authenticated
USING (
  family_id IN (
    SELECT fm.family_id FROM family_members fm
    WHERE fm.user_id = auth.uid() AND fm.is_active = true
  )
);

CREATE POLICY "reflections_delete"
ON kakeibo_reflections FOR DELETE TO authenticated
USING (
  family_id IN (
    SELECT fm.family_id FROM family_members fm
    WHERE fm.user_id = auth.uid() AND fm.is_active = true
  )
);


-- ============================================================
-- TABLA: savings_goals
-- ============================================================

ALTER TABLE savings_goals ENABLE ROW LEVEL SECURITY;

CREATE POLICY "savings_goals_select"
ON savings_goals FOR SELECT TO authenticated
USING (
  family_id IN (
    SELECT fm.family_id FROM family_members fm
    WHERE fm.user_id = auth.uid() AND fm.is_active = true
  )
);

CREATE POLICY "savings_goals_insert"
ON savings_goals FOR INSERT TO authenticated
WITH CHECK (
  family_id IN (
    SELECT fm.family_id FROM family_members fm
    WHERE fm.user_id = auth.uid() AND fm.is_active = true
  )
);

CREATE POLICY "savings_goals_update"
ON savings_goals FOR UPDATE TO authenticated
USING (
  family_id IN (
    SELECT fm.family_id FROM family_members fm
    WHERE fm.user_id = auth.uid() AND fm.is_active = true
  )
);

CREATE POLICY "savings_goals_delete"
ON savings_goals FOR DELETE TO authenticated
USING (
  family_id IN (
    SELECT fm.family_id FROM family_members fm
    WHERE fm.user_id = auth.uid() AND fm.is_active = true
  )
);


-- ============================================================
-- VERIFICACIÓN — Ejecutar después de aplicar las políticas
-- para confirmar que RLS quedó activo en todas las tablas.
-- ============================================================

SELECT
  tablename,
  rowsecurity AS rls_activo
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename IN (
    'families',
    'family_members',
    'user_profiles',
    'envelopes',
    'transactions',
    'kakeibo_reflections',
    'savings_goals'
  )
ORDER BY tablename;

-- Resultado esperado: rls_activo = true en todas las filas.
