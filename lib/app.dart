import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'presentation/screens/splash_screen.dart';

class EcoCollectApp extends ConsumerWidget {
  const EcoCollectApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness =
        ref.watch(themeModeProvider).value == ThemeMode.dark
            ? Brightness.dark
            : Brightness.light;

    // AppColors must use the correct brightness before any descendant reads it.
    AppColors.useBrightness(brightness);

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}