<<<<<<< HEAD
// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:toda_go/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
=======
import 'package:flutter_test/flutter_test.dart';
import 'package:toda_go_driver/main.dart';

void main() {
  testWidgets('TODA GO Splash Screen Smoke Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TodaGoApp());

    // Verify that the splash screen title 'Tayabas TODA Go' is present
    expect(find.text('Tayabas TODA Go'), findsOneWidget);
    
    // Verify that the sub-title 'Booking App' is present
    expect(find.text('Booking App'), findsOneWidget);

    // Let the splash screen timer complete to avoid pending timers
    await tester.pump(const Duration(seconds: 3));
>>>>>>> 9d63913 (Initial commit from Antigravity project)
  });
}
