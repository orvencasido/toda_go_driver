import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toda_go_driver/core/constants/app_colors.dart';

// ── Sample Data ───────────────────────────────────────────────────────────────
class _TripRecord {
  final String dayAbbr;
  final String date;
  final String time;
  final String route;
  final int fixedFare;
  final int tip;
  final DateTime dateTime;

  const _TripRecord({
    required this.dayAbbr,
    required this.date,
    required this.time,
    required this.route,
    required this.fixedFare,
    required this.tip,
    required this.dateTime,
  });

  int get total => fixedFare + tip;
}

final _allTrips = [
  _TripRecord(dayAbbr: 'Mon', date: 'Apr 1', time: '10:25 AM', route: 'TODA Terminal to Market', fixedFare: 120, tip: 20, dateTime: DateTime(2025, 5, 8, 10, 25)),
  _TripRecord(dayAbbr: 'Mon', date: 'Apr 1', time: '1:15 PM', route: 'Market to Barangay Hall', fixedFare: 130, tip: 10, dateTime: DateTime(2025, 5, 8, 13, 15)),
  _TripRecord(dayAbbr: 'Tue', date: 'Apr 2', time: '8:45 AM', route: 'Barangay Hall to School', fixedFare: 150, tip: 0, dateTime: DateTime(2025, 5, 9, 8, 45)),
  _TripRecord(dayAbbr: 'Tue', date: 'Apr 2', time: '11:10 AM', route: 'School to City Plaza', fixedFare: 120, tip: 15, dateTime: DateTime(2025, 5, 9, 11, 10)),
  _TripRecord(dayAbbr: 'Tue', date: 'Apr 2', time: '3:30 PM', route: 'City Plaza to TODA Terminal', fixedFare: 130, tip: 20, dateTime: DateTime(2025, 5, 9, 15, 30)),
  _TripRecord(dayAbbr: 'Wed', date: 'Apr 3', time: '7:50 AM', route: 'TODA Terminal to Mall', fixedFare: 120, tip: 10, dateTime: DateTime(2025, 5, 10, 7, 50)),
  _TripRecord(dayAbbr: 'Wed', date: 'Apr 3', time: '12:40 PM', route: 'Mall to Public Market', fixedFare: 140, tip: 20, dateTime: DateTime(2025, 5, 10, 12, 40)),
  _TripRecord(dayAbbr: 'Wed', date: 'Apr 3', time: '5:25 PM', route: 'Public Market to Home', fixedFare: 130, tip: 15, dateTime: DateTime(2025, 5, 10, 17, 25)),
  _TripRecord(dayAbbr: 'Thu', date: 'Apr 4', time: '8:10 AM', route: 'Home to City Hall', fixedFare: 150, tip: 20, dateTime: DateTime(2025, 5, 11, 8, 10)),
  _TripRecord(dayAbbr: 'Thu', date: 'Apr 4', time: '11:30 AM', route: 'City Hall to University', fixedFare: 150, tip: 10, dateTime: DateTime(2025, 5, 11, 11, 30)),
  _TripRecord(dayAbbr: 'Thu', date: 'Apr 4', time: '4:15 PM', route: 'University to TODA Terminal', fixedFare: 120, tip: 0, dateTime: DateTime(2025, 5, 11, 16, 15)),
  _TripRecord(dayAbbr: 'Fri', date: 'Apr 5', time: '9:00 AM', route: 'TODA Terminal to Hospital', fixedFare: 150, tip: 15, dateTime: DateTime(2025, 5, 12, 9, 0)),
  _TripRecord(dayAbbr: 'Fri', date: 'Apr 5', time: '2:45 PM', route: 'Hospital to Barangay Hall', fixedFare: 130, tip: 10, dateTime: DateTime(2025, 5, 12, 14, 45)),
  _TripRecord(dayAbbr: 'Fri', date: 'Apr 5', time: '6:00 PM', route: 'Barangay Hall to Home', fixedFare: 120, tip: 10, dateTime: DateTime(2025, 5, 12, 18, 0)),
  _TripRecord(dayAbbr: 'Sat', date: 'Apr 6', time: '8:30 AM', route: 'Home to Terminal', fixedFare: 120, tip: 20, dateTime: DateTime(2025, 5, 13, 8, 30)),
  _TripRecord(dayAbbr: 'Sat', date: 'Apr 6', time: '12:20 PM', route: 'Terminal to City Market', fixedFare: 130, tip: 20, dateTime: DateTime(2025, 5, 13, 12, 20)),
  _TripRecord(dayAbbr: 'Sat', date: 'Apr 6', time: '4:50 PM', route: 'City Market to Home', fixedFare: 150, tip: 20, dateTime: DateTime(2025, 5, 13, 16, 50)),
  _TripRecord(dayAbbr: 'Sun', date: 'Apr 7', time: '7:30 AM', route: 'Home to Church', fixedFare: 120, tip: 0, dateTime: DateTime(2025, 5, 14, 7, 30)),
];

// ── Screen ────────────────────────────────────────────────────────────────────
class EarningsReportScreen extends StatefulWidget {
  const EarningsReportScreen({super.key});

  @override
  State<EarningsReportScreen> createState() => _EarningsReportScreenState();
}

class _EarningsReportScreenState extends State<EarningsReportScreen> {
  DateTime? _startDate;
  DateTime? _endDate;

  bool get _hasFilter => _startDate != null && _endDate != null;

  List<_TripRecord> get _filteredTrips {
    if (_startDate == null || _endDate == null) {
      return _allTrips;
    }
    return _allTrips.where((trip) {
      final tripDate = DateTime(trip.dateTime.year, trip.dateTime.month, trip.dateTime.day);
      final start = DateTime(_startDate!.year, _startDate!.month, _startDate!.day);
      final end = DateTime(_endDate!.year, _endDate!.month, _endDate!.day);
      return (tripDate.isAfter(start) || tripDate.isAtSameMomentAs(start)) &&
             (tripDate.isBefore(end) || tripDate.isAtSameMomentAs(end));
    }).toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  String _formatDateRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) {
      return 'Custom Range';
    }

    final today = DateTime(2025, 5, 14);
    final yesterday = DateTime(2025, 5, 13);
    final weekStart = DateTime(2025, 5, 12);
    final weekEnd = DateTime(2025, 5, 18);
    final monthStart = DateTime(2025, 5, 1);
    final monthEnd = DateTime(2025, 5, 31);

    if (start == today && end == today) {
      return 'Today';
    } else if (start == yesterday && end == yesterday) {
      return 'Yesterday';
    } else if (start == weekStart && end == weekEnd) {
      return 'This Week';
    } else if (start == monthStart && end == monthEnd) {
      return 'This Month';
    }

    if (start.year == end.year) {
      if (start.month == end.month) {
        final monthStr = DateFormat('MMMM').format(start);
        if (start.day == end.day) {
          return '$monthStr ${start.day}, ${start.year}';
        }
        return '$monthStr ${start.day} – ${end.day}, ${start.year}';
      } else {
        final startMonth = DateFormat('MMMM').format(start);
        final endMonth = DateFormat('MMMM').format(end);
        return '$startMonth ${start.day} – $endMonth ${end.day}, ${start.year}';
      }
    } else {
      return '${DateFormat('MMMM d, yyyy').format(start)} – ${DateFormat('MMMM d, yyyy').format(end)}';
    }
  }

  void _openCalendarFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _EarningsCalendarFilterBottomSheet(
          initialStartDate: _startDate,
          initialEndDate: _endDate,
          onApply: (start, end) {
            setState(() {
              _startDate = start;
              _endDate = end;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final trips = _filteredTrips;
    final totalEarnings = trips.fold(0, (s, t) => s + t.total);
    final totalTrips = trips.length;
    final tipsTotal = trips.fold(0, (s, t) => s + t.tip);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5FA),
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
                    'Earnings',
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
                // ─── Apply Filter Card Button & Reset ───
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _openCalendarFilterBottomSheet,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade200, width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.filter_alt_outlined, color: AppColors.primaryNavy, size: 18),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    _startDate != null && _endDate != null
                                        ? _formatDateRange(_startDate, _endDate)
                                        : 'Apply Filter',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryNavy,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: Colors.grey.shade400,
                                  size: 22,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (_hasFilter) ...[
                        const SizedBox(width: 12),
                        SizedBox(
                          height: 52, // matches the height of the container
                          child: OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                _startDate = null;
                                _endDate = null;
                              });
                            },
                            icon: const Icon(Icons.refresh_rounded, size: 18),
                            label: const Text(
                              'Reset',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primaryNavy,
                              side: const BorderSide(color: AppColors.primaryNavy, width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Summary cards
                Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Row(
                    children: [
                      _SummaryCard(
                          label: 'Total Earnings',
                          value: '₱$totalEarnings',
                          color: AppColors.primaryNavy),
                      const SizedBox(width: 12),
                      _SummaryCard(
                          label: 'Total Trips',
                          value: '$totalTrips',
                          color: AppColors.primaryNavy),
                      const SizedBox(width: 12),
                      _SummaryCard(
                          label: 'Tips',
                          value: '₱$tipsTotal',
                          color: AppColors.primaryNavy),
                    ],
                  ),
                ),

                // Trip list header
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 12, 30, 8),
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
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
                    : AppColors.primaryNavy,
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

// ── Calendar Filter Bottom Sheet (reusable for Earnings) ──────────────────
class _EarningsCalendarFilterBottomSheet extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final Function(DateTime?, DateTime?) onApply;

  const _EarningsCalendarFilterBottomSheet({
    required this.initialStartDate,
    required this.initialEndDate,
    required this.onApply,
  });

  @override
  State<_EarningsCalendarFilterBottomSheet> createState() => _EarningsCalendarFilterBottomSheetState();
}

class _EarningsCalendarFilterBottomSheetState extends State<_EarningsCalendarFilterBottomSheet> {
  DateTime? _tempStartDate;
  DateTime? _tempEndDate;
  late DateTime _currentMonth;

  final DateTime _todayRef = DateTime(2025, 5, 14);

  DateTime get _today => _todayRef;
  DateTime get _yesterday => _todayRef.subtract(const Duration(days: 1));
  DateTime get _weekStart => DateTime(2025, 5, 12);
  DateTime get _weekEnd => DateTime(2025, 5, 18);
  DateTime get _monthStart => DateTime(2025, 5, 1);
  DateTime get _monthEnd => DateTime(2025, 5, 31);

  bool _isCustom = false;
  String? _selectedPreset;

  @override
  void initState() {
    super.initState();
    _tempStartDate = widget.initialStartDate;
    _tempEndDate = widget.initialEndDate;

    final start = _tempStartDate;
    final end = _tempEndDate;
    if (start != null && end != null) {
      if (start == _today && end == _today) {
        _selectedPreset = 'today';
        _isCustom = false;
      } else if (start == _yesterday && end == _yesterday) {
        _selectedPreset = 'yesterday';
        _isCustom = false;
      } else if (start == _weekStart && end == _weekEnd) {
        _selectedPreset = 'week';
        _isCustom = false;
      } else if (start == _monthStart && end == _monthEnd) {
        _selectedPreset = 'month';
        _isCustom = false;
      } else {
        _selectedPreset = null;
        _isCustom = true;
      }
    } else {
      _selectedPreset = null;
      _isCustom = false;
    }

    final monthAnchor = _tempStartDate ?? _today;
    _currentMonth = DateTime(monthAnchor.year, monthAnchor.month, 1);
  }

  void _onDayTapped(DateTime date) {
    setState(() {
      _selectedPreset = null;
      if (_tempStartDate == null || _tempEndDate == null) {
        _tempStartDate = date;
        _tempEndDate = date;
      } else if (_tempStartDate == _tempEndDate) {
        if (date.isBefore(_tempStartDate!)) {
          _tempStartDate = date;
        } else {
          _tempEndDate = date;
        }
      } else {
        _tempStartDate = date;
        _tempEndDate = date;
      }
    });
  }

  bool _isDayInRange(DateTime date) {
    if (_tempStartDate == null || _tempEndDate == null) return false;
    final day = DateTime(date.year, date.month, date.day);
    final start = DateTime(_tempStartDate!.year, _tempStartDate!.month, _tempStartDate!.day);
    final end = DateTime(_tempEndDate!.year, _tempEndDate!.month, _tempEndDate!.day);
    return day.isAfter(start) && day.isBefore(end);
  }

  Widget _buildPresetTile({
    required String title,
    required String subtitle,
    required String presetKey,
    required DateTime startDate,
    required DateTime endDate,
    bool isFirst = false,
    bool isLast = false,
  }) {
    final isSelected = _selectedPreset == presetKey;
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedPreset == presetKey) {
            _selectedPreset = null;
            _tempStartDate = null;
            _tempEndDate = null;
          } else {
            _selectedPreset = presetKey;
            _tempStartDate = startDate;
            _tempEndDate = endDate;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : Colors.transparent,
          borderRadius: BorderRadius.only(
            topLeft: isFirst ? const Radius.circular(15) : Radius.zero,
            topRight: isFirst ? const Radius.circular(15) : Radius.zero,
            bottomLeft: isLast ? const Radius.circular(15) : Radius.zero,
            bottomRight: isLast ? const Radius.circular(15) : Radius.zero,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              color: isSelected ? AppColors.primaryNavy : Colors.grey.shade400,
              size: 20,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryNavy,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 40,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8, bottom: 8),
                  child: Row(
                    children: [
                      const SizedBox(width: 48), // Spacer to balance close button size
                      const Expanded(
                        child: Text(
                          'Select Date Range',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryNavy,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: AppColors.primaryNavy, size: 24),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),

                  if (!_isCustom) ...[
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                      ),
                      child: Column(
                        children: [
                          _buildPresetTile(
                            title: 'Today',
                            subtitle: 'May 14, 2025',
                            presetKey: 'today',
                            startDate: _today,
                            endDate: _today,
                            isFirst: true,
                          ),
                          const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
                          _buildPresetTile(
                            title: 'Yesterday',
                            subtitle: 'May 13, 2025',
                            presetKey: 'yesterday',
                            startDate: _yesterday,
                            endDate: _yesterday,
                          ),
                          const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
                          _buildPresetTile(
                            title: 'This Week',
                            subtitle: 'May 12 – May 18, 2025',
                            presetKey: 'week',
                            startDate: _weekStart,
                            endDate: _weekEnd,
                          ),
                          const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
                          _buildPresetTile(
                            title: 'This Month',
                            subtitle: 'May 1 – May 31, 2025',
                            presetKey: 'month',
                            startDate: _monthStart,
                            endDate: _monthEnd,
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isCustom = true;
                            _selectedPreset = null;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.date_range_rounded, color: Colors.grey.shade400, size: 22),
                              const SizedBox(width: 14),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Custom',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryNavy,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Select a specific date range',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400, size: 22),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isCustom = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.date_range_rounded, color: AppColors.primaryNavy, size: 22),
                              const SizedBox(width: 14),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Custom',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryNavy,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Select a specific date range',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey.shade400, size: 22),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'From',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _tempStartDate != null ? DateFormat('MMMM d, yyyy').format(_tempStartDate!) : 'Start Date',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: _tempStartDate != null ? AppColors.primaryNavy : Colors.grey.shade400,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(Icons.calendar_today_outlined, color: Colors.grey.shade400, size: 16),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'To',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _tempEndDate != null ? DateFormat('MMMM d, yyyy').format(_tempEndDate!) : 'End Date',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: _tempEndDate != null ? AppColors.primaryNavy : Colors.grey.shade400,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(Icons.calendar_today_outlined, color: Colors.grey.shade400, size: 16),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left_rounded, color: Colors.grey, size: 24),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              setState(() {
                                _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
                              });
                            },
                          ),
                          Text(
                            DateFormat('MMMM yyyy').format(_currentMonth),
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryNavy,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 24),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              setState(() {
                                _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                            .map((day) => Expanded(
                                  child: Center(
                                    child: Text(
                                      day,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        color: Colors.grey.shade400,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildCalendarGrid(),
                    ),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, bottomPadding + 20),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  widget.onApply(_tempStartDate, _tempEndDate);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryNavy,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final prependDays = firstDay.weekday % 7;
    final lastDay = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final totalDaysToShow = ((prependDays + lastDay.day) / 7).ceil() * 7;
    
    final List<DateTime> days = [];
    final startDate = firstDay.subtract(Duration(days: prependDays));
    for (int i = 0; i < totalDaysToShow; i++) {
      days.add(startDate.add(Duration(days: i)));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: days.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 0,
        childAspectRatio: 1.15,
      ),
      itemBuilder: (context, index) {
        final date = days[index];
        final bool isCurrentMonth = date.month == _currentMonth.month && date.year == _currentMonth.year;
        
        final bool isStart = _tempStartDate != null &&
            date.year == _tempStartDate!.year &&
            date.month == _tempStartDate!.month &&
            date.day == _tempStartDate!.day;
        final bool isEnd = _tempEndDate != null &&
            date.year == _tempEndDate!.year &&
            date.month == _tempEndDate!.month &&
            date.day == _tempEndDate!.day;
        final bool isSelected = isStart || isEnd;
        final bool isInRange = _isDayInRange(date);

        Widget? backgroundHighlight;
        if (isCurrentMonth) {
          if (isInRange) {
            backgroundHighlight = Container(color: const Color(0xFFEFF6FF));
          } else if (isStart && _tempStartDate != _tempEndDate) {
            backgroundHighlight = Row(
              children: [
                const Expanded(child: SizedBox.shrink()),
                Expanded(child: Container(color: const Color(0xFFEFF6FF))),
              ],
            );
          } else if (isEnd && _tempStartDate != _tempEndDate) {
            backgroundHighlight = Row(
              children: [
                Expanded(child: Container(color: const Color(0xFFEFF6FF))),
                const Expanded(child: SizedBox.shrink()),
              ],
            );
          }
        }

        return Stack(
          alignment: Alignment.center,
          children: [
            // ignore: use_null_aware_elements
            if (backgroundHighlight != null) backgroundHighlight,
            isSelected && isCurrentMonth
                ? Container(
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryNavy,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${date.day}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: isCurrentMonth ? () => _onDayTapped(date) : null,
                    child: Container(
                      width: 38,
                      height: 38,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${date.day}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: isCurrentMonth ? FontWeight.w600 : FontWeight.w500,
                          color: isCurrentMonth
                              ? AppColors.primaryNavy
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
          ],
        );
      },
    );
  }
}
