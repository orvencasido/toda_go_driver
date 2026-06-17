import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:toda_go_driver/features/dashboard/providers/profile_provider.dart';
import 'package:toda_go_driver/features/dashboard/tabs/trips_tab.dart';
import 'package:toda_go_driver/features/dashboard/screens/dashboard_screen.dart';

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
  testWidgets('TripsTab Default state displays Latest Trip, RECENT TRIPS, and Apply Filter button', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestableWidget(const TripsTab()));
    await tester.pumpAndSettle();

    // Verify TODAY header is visible
    expect(find.text('TODAY'), findsOneWidget);

    // Verify Latest Trip card content is visible
    expect(find.text('SM City Tayabas'), findsOneWidget);
    expect(find.text('Lucban Town Proper'), findsOneWidget);
    expect(find.text('₱150.00'), findsOneWidget);
    
    // Status text matches (1 in Tab, 1 in SM City Tayabas card, 1 in 123 Main St. card)
    expect(find.text('Cancelled'), findsNWidgets(3));

    // Confirm the Apply Filter button is visible
    expect(find.text('Apply Filter'), findsOneWidget);

    // Default state: YESTERDAY and OLDER TRIPS headers and older trips are visible
    expect(find.text('YESTERDAY'), findsOneWidget);
    expect(find.text('OLDER TRIPS'), findsOneWidget);
    expect(find.text('Lee Super Plaza'), findsOneWidget);
    expect(find.text('123 Main St., Barangay Poblacion'), findsOneWidget);
    expect(find.text('Quezon Ave., Tayabas City'), findsOneWidget);
    expect(find.text('Lucena Grand Terminal'), findsOneWidget);
    expect(find.text('Tayabas Community Hospital'), findsOneWidget);
    expect(find.text('Kamay ni Hesus'), findsOneWidget);
    expect(find.text('Sariaya Town Plaza'), findsOneWidget);

    // Verify times and dates for default (unfiltered) view:
    // Today (May 14) / Yesterday (May 13) trips should NOT show their dates, only times:
    expect(find.text('2:15 PM'), findsOneWidget);
    expect(find.text('May 14, 2025 • 2:15 PM'), findsNothing);
    expect(find.text('11:44 AM'), findsOneWidget);
    expect(find.text('May 14, 2025 • 11:44 AM'), findsNothing);
    expect(find.text('9:10 AM'), findsOneWidget);
    expect(find.text('May 13, 2025 • 9:10 AM'), findsNothing);

    // Older trips should show their full dates and times:
    expect(find.text('May 12, 2025 • 10:30 AM'), findsOneWidget);
    expect(find.text('May 8, 2025 • 3:20 PM'), findsOneWidget);
  });

  testWidgets('Tapping Apply Filter opens presets, selecting Custom opens calendar, applying range filters list, Reset restores default', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestableWidget(const TripsTab()));
    await tester.pumpAndSettle();

    // Tap Apply Filter button to open bottom sheet
    await tester.tap(find.text('Apply Filter'));
    await tester.pumpAndSettle();

    // Verify the bottom sheet has opened
    expect(find.text('Select Date Range'), findsOneWidget);

    // Tap Custom tile to open calendar view
    await tester.tap(find.text('Custom'));
    await tester.pumpAndSettle();

    // Tap day 14 to select May 14 - May 14
    await tester.tap(find.text('14').last);
    await tester.pumpAndSettle();

    final modalConfirmBtn = find.descendant(
      of: find.byType(ElevatedButton),
      matching: find.text('Confirm'),
    );
    await tester.tap(modalConfirmBtn);
    await tester.pumpAndSettle();

    // The bottom sheet should close
    expect(find.text('Select Date Range'), findsNothing);

    // The selected range display on the main card button (which resolves to preset 'Today')
    expect(find.text('Today'), findsOneWidget);

    // Headers should NOT be visible when filter is active
    expect(find.text('TODAY'), findsNothing);
    expect(find.text('YESTERDAY'), findsNothing);
    expect(find.text('OLDER TRIPS'), findsNothing);

    // Only May 14 trips should be shown:
    // Latest Trip: SM City Tayabas
    // Recent Trips: Lee Super Plaza
    expect(find.text('SM City Tayabas'), findsOneWidget);
    expect(find.text('Lee Super Plaza'), findsOneWidget);
    expect(find.text('123 Main St., Barangay Poblacion'), findsNothing);
    expect(find.text('Quezon Ave., Tayabas City'), findsNothing);
    expect(find.text('Lucena Grand Terminal'), findsNothing);

    // Filter is applied: Today trips MUST show their dates:
    expect(find.text('May 14, 2025 • 2:15 PM'), findsOneWidget);
    expect(find.text('2:15 PM'), findsNothing);
    expect(find.text('May 14, 2025 • 11:44 AM'), findsOneWidget);
    expect(find.text('11:44 AM'), findsNothing);

    // Tap the main screen Reset button
    await tester.tap(find.widgetWithText(OutlinedButton, 'Reset'));
    await tester.pumpAndSettle();

    // Modal should close and default view remains (all trips visible)
    expect(find.text('Select Date Range'), findsNothing);
    expect(find.text('TODAY'), findsOneWidget);
    expect(find.text('YESTERDAY'), findsOneWidget);
    expect(find.text('123 Main St., Barangay Poblacion'), findsOneWidget);
    expect(find.text('Quezon Ave., Tayabas City'), findsOneWidget);
    expect(find.text('Lucena Grand Terminal'), findsOneWidget);

    // Unfiltered again: Today/Yesterday trips should NOT show their dates, only times:
    expect(find.text('2:15 PM'), findsOneWidget);
    expect(find.text('May 14, 2025 • 2:15 PM'), findsNothing);
    expect(find.text('11:44 AM'), findsOneWidget);
    expect(find.text('May 14, 2025 • 11:44 AM'), findsNothing);
  });

  // Bottom-sheet Reset button has been removed in favor of the main screen inline Reset button.

  testWidgets('Selecting Today and Yesterday presets filters list correctly', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestableWidget(const TripsTab()));
    await tester.pumpAndSettle();

    // ─── Test Yesterday Preset ───
    await tester.tap(find.text('Apply Filter'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Yesterday'));
    await tester.pumpAndSettle();

    final modalConfirmBtn = find.descendant(
      of: find.byType(ElevatedButton),
      matching: find.text('Confirm'),
    );
    await tester.tap(modalConfirmBtn);
    await tester.pumpAndSettle();

    expect(find.text('Yesterday'), findsOneWidget);

    // Headers should NOT be visible when filter is active
    expect(find.text('TODAY'), findsNothing);
    expect(find.text('YESTERDAY'), findsNothing);
    expect(find.text('OLDER TRIPS'), findsNothing);

    // Only May 13 trips should be shown:
    expect(find.text('123 Main St., Barangay Poblacion'), findsOneWidget);
    expect(find.text('Quezon Ave., Tayabas City'), findsOneWidget);
    expect(find.text('SM City Tayabas'), findsNothing);
    expect(find.text('Lee Super Plaza'), findsNothing);
    expect(find.text('Lucena Grand Terminal'), findsNothing);
  });

  testWidgets('Selecting This Week and This Month presets filters list correctly', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestableWidget(const TripsTab()));
    await tester.pumpAndSettle();

    // ─── Test This Week Preset ───
    await tester.tap(find.text('Apply Filter'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('This Week'));
    await tester.pumpAndSettle();

    final modalConfirmBtn = find.descendant(
      of: find.byType(ElevatedButton),
      matching: find.text('Confirm'),
    );
    await tester.tap(modalConfirmBtn);
    await tester.pumpAndSettle();

    expect(find.text('This Week'), findsOneWidget);

    // Headers should NOT be visible when filter is active
    expect(find.text('TODAY'), findsNothing);
    expect(find.text('YESTERDAY'), findsNothing);
    expect(find.text('OLDER TRIPS'), findsNothing);

    // May 12 - 18 trips should show:
    expect(find.text('SM City Tayabas'), findsOneWidget);
    expect(find.text('Lee Super Plaza'), findsOneWidget);
    expect(find.text('123 Main St., Barangay Poblacion'), findsOneWidget);
    expect(find.text('Quezon Ave., Tayabas City'), findsOneWidget);
    expect(find.text('Lucena Grand Terminal'), findsOneWidget); // May 12 Monday is in this week!
    
    // Older than May 12 should NOT show:
    expect(find.text('Tayabas Community Hospital'), findsNothing); // May 8 is last week
    expect(find.text('Kamay ni Hesus'), findsNothing); // May 4
    expect(find.text('Sariaya Town Plaza'), findsNothing); // April 30

    // ─── Test This Month Preset ───
    await tester.tap(find.text('This Week')); // Tap active Week filter button card to open sheet
    await tester.pumpAndSettle();

    await tester.tap(find.text('This Month'));
    await tester.pumpAndSettle();

    await tester.tap(modalConfirmBtn);
    await tester.pumpAndSettle();

    expect(find.text('This Month'), findsOneWidget);

    // Headers should NOT be visible when filter is active
    expect(find.text('TODAY'), findsNothing);
    expect(find.text('YESTERDAY'), findsNothing);
    expect(find.text('OLDER TRIPS'), findsNothing);

    // May 1 - 31 trips should show:
    expect(find.text('SM City Tayabas'), findsOneWidget);
    expect(find.text('Lucena Grand Terminal'), findsOneWidget);
    expect(find.text('Tayabas Community Hospital'), findsOneWidget); // May 8 is in May!
    expect(find.text('Kamay ni Hesus'), findsOneWidget); // May 4 is in May!

    // April 30 trip should NOT show:
    expect(find.text('Sariaya Town Plaza'), findsNothing); // April 30 is in April!
  });

  testWidgets('Reset button on the main screen and navigation auto-reset work correctly', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(500, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestableWidget(const DashboardScreen()));
    await tester.pumpAndSettle();

    // Navigate to TripsTab (index 1)
    await tester.tap(find.byIcon(Icons.list_alt_outlined));
    await tester.pumpAndSettle();

    // Verify TODAY header is visible initially
    expect(find.text('TODAY'), findsOneWidget);

    // Apply Filter "Yesterday"
    await tester.tap(find.text('Apply Filter'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Yesterday'));
    await tester.pumpAndSettle();

    final modalConfirmBtn = find.descendant(
      of: find.byType(ElevatedButton),
      matching: find.text('Confirm'),
    );
    await tester.tap(modalConfirmBtn);
    await tester.pumpAndSettle();

    // Check that Yesterday filter is applied, and Reset button is visible on main screen
    expect(find.text('Yesterday'), findsOneWidget);
    expect(find.text('Reset'), findsOneWidget);
    expect(find.text('TODAY'), findsNothing);

    // Tap the main screen Reset button
    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();

    // Should be restored to default state
    expect(find.text('TODAY'), findsOneWidget);
    expect(find.text('Yesterday'), findsNothing);
    expect(find.text('Apply Filter'), findsOneWidget);

    // Apply filter again to test navigation auto-reset
    await tester.tap(find.text('Apply Filter'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Yesterday'));
    await tester.pumpAndSettle();

    await tester.tap(modalConfirmBtn);
    await tester.pumpAndSettle();

    expect(find.text('Yesterday'), findsOneWidget);
    expect(find.text('TODAY'), findsNothing);

    // Navigate to Home tab (index 0)
    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pumpAndSettle();

    // Navigate back to Trips tab (index 1)
    await tester.tap(find.byIcon(Icons.list_alt_outlined));
    await tester.pumpAndSettle();

    // Should have automatically reset the filter!
    expect(find.text('TODAY'), findsOneWidget);
    expect(find.text('Yesterday'), findsNothing);
    expect(find.text('Apply Filter'), findsOneWidget);
  });
}
