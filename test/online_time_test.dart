import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:toda_go_driver/features/dashboard/providers/profile_provider.dart';
import 'package:toda_go_driver/features/dashboard/tabs/home_tab.dart';
import 'package:toda_go_driver/features/dashboard/screens/ratings_reviews_screen.dart';
import 'package:toda_go_driver/features/dashboard/screens/online_time_screen.dart';

Widget createTestableWidget(Widget child) {
  return ChangeNotifierProvider<ProfileProvider>(
    create: (_) => ProfileProvider()..fetchProfile(),
    child: MaterialApp(
      home: Scaffold(
        body: child,
      ),
    ),
  );
}

void main() {
  testWidgets('HomeTab ratings row tap navigates to RatingsReviewsScreen', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestableWidget(const HomeTab()));
    await tester.pumpAndSettle();

    // Verify rating row is present
    expect(find.text('(128 reviews)'), findsOneWidget);

    // Tap rating row
    await tester.tap(find.text('(128 reviews)'));
    await tester.pumpAndSettle();

    // Verify RatingsReviewsScreen is pushed
    expect(find.byType(RatingsReviewsScreen), findsOneWidget);
    expect(find.text('Ratings & Reviews'), findsOneWidget);
    expect(find.text('Passenger Feedback'), findsOneWidget);
    expect(find.text('Maria Santos'), findsOneWidget);
  });

  testWidgets('HomeTab Online Time card tap navigates to OnlineTimeScreen', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestableWidget(const HomeTab()));
    await tester.pumpAndSettle();

    // Find Online Time text or card and tap it
    expect(find.text('Online Time'), findsOneWidget);
    await tester.tap(find.text('Online Time'));
    await tester.pumpAndSettle();

    // Verify OnlineTimeScreen is pushed
    expect(find.byType(OnlineTimeScreen), findsOneWidget);
    expect(find.text('Online Time'), findsOneWidget);
    expect(find.text('TODAY'), findsOneWidget);
    expect(find.text('YESTERDAY'), findsOneWidget);
  });

  testWidgets('OnlineTimeScreen default state shows sessions and Apply Filter button', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestableWidget(const OnlineTimeScreen()));
    await tester.pumpAndSettle();

    // Verify default layout
    expect(find.text('Apply Filter'), findsOneWidget);
    expect(find.text('TODAY'), findsOneWidget);
    expect(find.text('YESTERDAY'), findsOneWidget);

    // Verify default session list groups
    expect(find.text('May 14, 2025'), findsOneWidget);
    expect(find.text('May 13, 2025'), findsOneWidget);
    expect(find.text('May 12, 2025'), findsOneWidget);

    // Verify sessions themselves
    expect(find.text('8:15 AM'), findsNWidgets(2));
    expect(find.text('3h 15m'), findsOneWidget);
    expect(find.text('7:45 AM'), findsOneWidget);

    // Scroll to find off-screen date group header
    final listFinder = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(
      find.text('May 11, 2025'),
      100.0,
      scrollable: listFinder,
    );
    await tester.pumpAndSettle();
    expect(find.text('May 11, 2025'), findsOneWidget);
  });

  testWidgets('OnlineTimeScreen filtering and resetting work correctly', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestableWidget(const OnlineTimeScreen()));
    await tester.pumpAndSettle();

    // Open filter bottom sheet
    await tester.tap(find.text('Apply Filter'));
    await tester.pumpAndSettle();

    // Select Yesterday preset
    await tester.tap(find.text('Yesterday'));
    await tester.pumpAndSettle();

    // Confirm filter
    final confirmButton = find.descendant(
      of: find.byType(ElevatedButton),
      matching: find.text('Confirm'),
    );
    await tester.tap(confirmButton);
    await tester.pumpAndSettle();

    // Verify filter is applied: Apply Filter shows "Yesterday" and Reset button is visible
    expect(find.text('Yesterday'), findsOneWidget);
    expect(find.text('Reset'), findsOneWidget);

    // Verify list is filtered: May 13 should be shown, May 14, 12, 11 should be hidden
    expect(find.text('May 13, 2025'), findsOneWidget);
    expect(find.text('May 14, 2025'), findsNothing);
    expect(find.text('May 12, 2025'), findsNothing);

    // Click Reset
    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();

    // Verify filter is cleared
    expect(find.text('Apply Filter'), findsOneWidget);
    expect(find.text('Reset'), findsNothing);

    // Verify list is restored
    expect(find.text('May 14, 2025'), findsOneWidget);
    expect(find.text('May 13, 2025'), findsOneWidget);
    expect(find.text('May 12, 2025'), findsOneWidget);
  });
}
