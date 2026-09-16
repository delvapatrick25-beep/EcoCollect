import 'package:ecocollect/app.dart';
import 'package:ecocollect/domain/services/auth_service.dart';
import 'package:ecocollect/presentation/providers/service_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthService implements AuthService {
  @override
  User? get currentUser => null;

  @override
  Stream<User?> get authStateChanges => Stream.value(null);

  @override
  Future<UserCredential> signIn(String email, String password) {
    throw UnimplementedError();
  }

  @override
  Future<UserCredential> signUp(String email, String password) {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() async {}
}

void main() {
  testWidgets('L:application se lance sur le SplashScreen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authServiceProvider.overrideWithValue(_FakeAuthService()),
        ],
        child: const EcoCollectApp(),
      ),
    );

    expect(find.byType(Icon), findsWidgets);
    expect(find.textContaining('EcoCollect'), findsOneWidget);
    expect(find.textContaining('éco-responsable'), findsOneWidget);

    await tester.pumpAndSettle();
  });
}