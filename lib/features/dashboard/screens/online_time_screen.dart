import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toda_go_driver/core/constants/app_colors.dart';

// ── Session Model ────────────────────────────────────────────────────────────
class _OnlineSession {
  final DateTime date; // Day anchor (e.g. May 14, 2025)
  final String loginTime;
  final String logoutTime;
  final String duration;
  final DateTime loginDateTime; // For filtering

  const _OnlineSession({
    required this.date,
    required this.loginTime,
    required this.logoutTime,
    required this.duration,
    required this.loginDateTime,
  });
}

// ── Mock Sessions Data ───────────────────────────────────────────────────────
final _allSessions = [
  _OnlineSession(
    date: DateTime(2025, 5, 14),
    loginTime: '8:15 AM',
    logoutTime: '11:30 AM',
    duration: '3h 15m',
    loginDateTime: DateTime(2025, 5, 14, 8, 15),
  ),
  _OnlineSession(
    date: DateTime(2025, 5, 14),
    loginTime: '1:00 PM',
    logoutTime: '3:20 PM',
    duration: '2h 20m',
    loginDateTime: DateTime(2025, 5, 14, 13, 0),
  ),
  _OnlineSession(
    date: DateTime(2025, 5, 13),
    loginTime: '7:45 AM',
    logoutTime: '10:10 AM',
    duration: '2h 25m',
    loginDateTime: DateTime(2025, 5, 13, 7, 45),
  ),
  _OnlineSession(
    date: DateTime(2025, 5, 13),
    loginTime: '12:30 PM',
    logoutTime: '4:15 PM',
    duration: '3h 45m',
    loginDateTime: DateTime(2025, 5, 13, 12, 30),
  ),
  _OnlineSession(
    date: DateTime(2025, 5, 12),
    loginTime: '8:00 AM',
    logoutTime: '11:00 AM',
    duration: '3h 00m',
    loginDateTime: DateTime(2025, 5, 12, 8, 0),
  ),
  _OnlineSession(
    date: DateTime(2025, 5, 12),
    loginTime: '1:30 PM',
    logoutTime: '3:50 PM',
    duration: '2h 20m',
    loginDateTime: DateTime(2025, 5, 12, 13, 30),
  ),
  _OnlineSession(
    date: DateTime(2025, 5, 11),
    loginTime: '9:10 AM',
    logoutTime: '12:40 PM',
    duration: '3h 30m',
    loginDateTime: DateTime(2025, 5, 11, 9, 10),
  ),
  _OnlineSession(
    date: DateTime(2025, 5, 10),
    loginTime: '8:30 AM',
    logoutTime: '11:45 AM',
    duration: '3h 15m',
    loginDateTime: DateTime(2025, 5, 10, 8, 30),
  ),
  _OnlineSession(
    date: DateTime(2025, 5, 10),
    loginTime: '2:00 PM',
    logoutTime: '5:10 PM',
    duration: '3h 10m',
    loginDateTime: DateTime(2025, 5, 10, 14, 0),
  ),
  _OnlineSession(
    date: DateTime(2025, 5, 9),
    loginTime: '7:30 AM',
    logoutTime: '11:00 AM',
    duration: '3h 30m',
    loginDateTime: DateTime(2025, 5, 9, 7, 30),
  ),
  _OnlineSession(
    date: DateTime(2025, 5, 8),
    loginTime: '9:00 AM',
    logoutTime: '1:00 PM',
    duration: '4h 00m',
    loginDateTime: DateTime(2025, 5, 8, 9, 0),
  ),
];

// ── Screen ────────────────────────────────────────────────────────────────────
class OnlineTimeScreen extends StatefulWidget {
  const OnlineTimeScreen({super.key});

  @override
  State<OnlineTimeScreen> createState() => _OnlineTimeScreenState();
}

class _OnlineTimeScreenState extends State<OnlineTimeScreen> {
  DateTime? _startDate;
  DateTime? _endDate;

  bool get _hasFilter => _startDate != null && _endDate != null;

  List<_OnlineSession> get _filteredSessions {
    if (_startDate == null || _endDate == null) {
      return _allSessions;
    }
    return _allSessions.where((session) {
      final sessionDate = DateTime(session.date.year, session.date.month, session.date.day);
      final start = DateTime(_startDate!.year, _startDate!.month, _startDate!.day);
      final end = DateTime(_endDate!.year, _endDate!.month, _endDate!.day);
      return (sessionDate.isAfter(start) || sessionDate.isAtSameMomentAs(start)) &&
             (sessionDate.isBefore(end) || sessionDate.isAtSameMomentAs(end));
    }).toList();
  }

  // Group filtered sessions by date for display
  Map<DateTime, List<_OnlineSession>> get _groupedSessions {
    final Map<DateTime, List<_OnlineSession>> grouped = {};
    for (var session in _filteredSessions) {
      final key = DateTime(session.date.year, session.date.month, session.date.day);
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(session);
    }
    return grouped;
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
        return _OnlineTimeCalendarFilterBottomSheet(
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
    final grouped = _groupedSessions;
    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

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
                    'Online Time',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 48), // balance back button
              ],
            ),
          ),

          // ── Content ───────────────────────────────────────────────────────
          Expanded(
            child: Column(
              children: [
                // ── Apply Filter Row ──
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
                          height: 52,
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

                // ── TODAY & YESTERDAY Cards ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TODAY',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textLight,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _buildMetricCard(
                        onlineSince: '8:15 AM',
                        timeMetricTitle: 'Current Online Time',
                        timeMetricValue: '1h 45m',
                        statusLabel: 'Online',
                        statusColor: AppColors.onlineGreen,
                        statusBg: const Color(0xFFEEFBF2),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'YESTERDAY',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textLight,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _buildMetricCard(
                        onlineSince: '7:30 AM',
                        timeMetricTitle: 'Total Online Time',
                        timeMetricValue: '3h 20m',
                        statusLabel: 'Offline',
                        statusColor: AppColors.textLight,
                        statusBg: AppColors.greyBg,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Sessions List ──
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: sortedKeys.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (ctx, index) {
                      final date = sortedKeys[index];
                      final sessions = grouped[date]!;
                      return _buildDateGroup(date, sessions);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String onlineSince,
    required String timeMetricTitle,
    required String timeMetricValue,
    required String statusLabel,
    required Color statusColor,
    required Color statusBg,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Online Since Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Online Since',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: AppColors.onlineGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        onlineSince,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryNavy,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Divider
          Container(
            height: 36,
            width: 1.5,
            color: Colors.grey.shade100,
          ),
          const SizedBox(width: 12),

          // Clock Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.lightBlueBtnBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.access_time_rounded,
              color: AppColors.primaryNavy,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),

          // Time metric
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  timeMetricTitle,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  timeMetricValue,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryNavy,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Badge Status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              statusLabel,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateGroup(DateTime date, List<_OnlineSession> sessions) {
    final today = DateTime(2025, 5, 14);
    final yesterday = DateTime(2025, 5, 13);

    String dateHeader = DateFormat('MMMM d, yyyy').format(date);
    if (date.year == today.year && date.month == today.month && date.day == today.day) {
      dateHeader = 'May 14, 2025';
    } else if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
      dateHeader = 'May 13, 2025';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header of group
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_rounded, color: AppColors.primaryNavy, size: 15),
                const SizedBox(width: 10),
                Text(
                  dateHeader,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryNavy,
                  ),
                ),
              ],
            ),
          ),
          // Rows
          ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sessions.length,
            separatorBuilder: (ctx, i) => Divider(height: 1, color: Colors.grey.shade100),
            itemBuilder: (ctx, i) {
              final s = sessions[i];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.access_time_rounded, color: Colors.grey.shade400, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.loginTime,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryNavy,
                                ),
                              ),
                              const Text(
                                'Login',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 9,
                                  color: AppColors.textLight,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '-',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.logoutTime,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryNavy,
                                ),
                              ),
                              const Text(
                                'Logout',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 9,
                                  color: AppColors.textLight,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Duration badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.lightBlueBtnBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        s.duration,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryNavy,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── Calendar Bottom Sheet ─────────────────────────────────────────────────────
class _OnlineTimeCalendarFilterBottomSheet extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final Function(DateTime?, DateTime?) onApply;

  const _OnlineTimeCalendarFilterBottomSheet({
    required this.initialStartDate,
    required this.initialEndDate,
    required this.onApply,
  });

  @override
  State<_OnlineTimeCalendarFilterBottomSheet> createState() => _OnlineTimeCalendarFilterBottomSheetState();
}

class _OnlineTimeCalendarFilterBottomSheetState extends State<_OnlineTimeCalendarFilterBottomSheet> {
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
                      const SizedBox(width: 48),
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
                              const Icon(Icons.date_range_rounded, color: AppColors.primaryNavy, size: 22),
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
