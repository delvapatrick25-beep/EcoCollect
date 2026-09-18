import 'package:ecocollect/app.dart';
import 'package:ecocollect/data/models/collection.dart';
import 'package:ecocollect/data/models/recycling_point.dart';
import 'package:ecocollect/data/models/report.dart';
import 'package:ecocollect/data/models/tip.dart';
import 'package:ecocollect/data/models/user_account.dart';
import 'package:ecocollect/domain/services/auth_service.dart';
import 'package:ecocollect/presentation/providers/collection_provider.dart';
import 'package:ecocollect/presentation/providers/recycling_point_provider.dart';
import 'package:ecocollect/presentation/providers/report_provider.dart';
import 'package:ecocollect/presentation/providers/service_providers.dart';
import 'package:ecocollect/presentation/providers/tip_provider.dart';
import 'package:ecocollect/presentation/providers/user_provider.dart';
import 'package:ecocollect/presentation/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

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

final _fakeUser = UserAccount(
  uid: 'u1',
  email: 'marie@test.com',
  pseudo: 'Marie',
  createdAt: DateTime(2026),
);

Widget _wrap(Widget child) {
  return ProviderScope(
    overrides: [
      authServiceProvider.overrideWithValue(_FakeAuthService()),
      userProvider.overrideWith((ref) => Stream.value(_fakeUser)),
      collectionProvider.overrideWith((ref) => Stream.value(<Collection>[])),
      nextCollectionProvider.overrideWith((ref) => Stream.value(null)),
      recyclingPointProvider.overrideWith(
        (ref) => Stream.value(<RecyclingPoint>[]),
      ),
      tipProvider.overrideWith((ref) => Stream.value(<Tip>[])),
      reportProvider.overrideWith((ref) => Stream.value(<Report>[])),
    ],
    child: child,
  );
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('fr_FR');
  });

  testWidgets('L:application se lance sur le SplashScreen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_wrap(const EcoCollectApp()));

    expect(find.textContaining('EcoCollect'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  });

  testWidgets(
    'E03 Accueil affiche salutation, prochaine collecte et navigation',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrap(const MaterialApp(home: HomeScreen())),
      );
      await tester.pumpAndSettle();

      expect(find.text('Marie'), findsOneWidget);
      expect(find.text('marie@test.com'), findsOneWidget);
      expect(find.text('Raccourcis'), findsOneWidget);
      expect(find.text('PROCHAINE COLLECTE'), findsOneWidget);
      expect(find.text('Signaler'), findsOneWidget);
      expect(find.text('Collectes'), findsNWidgets(2));
      expect(find.text('Conseils'), findsNWidgets(2));
    },
  );
}