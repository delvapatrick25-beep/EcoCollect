import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static bool _isDark = false;

  /// A appeler une fois au démarrage (ou au changement de thème) pour que les
  /// couleurs neutres s'adaptent au mode clair/sombre.
  static void useBrightness(Brightness brightness) {
    _isDark = brightness == Brightness.dark;
  }

  // Marques (identiques en clair et sombre pour garder l'identité visuelle).
  static const Color primary = Color(0xFF2E7D32);
  static const Color accent = Color(0xFFFF6F00);
  static const Color error = Color(0xFFC62828);

  static Color get primaryDark => _isDark ? Color(0xFF81C784) : Color(0xFF1B5E20);
  static Color get primaryLight => _isDark ? Color(0xFF2E5B32) : Color(0xFFE8F5E9);
  static Color get primaryLighter => _isDark ? Color(0xFF1F4A24) : Color(0xFFC8E6C9);

  static Color get secondary => _isDark ? Color(0xFFA5D6A7) : Color(0xFF558B2F);
  static Color get secondaryContainer => _isDark ? Color(0xFF2F3D25) : Color(0xFFDCEDC8);

  static Color get accentContainer => _isDark ? Color(0xFF4A3200) : Color(0xFFFFE0B2);

  static Color get surface => _isDark ? Color(0xFF1E1E1E) : Colors.white;
  static Color get surfaceVariant => _isDark ? Color(0xFF3A3A3A) : Color(0xFFE0E0E0);
  static Color get background => _isDark ? Color(0xFF121212) : Color(0xFFF5F5F5);

  static Color get textPrimary => _isDark ? Color(0xFFE8E8E8) : Color(0xFF212121);
  static Color get textSecondary => _isDark ? Color(0xFFB0B0B0) : Color(0xFF757575);
  static Color get textDisabled => _isDark ? Color(0xFF6A6A6A) : Color(0xFF9E9E9E);
  static Color get border => _isDark ? Color(0xFF525252) : Color(0xFFBDBDBD);
}