import 'package:ecocollect/presentation/screens/authentification_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../helpers/fakes.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('fr_FR');
  });

  Widget build([
    FakeAuthService? auth,
    FakeUserRepository? userRepository,
  ]) {
    final env = FakeEnv(
      auth: auth,
      userRepository: userRepository,
    );
    return env.wrap(
      const MaterialApp(home: AuthentificationScreen()),
    );
  }

  testWidgets('E02 s\'affiche avec mode Connexion par défaut', (tester) async {
    await tester.pumpWidget(build());
    await tester.pumpAndSettle();

    expect(find.text('EcoCollect'), findsOneWidget);
    expect(find.text('Connexion'), findsOneWidget);
    expect(find.text('Inscription'), findsOneWidget);
    expect(find.text('Adresse e-mail'), findsOneWidget);
    expect(find.text('Mot de passe'), findsOneWidget);
    expect(find.text('Pseudo'), findsNothing);
    expect(find.text('Se connecter'), findsOneWidget);
  });

  testWidgets('E02 bascule vers Inscription → champ Pseudo visible',
      (tester) async {
    await tester.pumpWidget(build());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Inscription'));
    await tester.pumpAndSettle();

    expect(find.text('Pseudo'), findsWidgets);
    expect(find.text('Créer mon compte'), findsOneWidget);
    expect(find.text('Se connecter'), findsNothing);
  });

  testWidgets('E02 affiche l\'erreur email invalide', (tester) async {
    await tester.pumpWidget(build());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Adresse e-mail'),
      'invalide',
    );
    await tester.tap(find.text('Se connecter'));
    await tester.pumpAndSettle();

    expect(find.text('Adresse e-mail invalide'), findsOneWidget);
  });

  testWidgets('E02 affiche l\'erreur mot de passe court', (tester) async {
    await tester.pumpWidget(build());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Adresse e-mail'),
      'marie@ecocollect.ht',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Mot de passe'),
      'abc',
    );
    await tester.tap(find.text('Se connecter'));
    await tester.pumpAndSettle();

    expect(find.text('Minimum 6 caractères'), findsOneWidget);
  });

  testWidgets('E02 affiche l\'erreur pseudo manquant (inscription)',
      (tester) async {
    await tester.pumpWidget(build());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Inscription'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Adresse e-mail'),
      'marie@ecocollect.ht',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Mot de passe'),
      'motdepasse',
    );
    await tester.tap(find.text('Créer mon compte'));
    await tester.pumpAndSettle();

    expect(find.text('Ce champ est requis'), findsOneWidget);
  });

  testWidgets('E02 affiche l\'erreur serveur mappée (wrong-password)',
      (tester) async {
    final auth = FakeAuthService(
      signInError: FirebaseAuthException(code: 'wrong-password'),
    );
    await tester.pumpWidget(build(auth));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Adresse e-mail'),
      'marie@ecocollect.ht',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Mot de passe'),
      'motdepasse',
    );
    await tester.tap(find.text('Se connecter'));
    await tester.pumpAndSettle();

    expect(find.text('E-mail ou mot de passe incorrect.'), findsOneWidget);
  });
}