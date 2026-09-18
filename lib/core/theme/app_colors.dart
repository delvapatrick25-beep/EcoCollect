import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static bool _isDark = false;

  /// A appeler une fois au démarrage (ou au changement de thème) pour que les
  /// couleurs neutres s'adaptent au mode clair/sombre.
  static void useBrightness(Brightness brightness) {
    _isDark = brightness == Brightness.dark;
  }

  static bool get isDark => _isDark;

  /// Texte et icônes de la barre d'application : blanc dans les deux modes.
  static Color get onAppBar => Colors.white;

  // Couleurs de marque constantes (identité visuelle identique clair/sombre).
  static const Color primaryBrand = Color(0xFF2E7D32);
  static const Color accentBrand = Color(0xFFFF6F00);

  // Primaire
  static Color get primary => _isDark ? const Color(0xFF81C784) : primaryBrand;
  static Color get onPrimary =>
      _isDark ? const Color(0xFF00390A) : Colors.white;
  static Color get primaryContainer =>
      _isDark ? const Color(0xFF005313) : const Color(0xFFE8F5E9);
  static Color get onPrimaryContainer =>
      _isDark ? const Color(0xFF9DF49F) : const Color(0xFF002104);

  // Secondaire
  static Color get secondary =>
      _isDark ? const Color(0xFFA5D6A7) : const Color(0xFF558B2F);
  static Color get onSecondary =>
      _isDark ? const Color(0xFF00390E) : Colors.white;
  static Color get secondaryContainer =>
      _isDark ? const Color(0xFF2F3D25) : const Color(0xFFDCEDC8);
  static Color get onSecondaryContainer =>
      _isDark ? const Color(0xFFD7E8CD) : const Color(0xFF131F0C);

  // Tertiaire (accent)
  static Color get tertiary => _isDark ? const Color(0xFFFFB74D) : accentBrand;
  static Color get onTertiary =>
      _isDark ? const Color(0xFF4A2800) : Colors.white;
  static Color get tertiaryContainer =>
      _isDark ? const Color(0xFF6D3C00) : const Color(0xFFFFE0B2);
  static Color get onTertiaryContainer =>
      _isDark ? const Color(0xFFFFDDB3) : const Color(0xFF3B1D00);

  // Surfaces et fonds
  static Color get surface => _isDark ? const Color(0xFF1A1C19) : Colors.white;
  static Color get card => _isDark ? const Color(0xFF1E1E1E) : Colors.white;
  static Color get background =>
      _isDark ? const Color(0xFF111411) : const Color(0xFFF5F5F5);
  static Color get surfaceContainerHighest =>
      _isDark ? const Color(0xFF424940) : const Color(0xFFE0E0E0);
  static Color get onSurfaceVariant =>
      _isDark ? const Color(0xFFC2C8BC) : const Color(0xFF757575);

  // Textes
  static Color get textPrimary =>
      _isDark ? const Color(0xFFE2E3DE) : const Color(0xFF212121);
  static Color get textSecondary =>
      _isDark ? const Color(0xFFC2C8BC) : const Color(0xFF757575);
  static Color get border =>
      _isDark ? const Color(0xFF424940) : const Color(0xFFBDBDBD);

  // États
  static Color get error =>
      _isDark ? const Color(0xFFFFB4AB) : const Color(0xFFBA1A1A);
  static Color get onError => _isDark ? const Color(0xFF690005) : Colors.white;
}
