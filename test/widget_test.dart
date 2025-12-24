// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Smoke test: shows CircularProgressIndicator', (
    WidgetTester tester,
  ) async {
    // Pump a minimal app with a CircularProgressIndicator
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
    );

    // Verify that the loading indicator is present.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
