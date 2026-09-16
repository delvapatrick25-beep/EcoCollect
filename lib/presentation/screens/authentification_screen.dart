import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/auth_error_map.dart';
import '../../core/utils/validators.dart';
import '../../data/models/user_account.dart';
import '../providers/service_providers.dart';
import 'home_screen.dart';

enum _AuthMode { signIn, signUp }

class AuthentificationScreen extends ConsumerStatefulWidget {
  const AuthentificationScreen({super.key});

  @override
  ConsumerState<AuthentificationScreen> createState() =>
      _AuthentificationScreenState();
}

class _AuthentificationScreenState extends ConsumerState<AuthentificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _pseudoController = TextEditingController();

  _AuthMode _mode = _AuthMode.signIn;
  bool _obscurePassword = true;
  bool _submitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _pseudoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.recycling,
                    size: 72,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    AppConstants.appName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildModeSwitcher(),
                  const SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildEmailField(),
                        const SizedBox(height: 12),
                        _buildPasswordField(),
                        if (_mode == _AuthMode.signUp) ...[
                          const SizedBox(height: 12),
                          _buildPseudoField(),
                        ],
                        const SizedBox(height: 20),
                        if (_errorMessage != null) ...[
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.error),
                          ),
                          const SizedBox(height: 12),
                        ],
                        _buildSubmitButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModeSwitcher() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _buildModeTab(
            label: 'Se connecter',
            selected: _mode == _AuthMode.signIn,
            onTap: () => setState(() {
              _mode = _AuthMode.signIn;
              _errorMessage = null;
            }),
          ),
          _buildModeTab(
            label: 'Créer un compte',
            selected: _mode == _AuthMode.signUp,
            onTap: () => setState(() {
              _mode = _AuthMode.signUp;
              _errorMessage = null;
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildModeTab({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? Colors.white : AppColors.primaryDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: Validators.validateEmail,
      decoration: const InputDecoration(
        labelText: 'Adresse e-mail',
        prefixIcon: Icon(Icons.email_outlined),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      textInputAction: _mode == _AuthMode.signUp
          ? TextInputAction.next
          : TextInputAction.done,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: Validators.validatePassword,
      onFieldSubmitted: (_) => _mode == _AuthMode.signIn ? _submit() : null,
      decoration: InputDecoration(
        labelText: 'Mot de passe',
        prefixIcon: const Icon(Icons.lock_outline),
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () =>
              setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
    );
  }

  Widget _buildPseudoField() {
    return TextFormField(
      controller: _pseudoController,
      textInputAction: TextInputAction.done,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: Validators.validateRequired,
      onFieldSubmitted: (_) => _submit(),
      decoration: const InputDecoration(
        labelText: 'Pseudo (salutation)',
        prefixIcon: Icon(Icons.person_outline),
        border: OutlineInputBorder(),
        filled: true,
        fillColor: AppColors.primaryLight,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return FilledButton(
      onPressed: _submitting ? null : _submit,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: _submitting
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(
              _mode == _AuthMode.signIn
                  ? 'Se connecter'
                  : 'Créer un compte',
              style: const TextStyle(fontSize: 16),
            ),
    );
  }

  Future<void> _submit() async {
    if (_submitting) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _submitting = true;
      _errorMessage = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      final authService = ref.read(authServiceProvider);
      final userRepository = ref.read(userRepositoryProvider);

      if (_mode == _AuthMode.signUp) {
        final credential =
            await authService.signUp(email, password);
        final uid = credential.user!.uid;
        await userRepository.save(
          UserAccount(
            uid: uid,
            email: email,
            pseudo: _pseudoController.text.trim(),
            createdAt: DateTime.now(),
          ),
        );
      } else {
        await authService.signIn(email, password);
      }

      if (!mounted) return;

      await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _errorMessage = mapAuthError(e);
      });
    }
  }
}