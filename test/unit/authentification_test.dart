import 'package:ecocollect/core/constants/app_constants.dart';
import 'package:ecocollect/core/utils/auth_error_map.dart';
import 'package:ecocollect/core/utils/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators · email', () {
    test('email valide → null', () {
      expect(Validators.validateEmail('marie@ecocollect.ht'), isNull);
      expect(Validators.validateEmail('a.b@ecocollect.ht'), isNull);
    });

    test('email vide → "Adresse e-mail requise"', () {
      expect(Validators.validateEmail(''), 'Adresse e-mail requise');
      expect(Validators.validateEmail('   '), 'Adresse e-mail requise');
      expect(Validators.validateEmail(null), 'Adresse e-mail requise');
    });

    test('email invalide → "Adresse e-mail invalide"', () {
      expect(Validators.validateEmail('invalide'), 'Adresse e-mail invalide');
      expect(Validators.validateEmail('a@b'), 'Adresse e-mail invalide');
      expect(Validators.validateEmail('x@y.t'), 'Adresse e-mail invalide');
    });
  });

  group('Validators · mot de passe', () {
    test('mot de passe ≥ 6 → null', () {
      expect(
        Validators.validatePassword('a' * AppConstants.passwordMinLength),
        isNull,
      );
    });

    test('mot de passe court → "Minimum 6 caractères"', () {
      expect(
        Validators.validatePassword('12345'),
        'Minimum ${AppConstants.passwordMinLength} caractères',
      );
    });

    test('mot de passe vide → "Mot de passe requis"', () {
      expect(Validators.validatePassword(''), 'Mot de passe requis');
      expect(Validators.validatePassword(null), 'Mot de passe requis');
    });
  });

  group('Validators · pseudo', () {
    test('pseudo non vide → null', () {
      expect(Validators.validateRequired('Marie'), isNull);
      expect(Validators.validateRequired('  Marie '), isNull);
    });

    test('pseudo vide → champ requis', () {
      expect(Validators.validateRequired(''), 'Ce champ est requis');
      expect(Validators.validateRequired(null), 'Ce champ est requis');
      expect(
        Validators.validateRequired('   ', fieldName: 'Pseudo'),
        'Pseudo est requis',
      );
    });
  });

  group('Validators · description', () {
    test('description ≥ 10 → null', () {
      expect(Validators.validateDescription('dépôt sauvage au nord'), isNull);
    });

    test('description vide → "Veuillez décrire le problème"', () {
      expect(
        Validators.validateDescription(''),
        'Veuillez décrire le problème',
      );
      expect(Validators.validateDescription(null), 'Veuillez décrire le problème');
    });

    test('description < 10 → "Au moins 10 caractères"', () {
      expect(Validators.validateDescription('abcde'), 'Au moins 10 caractères');
    });
  });

  group('mapAuthError · mapping des codes Firebase', () {
    test('user-not-found / wrong-password / invalid-credential', () {
      for (final code in ['user-not-found', 'wrong-password', 'invalid-credential']) {
        expect(
          mapAuthError(FirebaseAuthException(code: code)),
          'E-mail ou mot de passe incorrect.',
        );
      }
    });

    test('invalid-email', () {
      expect(
        mapAuthError(FirebaseAuthException(code: 'invalid-email')),
        'Adresse e-mail invalide.',
      );
    });

    test('user-disabled', () {
      expect(
        mapAuthError(FirebaseAuthException(code: 'user-disabled')),
        'Ce compte a été désactivé.',
      );
    });

    test('email-already-in-use', () {
      expect(
        mapAuthError(FirebaseAuthException(code: 'email-already-in-use')),
        'Un compte existe déjà avec cet e-mail.',
      );
    });

    test('weak-password', () {
      expect(
        mapAuthError(FirebaseAuthException(code: 'weak-password')),
        'Mot de passe trop faible (6 caractères minimum).',
      );
    });

    test('network-request-failed', () {
      expect(
        mapAuthError(FirebaseAuthException(code: 'network-request-failed')),
        'Connexion Internet requise.',
      );
    });

    test('code inconnu → message de l\'exception', () {
      final error = FirebaseAuthException(code: 'unknown', message: 'boom');
      expect(mapAuthError(error), 'boom');
    });

    test('exception non Firebase → message générique', () {
      expect(mapAuthError(StateError('net')), 'Une erreur est survenue. Réessayez.');
    });
  });
}