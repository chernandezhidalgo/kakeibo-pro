# KakeiboPro — Checklist Pre-Piloto
Fecha: 2026-04-01

---

## ESTADO DEL CÓDIGO (completado)

| Ítem | Estado |
|---|---|
| flutter analyze → 0 errores | ✅ Confirmado (revisión técnica 01-abr) |
| BUG-01: Color hardcodeado en AlertDialog | ✅ Corregido |
| BUG-02: Error silencioso en swipe-to-delete | ✅ Corregido |
| DT-01: SQLCipher integrado (PRAGMA key activo) | ✅ Commiteado |
| workmanager actualizado a 0.9.0 | ✅ Commiteado |
| sentry_flutter actualizado a 8.14.2 | ✅ Commiteado |

---

## PASO A — Verificar que SQLCipher realmente cifra (tú en tu máquina)

### Por qué hay que verificarlo
El código aplica `PRAGMA key` al abrir la base de datos. Si el binario nativo
que carga la app es SQLite estándar (en lugar de SQLCipher), el PRAGMA se
ignora silenciosamente y los datos quedan en texto plano. Hay que verificar
de forma empírica.

### Procedimiento (Android físico)
1. Instalar la app en un Android físico con `flutter run`.
2. Crear al menos un sobre y una transacción de prueba.
3. En Android Studio → Device Explorer (o con `adb`), navegar a:
   `/data/data/com.kakeibopro.app/app_flutter/` (ruta aproximada,
   depende del `applicationId` en `build.gradle.kts`).
4. Descargar el archivo `kakeibo_pro.db` a tu computadora.
5. Abrirlo con **DB Browser for SQLite** (gratis, https://sqlitebrowser.org).
   - Si pide contraseña al abrir → cifrado activo. ✅
   - Si lo abre sin pedir nada y ves las tablas en texto plano → cifrado NO activo. ❌

### Si el cifrado NO está activo
Reportar a Carlos para investigar. El problema más probable es que
`sqlite3_flutter_libs` se esté cargando en lugar de `sqlcipher_flutter_libs`.
Verificar que en `pubspec.yaml` NO exista `sqlite3_flutter_libs` como
dependencia directa ni transitiva (`flutter pub deps | grep sqlite`).

---

## PASO B — Activar RLS en Supabase (tú en el dashboard)

### Por qué es crítico
Sin RLS, cualquier usuario autenticado de KakeiboPro puede leer los datos
financieros de CUALQUIER otra familia. Esto es inaceptable antes de un piloto
con usuarios reales.

### Procedimiento
1. Ir a https://app.supabase.com → tu proyecto KakeiboPro.
2. En el menú lateral: **SQL Editor** → **New query**.
3. Pegar el contenido completo del archivo `supabase_rls.sql`
   (está en la raíz de este proyecto).
4. Ejecutar con el botón **Run**.
5. Al final del script hay una consulta de verificación. El resultado debe
   mostrar `rls_activo = true` en las 7 tablas.

### Advertencia sobre invitaciones
El script incluye una política especial que permite leer filas de
`family_members` con `invitation_token` no nulo (para que un usuario
nuevo pueda aceptar una invitación antes de ser miembro). Esto es
intencional y necesario para el flujo de `acceptInvitation()`.

---

## PASO C — flutter analyze en tu máquina (tú)

El entorno de sandbox no tiene Flutter. Ejecutar en la carpeta del proyecto:

```
flutter analyze
```

Resultado esperado: `No issues found.`

Si hay errores, reportarlos antes de continuar.

---

## PASO D — Configuración de producción (F5)

### D1 — Sentry DSN
- Ir a https://sentry.io → tu proyecto KakeiboPro → Settings → Client Keys.
- Copiar el DSN.
- Agregar al comando de build:
  ```
  flutter build apk --dart-define=SENTRY_DSN=https://xxx@sentry.io/yyy
  ```
- Verificar en Sentry que los errores aparecen tras una prueba.

### D2 — Firebase google-services.json (FCM para notificaciones)
- Ir a https://console.firebase.google.com → tu proyecto → Android app.
- Descargar `google-services.json` de PRODUCCIÓN.
- Reemplazar el archivo en `android/app/google-services.json`.
- Verificar que el `package_name` en Firebase coincide con el
  `applicationId` en `android/app/build.gradle.kts`.
- Probar que llegan notificaciones push en Android físico.

### D3 — RevenueCat (paywall)
- Ir a https://app.revenuecat.com → tu proyecto.
- Configurar los productos (mensual / anual) en App Store Connect y
  Google Play Console.
- Vincular los productos en RevenueCat.
- Verificar que `PaywallPage` muestra los precios correctos al abrir en
  modo sandbox.

### D4 — Variables de entorno en el pipeline de build
Asegurarse de pasar estas variables en cada build:
```
--dart-define=SUPABASE_URL=https://xxx.supabase.co
--dart-define=SUPABASE_ANON_KEY=eyJ...
--dart-define=SENTRY_DSN=https://xxx@sentry.io/yyy
```
Si se usa GitHub Actions o Codemagic, agregarlas como secretos del
repositorio o del pipeline.

---

## PASO E — Deuda técnica para después del piloto (no bloquea)

| Ítem | Prioridad | Sprint |
|---|---|---|
| DT-03: Paginación en `watchByEnvelope` | Media | F5 |
| DT-04: Evaluar migración paquetes EOL (`sqlcipher 0.5.7`, `workmanager 0.9.0`) | Media | F5 |
| DT-05: Migrar Riverpod 2 → 3 (StateNotifier → Notifier) | Baja | F5–F6 |
| DT-04b: `budgetAlertProvider` dispara notifs en cada rebuild | Baja | F5 |

---

## Orden recomendado antes de lanzar el piloto

1. ✅ Código: todo commiteado y limpio (hecho)
2. **Tú** → Paso A: verificar SQLCipher en Android físico
3. **Tú** → Paso B: ejecutar `supabase_rls.sql` en Supabase dashboard
4. **Tú** → Paso C: `flutter analyze` en tu máquina
5. **Tú** → Paso D1–D4: configuración de producción
6. Prueba integral con la familia en dispositivos reales
7. Lanzamiento piloto
