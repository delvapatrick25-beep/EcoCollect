import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static bool _isDark = false;

  /// A appeler une fois au démarrage (ou au changement de thème) pour que les
  /// couleurs neutres s'adaptent au mode clair/sombre.
  static void useBrightness(Brightness brightness) {
    _isDark = brightness == Brightness.dark;
  }

  // Couleurs de marque constantes
  static const Color primaryBrand = Color(0xFF2E7D32);
  static const Color accentBrand = Color(0xFFFF6F00);

  // Palettes fonctionnelles
  static Color get primary => _isDark ? const Color(0xFF81C784) : const Color(0xFF2E7D32);
  static Color get onPrimary => _isDark ? const Color(0xFF00390A) : Colors.white;
  
  static Color get primaryContainer => _isDark ? const Color(0xFF005313) : const Color(0xFFE8F5E9);
  static Color get onPrimaryContainer => _isDark ? const Color(0xFF9DF49F) : const Color(0xFF002104);

  static Color get secondary => _isDark ? const Color(0xFFA5D6A7) : const Color(0xFF558B2F);
  static Color get secondaryContainer => _isDark ? const Color(0xFF2F3D25) : const Color(0xFFDCEDC8);
  static Color get onSecondaryContainer => _isDark ? const Color(0xFFD7E8CD) : const Color(0xFF131F0C);

  static Color get surface => _isDark ? const Color(0xFF1A1C19) : Colors.white;
  static Color get background => _isDark ? const Color(0xFF111411) : const Color(0xFFF5F5F5);
  static Color get surfaceVariant => _isDark ? const Color(0xFF424940) : const Color(0xFFE0E0E0);
  static Color get onSurfaceVariant => _isDark ? const Color(0xFFC2C8BC) : const Color(0xFF757575);

  static Color get textPrimary => _isDark ? const Color(0xFFE2E3DE) : const Color(0xFF212121);
  static Color get textSecondary => _isDark ? const Color(0xFFC2C8BC) : const Color(0xFF757575);
  static Color get border => _isDark ? const Color(0xFF424940) : const Color(0xFFBDBDBD);

  static Color get error => const Color(0xFFBA1A1A);
}