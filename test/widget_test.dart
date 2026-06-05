import 'package:flutter_test/flutter_test.dart';
import 'package:toda_go_driver/main.dart';

void main() {
  testWidgets('TODA GO Welcome Screen Smoke Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TodaGoApp());

    // Verify that the title "WELCOME!" is present
    expect(find.text('WELCOME!'), findsOneWidget);
    
    // Verify that the subtitle is present
    expect(find.text('Your safe tricycle ride in Tayabas'), findsOneWidget);

    // Verify that the passenger signup button is present
    expect(find.text('Sign Up as Passenger'), findsOneWidget);
  });
}
