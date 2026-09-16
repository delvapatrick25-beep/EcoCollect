import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

class Validators {
  Validators._();

  static final RegExp _emailRegExp = RegExp(
    r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$',
  );

  static String? validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Adresse e-mail requise';
    if (!_emailRegExp.hasMatch(email)) return 'Adresse e-mail invalide';
    return null;
  }

  static String? validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Mot de passe requis';
    if (password.length < AppConstants.passwordMinLength) {
      return 'Minimum ${AppConstants.passwordMinLength} caractères';
    }
    return null;
  }

  static String? validateRequired(
    String? value, {
    String fieldName = 'Ce champ',
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName est requis';
    }
    return null;
  }

  static String? validateDescription(String? value) {
    final description = value?.trim() ?? '';
    if (description.isEmpty) return 'Veuillez décrire le problème';
    if (description.length < 10) return 'Au moins 10 caractères';
    return null;
  }

  static InputDecoration? decoration(
    String label, {
    InputDecoration? base,
  }) =>
      base?.copyWith(labelText: label);
}