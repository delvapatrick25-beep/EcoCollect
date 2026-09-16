import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ecocollect/app.dart';

void main() {
  testWidgets('L:application se lance sur le SplashScreen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EcoCollectApp());

    expect(find.byType(Icon), findsWidgets);
    expect(find.textContaining('EcoCollect'), findsOneWidget);
    expect(find.textContaining('éco-responsable'), findsOneWidget);
  });
}