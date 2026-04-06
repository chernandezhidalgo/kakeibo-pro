# KakeiboPro — Checklist de lanzamiento piloto
## Actualizado: Abril 2026

---

## ✅ SERVICIOS EXTERNOS CONFIGURADOS

| Servicio | Estado | Notas |
|---|---|---|
| Firebase FCM | ✅ Completo | SHA-1 registrado, google-services.json correcto |
| RevenueCat | ✅ Completo | Entitlements, productos y offerings configurados |
| Google Play Console | 🔄 Parcial | Faltan imágenes, clasificación, política privacidad |
| Microsoft Partner Center | 🔄 Parcial | Faltan captura de pantalla, correo Berta, .msix |
| Azure MSAL | ✅ Completo | Permisos Mail.Read, offline_access, User.Read |

---

## 🔄 PENDIENTES MANUALES (Carlos debe hacer)

### Google Play Console
- [ ] Subir ícono 512x512 px (crear en Canva)
- [ ] Subir gráfico de funciones 1024x500 px (crear en Canva)
- [ ] Subir mínimo 2 capturas de pantalla
- [ ] Completar clasificación de contenido (Finanzas → Todo público)
- [ ] Agregar URL de política de privacidad (usar archivo generado en web/privacy_policy.html)
- [ ] Configurar precios y distribución (gratis, Costa Rica)
- [ ] Agregar bromeror@gmail.com a lista "Familia Piloto"

### Microsoft Partner Center
- [ ] Subir al menos 1 captura de pantalla
- [ ] Agregar bromeror@gmail.com a grupo "Familia Piloto"
- [ ] Subir .msix cuando esté generado

### Keystore
- [ ] Reemplazar REEMPLAZAR_CON_TU_CONTRASENA en android/key.properties con la contraseña real

---

## Prueba interna — Probadores pendientes de agregar manualmente

### Google Play Console
- Lista: "Familia Piloto"
- Correo pendiente de agregar: bromeror@gmail.com
- Ruta: Play Console → Pruebas → Prueba interna → Familia Piloto → editar lista

### Microsoft Partner Center
- Lista: "Familia Piloto"
- Correo pendiente de agregar: bromeror@gmail.com
- Ruta: Partner Center → Aplicaciones y juegos → KakeiboPro → Grupos de clientes → Familia Piloto

---

## ✅ DESARROLLO COMPLETADO

| Módulo | Estado |
|---|---|
| Auth + registro de usuario | ✅ |
| Creación de familia | ✅ |
| Dashboard principal | ✅ |
| Navegación (Sobres, Resumen, Kakeibo, IA, Perfil) | ✅ |
| Base de datos local Drift + SQLCipher | ✅ |
| Sincronización Supabase | ✅ |

---

## ⏳ PRÓXIMOS PASOS DE DESARROLLO

1. Generar primer AAB (Android App Bundle) para prueba interna
2. Generar primer MSIX para Windows
3. Completar módulo de sobres (crear, editar, eliminar)
4. Implementar parser CSV Banco Nacional y BAC
5. Revisar y corregir RLS de family_members en Supabase
