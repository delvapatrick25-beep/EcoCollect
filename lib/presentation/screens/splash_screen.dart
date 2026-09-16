import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../providers/service_providers.dart';
import '../widgets/loading_widget.dart';
import 'authentification_screen.dart';
import 'home_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future<void>.delayed(AppConstants.splashDuration);

    if (!mounted) return;

    final isAuthenticated =
        ref.read(authServiceProvider).currentUser != null;

    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => isAuthenticated
            ? const HomeScreen()
            : const AuthentificationScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primaryLight,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.recycling, size: 96, color: AppColors.primary),
              SizedBox(height: 16),
              Text(
                AppConstants.appName,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 8),
              Text(
                AppConstants.appTagline,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 32),
              LoadingWidget(),
            ],
          ),
        ),
      ),
    );
  }
}