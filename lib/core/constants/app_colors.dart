import 'package:flutter/material.dart';

/// Paleta de colores de KakeiboPro.
///
/// Todos los valores son constantes para garantizar rendimiento en tiempo
/// de compilación y coherencia visual en toda la aplicación.
class AppColors {
  AppColors._(); // Clase no instanciable

  // ── Fondos ──────────────────────────────────────────────────────────────
  static const Color background = Color(0xFF0B1120);
  static const Color surface = Color(0xFF121C2E);
  static const Color surfaceVariant = Color(0xFF1A2740);
  static const Color border = Color(0xFF1E3050);

  // ── Acentos ─────────────────────────────────────────────────────────────
  static const Color green = Color(0xFF3DD68C);
  static const Color blue = Color(0xFF5B9CF6);
  static const Color gold = Color(0xFFF5C842);

  // ── Texto ────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFDDE4F0);
  static const Color textMuted = Color(0xFF5A7090);

  // ── Estados ──────────────────────────────────────────────────────────────
  static const Color error = Color(0xFFEF5350);
}
