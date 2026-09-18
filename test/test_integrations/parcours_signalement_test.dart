import 'package:ecocollect/data/models/collection.dart';
import 'package:ecocollect/data/models/recycling_point.dart';
import 'package:ecocollect/data/models/report.dart';
import 'package:ecocollect/data/models/tip.dart';
import 'package:ecocollect/presentation/providers/collection_provider.dart';
import 'package:ecocollect/presentation/providers/recycling_point_provider.dart';
import 'package:ecocollect/presentation/providers/tip_provider.dart';
import 'package:ecocollect/presentation/screens/authentification_screen.dart';
import 'package:ecocollect/presentation/widgets/report_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/fakes.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('fr_FR');
  });

  testWidgets(
    'Parcours complet (signaler un dépôt sauvage puis le supprimer)',
    (tester) async {
      final user = MockFirebaseUser();
      when(() => user.uid).thenReturn('u1');

      final env = FakeEnv(
        auth: FakeAuthService(loginUser: user),
        reportRepository: FakeReportRepository(),
        location: FakeLocationService(),
        geocoding: FakeGeocodingService(),
      );

      Widget wrap() => env.wrap(
            const MaterialApp(home: AuthentificationScreen()),
            extra: [
              collectionProvider.overrideWith(
                (ref) => Stream.value(<Collection>[]),
              ),
              nextCollectionProvider.overrideWith(
                (ref) => Stream.value(null),
              ),
              recyclingPointProvider.overrideWith(
                (ref) => Stream.value(<RecyclingPoint>[]),
              ),
              tipProvider.overrideWith((ref) => Stream.value(<Tip>[])),
            ],
          );

      await tester.pumpWidget(wrap());
      await tester.pumpAndSettle();

      // --- E02 · Inscription ---
      expect(find.text('Connexion'), findsOneWidget);
      expect(find.text('Inscription'), findsOneWidget);
      await tester.tap(find.text('Inscription'));
      await tester.pumpAndSettle();

      expect(find.text('Pseudo'), findsWidgets);
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Pseudo'),
        'Marie',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Adresse e-mail'),
        'marie@test.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Mot de passe'),
        'motdepasse',
      );
      await tester.tap(find.text('Créer mon compte'));
      await tester.pumpAndSettle();

      // --- E03 · Accueil ---
      expect(find.text('Votre impact commence ici.'), findsOneWidget);
      expect(find.text('Marie'), findsWidgets);
      expect(find.text('PROCHAINE COLLECTE'), findsOneWidget);
      expect(find.text('Aucune collecte prévue'), findsOneWidget);

      // --- FAB → E07 · Nouveau signalement ---
      await tester.tap(find.text('Signaler'));
      await tester.pumpAndSettle();

      expect(find.text('Nouveau signalement'), findsOneWidget);

      await tester.tap(find.byType(DropdownButtonFormField<ReportType>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Dépôt sauvage').last);
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Description'),
        'Dépôt de gravats sur la route de Delmas',
      );
      await tester.scrollUntilVisible(
        find.text('Envoyer le signalement'),
        200,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.tap(find.text('Envoyer le signalement'));
      await tester.pumpAndSettle();

      // --- Confirmation ---
      expect(find.text('Signalement envoyé !'), findsOneWidget);
      await tester.tap(find.text('Voir mes signalements'));
      await tester.pumpAndSettle();

      // --- E08 · Mes signalements : le signalement apparaît ---
      expect(find.text('Dépôt sauvage'), findsOneWidget);
      expect(
        find.text('Dépôt de gravats sur la route de Delmas'),
        findsOneWidget,
      );

      await tester.tap(find.byType(ReportCard));
      await tester.pumpAndSettle();

      // --- E09 · Détails ---
      expect(find.text('Détails du signalement'), findsOneWidget);
      expect(find.text('Statut actuel'), findsOneWidget);
      expect(find.text('En attente'), findsOneWidget);
      expect(
        find.text('Dépôt de gravats sur la route de Delmas'),
        findsOneWidget,
      );
      expect(find.text('Supprimer ce signalement'), findsOneWidget);

      // --- Suppression ---
      await tester.tap(find.text('Supprimer ce signalement'));
      await tester.pumpAndSettle();

      expect(find.text('Supprimer le signalement'), findsOneWidget);
      expect(find.text('Annuler'), findsOneWidget);
      await tester.tap(find.text('Supprimer'));
      await tester.pumpAndSettle();

      // Retour E08 ← le signalement a disparu
      expect(find.text('Aucun signalement trouvé'), findsOneWidget);

      // Laisse expirer la SnackBar « Signalement supprimé »
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
    },
  );
}