// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fintechnic/main.dart';

void main() {
  testWidgets('App loads without crashing', (WidgetTester tester) async {
    // Create a basic app with only the ErrorApp widget
    await tester.pumpWidget(
      const MaterialApp(
        home: ErrorApp(error: 'Test error'),
      ),
    );

    // Verify the ErrorApp shows the expected error message
    expect(find.text('Test error'), findsOneWidget);
    expect(find.text('Error Initializing App'), findsOneWidget);
  });
} 