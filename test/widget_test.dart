// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aquahaven/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AquaHavenApp());

    // Verify that the app title is displayed
    expect(find.text('AquaHaven'), findsOneWidget);
    
    // Verify that the home screen is displayed
    expect(find.text('Welcome to AquaHaven'), findsOneWidget);
  });

  testWidgets('Navigate to fish list', (WidgetTester tester) async {
    await tester.pumpWidget(const AquaHavenApp());
    
    // Tap the 'View Aquarium Fish' button
    await tester.tap(find.text('View Aquarium Fish'));
    await tester.pumpAndSettle();
    
    // Verify that we're on the fish list screen
    expect(find.text('Aquarium Fish'), findsOneWidget);
    
    // Verify that fish are loaded
    expect(find.byType(Card), findsWidgets);
  });
}
