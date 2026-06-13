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
  });
}
