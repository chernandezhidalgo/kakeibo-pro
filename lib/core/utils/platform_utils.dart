import 'package:flutter/foundation.dart';

/// Utilidades para detectar la plataforma y adaptar la UI.
///
/// Centraliza las decisiones de plataforma para evitar repetir
/// `Platform.isWindows` disperso por el código.
abstract final class PlatformUtils {
  /// True si la app está corriendo en Windows.
  static bool get isWindows =>
      defaultTargetPlatform == TargetPlatform.windows && !kIsWeb;

  /// True si la app está corriendo en macOS.
  static bool get isMacOS =>
      defaultTargetPlatform == TargetPlatform.macOS && !kIsWeb;

  /// True si la app está corriendo en Linux.
  static bool get isLinux =>
      defaultTargetPlatform == TargetPlatform.linux && !kIsWeb;

  /// True si la app corre en cualquier escritorio (Windows, macOS o Linux).
  static bool get isDesktop => isWindows || isMacOS || isLinux;

  /// True si la app corre en móvil (Android o iOS).
  static bool get isMobile =>
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  /// Determina si se debe usar [NavigationRail] en lugar de [NavigationBar].
  ///
  /// En escritorio el ancho de ventana suele superar 600 px y el rail lateral
  /// es más ergonómico. En móvil se mantiene la barra inferior.
  static bool get useRailNavigation => isDesktop;
}
