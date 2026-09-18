import 'package:flutter/material.dart';


class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return _build(ColorScheme.light(
      primary: const Color(0xFF2E7D32),
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFE8F5E9),
      onPrimaryContainer: const Color(0xFF002104),
      secondary: const Color(0xFF558B2F),
      onSecondary: Colors.white,
      secondaryContainer: const Color(0xFFDCEDC8),
      onSecondaryContainer: const Color(0xFF131F0C),
      tertiary: const Color(0xFFFF6F00),
      onTertiary: Colors.white,
      tertiaryContainer: const Color(0xFFFFE0B2),
      error: const Color(0xFFBA1A1A),
      onError: Colors.white,
      surface: Colors.white,
      onSurface: const Color(0xFF212121),
      surfaceVariant: const Color(0xFFE0E0E0),
      onSurfaceVariant: const Color(0xFF757575),
      outline: const Color(0xFFBDBDBD),
    ));
  }

  static ThemeData get dark {
    return _build(ColorScheme.dark(
      primary: const Color(0xFF81C784),
      onPrimary: const Color(0xFF00390A),
      primaryContainer: const Color(0xFF005313),
      onPrimaryContainer: const Color(0xFF9DF49F),
      secondary: const Color(0xFFA5D6A7),
      onSecondary: const Color(0xFF00390E),
      secondaryContainer: const Color(0xFF2F3D25),
      onSecondaryContainer: const Color(0xFFD7E8CD),
      tertiary: const Color(0xFFFFB74D),
      onTertiary: const Color(0xFF4A2800),
      tertiaryContainer: const Color(0xFF6D3C00),
      onTertiaryContainer: const Color(0xFFFFDDB3),
      error: const Color(0xFFFFB4AB),
      onError: const Color(0xFF690005),
      surface: const Color(0xFF1A1C19),
      onSurface: const Color(0xFFE2E3DE),
      surfaceVariant: const Color(0xFF424940),
      onSurfaceVariant: const Color(0xFFC2C8BC),
      outline: const Color(0xFF8C9388),
    ));
  }

  static ThemeData _build(ColorScheme scheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.background,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        color: scheme.surface,
        margin: const EdgeInsets.symmetric(vertical: 8),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        labelStyle: TextStyle(color: scheme.onSurfaceVariant),
        prefixIconColor: scheme.onSurfaceVariant,
        suffixIconColor: scheme.onSurfaceVariant,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: scheme.onPrimaryContainer);
          }
          return IconThemeData(color: scheme.onSurfaceVariant);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final style = const TextStyle(fontSize: 12, fontWeight: FontWeight.w500);
          if (states.contains(WidgetState.selected)) {
            return style.copyWith(color: scheme.onSurface);
          }
          return style.copyWith(color: scheme.onSurfaceVariant);
        }),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: scheme.onSurface,
        ),
        subtitleTextStyle: TextStyle(
          fontSize: 14,
          color: scheme.onSurfaceVariant,
        ),
        iconColor: scheme.primary,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceVariant,
        labelStyle: TextStyle(color: scheme.onSurfaceVariant),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: BorderSide.none,
      ),
    );
  }
}