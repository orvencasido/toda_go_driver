import 'package:flutter/material.dart';
import 'package:toda_go_driver/core/constants/app_colors.dart';

// ── Sample Data ───────────────────────────────────────────────────────────────
class _TripRecord {
  final String dayAbbr;
  final String date;
  final String time;
  final String route;
  final int fixedFare;
  final int tip;

  const _TripRecord({
    required this.dayAbbr,
    required this.date,
    required this.time,
    required this.route,
    required this.fixedFare,
    required this.tip,
  });

  int get total => fixedFare + tip;
}

const _allTrips = [
  _TripRecord(dayAbbr: 'Mon', date: 'Apr 1', time: '10:25 AM', route: 'TODA Terminal to Market', fixedFare: 120, tip: 20),
  _TripRecord(dayAbbr: 'Mon', date: 'Apr 1', time: '1:15 PM', route: 'Market to Barangay Hall', fixedFare: 130, tip: 10),
  _TripRecord(dayAbbr: 'Tue', date: 'Apr 2', time: '8:45 AM', route: 'Barangay Hall to School', fixedFare: 150, tip: 0),
  _TripRecord(dayAbbr: 'Tue', date: 'Apr 2', time: '11:10 AM', route: 'School to City Plaza', fixedFare: 120, tip: 15),
  _TripRecord(dayAbbr: 'Tue', date: 'Apr 2', time: '3:30 PM', route: 'City Plaza to TODA Terminal', fixedFare: 130, tip: 20),
  _TripRecord(dayAbbr: 'Wed', date: 'Apr 3', time: '7:50 AM', route: 'TODA Terminal to Mall', fixedFare: 120, tip: 10),
  _TripRecord(dayAbbr: 'Wed', date: 'Apr 3', time: '12:40 PM', route: 'Mall to Public Market', fixedFare: 140, tip: 20),
  _TripRecord(dayAbbr: 'Wed', date: 'Apr 3', time: '5:25 PM', route: 'Public Market to Home', fixedFare: 130, tip: 15),
  _TripRecord(dayAbbr: 'Thu', date: 'Apr 4', time: '8:10 AM', route: 'Home to City Hall', fixedFare: 150, tip: 20),
  _TripRecord(dayAbbr: 'Thu', date: 'Apr 4', time: '11:30 AM', route: 'City Hall to University', fixedFare: 150, tip: 10),
  _TripRecord(dayAbbr: 'Thu', date: 'Apr 4', time: '4:15 PM', route: 'University to TODA Terminal', fixedFare: 120, tip: 0),
  _TripRecord(dayAbbr: 'Fri', date: 'Apr 5', time: '9:00 AM', route: 'TODA Terminal to Hospital', fixedFare: 150, tip: 15),
  _TripRecord(dayAbbr: 'Fri', date: 'Apr 5', time: '2:45 PM', route: 'Hospital to Barangay Hall', fixedFare: 130, tip: 10),
  _TripRecord(dayAbbr: 'Fri', date: 'Apr 5', time: '6:00 PM', route: 'Barangay Hall to Home', fixedFare: 120, tip: 10),
  _TripRecord(dayAbbr: 'Sat', date: 'Apr 6', time: '8:30 AM', route: 'Home to Terminal', fixedFare: 120, tip: 20),
  _TripRecord(dayAbbr: 'Sat', date: 'Apr 6', time: '12:20 PM', route: 'Terminal to City Market', fixedFare: 130, tip: 20),
  _TripRecord(dayAbbr: 'Sat', date: 'Apr 6', time: '4:50 PM', route: 'City Market to Home', fixedFare: 150, tip: 20),
  _TripRecord(dayAbbr: 'Sun', date: 'Apr 7', time: '7:30 AM', route: 'Home to Church', fixedFare: 120, tip: 0),
];

// ── Filter Enum ───────────────────────────────────────────────────────────────
enum _EarningsFilter { today, thisWeek, thisMonth, custom }

// ── Screen ────────────────────────────────────────────────────────────────────
class EarningsReportScreen extends StatefulWidget {
  const EarningsReportScreen({super.key});

  @override
  State<EarningsReportScreen> createState() => _EarningsReportScreenState();
}

class _EarningsReportScreenState extends State<EarningsReportScreen> {
  _EarningsFilter _selectedFilter = _EarningsFilter.thisWeek;
  DateTimeRange? _customRange;

  String get _dateRangeLabel {
    switch (_selectedFilter) {
      case _EarningsFilter.today:
        return 'Today, April 7';
      case _EarningsFilter.thisWeek:
        return 'April 1 – April 7';
      case _EarningsFilter.thisMonth:
        return 'April 1 – April 30';
      case _EarningsFilter.custom:
        if (_customRange != null) {
          final s = _customRange!.start;
          final e = _customRange!.end;
          return '${_monthName(s.month)} ${s.day} – ${_monthName(e.month)} ${e.day}';
        }
        return 'Select Date Range';
    }
  }

  List<_TripRecord> get _filteredTrips {
    switch (_selectedFilter) {
      case _EarningsFilter.today:
        return [_allTrips.last];
      case _EarningsFilter.thisWeek:
        return _allTrips;
      case _EarningsFilter.thisMonth:
        return _allTrips;
      case _EarningsFilter.custom:
        return _allTrips;
    }
  }

  String _monthName(int m) => const [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ][m];

  Future<void> _pickCustomRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2027),
      initialDateRange: _customRange ??
          DateTimeRange(
            start: DateTime(2025, 4, 1),
            end: DateTime(2025, 4, 7),
          ),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primaryNavy,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _customRange = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final trips = _filteredTrips;
    final totalEarnings = trips.fold(0, (s, t) => s + t.total);
    final totalTrips = trips.length;
    final fixedFareTotal = trips.fold(0, (s, t) => s + t.fixedFare);
    final tipsTotal = trips.fold(0, (s, t) => s + t.tip);

    return Scaffold(
      backgroundColor: AppColors.lightBlueBackground,
      body: Column(
        children: [
          // ── Header ────────────────────────────────────────────────────────
          Container(
            width: double.infinity,
            color: AppColors.primaryNavy,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              bottom: 16,
              left: 8,
              right: 16,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Text(
                    'Earnings Report',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),

          // ── Content ───────────────────────────────────────────────────────
          Expanded(
            child: Column(
              children: [
                // Filter chips
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    children: _EarningsFilter.values.map((f) {
                      final labels = ['Today', 'This Week', 'This Month', 'Custom Range'];
                      final isSelected = _selectedFilter == f;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            setState(() => _selectedFilter = f);
                            if (f == _EarningsFilter.custom) {
                              await _pickCustomRange();
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryNavy
                                  : AppColors.lightBlueBackground,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              labels[f.index],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.primaryNavy,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Date range label
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: GestureDetector(
                    onTap: _selectedFilter == _EarningsFilter.custom
                        ? _pickCustomRange
                        : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColors.primaryNavy.withValues(alpha: 0.2)),
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.lightBlueBackground,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.calendar_today_outlined,
                              size: 16, color: AppColors.primaryNavy),
                          const SizedBox(width: 8),
                          Text(
                            _dateRangeLabel,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryNavy,
                            ),
                          ),
                          if (_selectedFilter == _EarningsFilter.custom) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.expand_more,
                                size: 18, color: AppColors.primaryNavy),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                // Summary cards
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Row(
                    children: [
                      _SummaryCard(
                          label: 'Total Earnings',
                          value: '₱$totalEarnings',
                          color: AppColors.primaryNavy),
                      const SizedBox(width: 8),
                      _SummaryCard(
                          label: 'Total Trips',
                          value: '$totalTrips',
                          color: const Color(0xFF607D8B)),
                      const SizedBox(width: 8),
                      _SummaryCard(
                          label: 'Fixed Fare',
                          value: '₱$fixedFareTotal',
                          color: const Color(0xFF4CAF50)),
                      const SizedBox(width: 8),
                      _SummaryCard(
                          label: 'Tips',
                          value: '₱$tipsTotal',
                          color: const Color(0xFF9C27B0)),
                    ],
                  ),
                ),

                // Trip list header
                Padding(
                  padding:
                      const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    children: const [
                      Expanded(
                          flex: 3,
                          child: Text('Date & Time / Route',
                              style: _headerStyle)),
                      Expanded(
                          child: Text('Fare',
                              textAlign: TextAlign.right,
                              style: _headerStyle)),
                      Expanded(
                          child: Text('Tip',
                              textAlign: TextAlign.right,
                              style: _headerStyle)),
                      Expanded(
                          child: Text('Total',
                              textAlign: TextAlign.right,
                              style: _headerStyle)),
                    ],
                  ),
                ),

                // Trips list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: trips.length,
                    itemBuilder: (ctx, i) => _TripRow(trip: trips[i]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const _headerStyle = TextStyle(
  fontFamily: 'Poppins',
  fontSize: 11,
  fontWeight: FontWeight.w700,
  color: AppColors.textLight,
  letterSpacing: 0.3,
);

// ── Summary Card ──────────────────────────────────────────────────────────────
class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryCard(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Trip Row ──────────────────────────────────────────────────────────────────
class _TripRow extends StatelessWidget {
  final _TripRecord trip;

  const _TripRow({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Date/time + route
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${trip.dayAbbr}, ${trip.date}  •  ${trip.time}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  trip.route,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
          // Fixed Fare
          Expanded(
            child: Text(
              '₱${trip.fixedFare}',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
            ),
          ),
          // Tip
          Expanded(
            child: Text(
              trip.tip == 0 ? '–' : '₱${trip.tip}',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: trip.tip == 0
                    ? AppColors.textLight
                    : const Color(0xFF9C27B0),
              ),
            ),
          ),
          // Total
          Expanded(
            child: Text(
              '₱${trip.total}',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryNavy,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
