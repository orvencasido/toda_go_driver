import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toda_go_driver/core/constants/app_colors.dart';
import 'package:toda_go_driver/features/dashboard/screens/trip_details_screen.dart';
import 'package:toda_go_driver/features/dashboard/screens/dashboard_screen.dart';

// ─── TRIP HISTORY MODEL ──────────────────────────────────────────────────────
class TripHistoryItem {
  final String passengerName;
  final String pickup;
  final String pickupSub;
  final String dropoff;
  final String dropoffSub;
  final String distance;
  final String duration; // e.g., "18 min"
  final String fare;
  final String paymentMethod;
  final String status; // Completed, Cancelled
  final DateTime dateTime;

  const TripHistoryItem({
    required this.passengerName,
    required this.pickup,
    required this.pickupSub,
    required this.dropoff,
    required this.dropoffSub,
    required this.distance,
    required this.duration,
    required this.fare,
    required this.paymentMethod,
    required this.status,
    required this.dateTime,
  });
}

class TripsTab extends StatefulWidget {
  const TripsTab({super.key});

  @override
  State<TripsTab> createState() => TripsTabState();
}

class TripsTabState extends State<TripsTab> {
  String _searchQuery = '';
  String _selectedTab = 'All'; // All, Completed, Cancelled

  // Date Filters
  DateTime? _startDate;
  DateTime? _endDate;

  final TextEditingController _searchController = TextEditingController();

  void resetFilters() {
    if (mounted) {
      setState(() {
        _startDate = null;
        _endDate = null;
        _searchQuery = '';
        _searchController.clear();
        _selectedTab = 'All';
      });
    }
  }



  // Updated sample data matching mockup screenshot exactly
  final List<TripHistoryItem> _allTrips = [
    TripHistoryItem(
      passengerName: 'Juan Dela Cruz',
      pickup: 'SM City Tayabas',
      pickupSub: 'Tayabas City, Quezon',
      dropoff: 'Lucban Town Proper',
      dropoffSub: 'Lucban, Quezon',
      distance: '4.2 km',
      duration: '25 min',
      fare: '₱150.00',
      paymentMethod: 'Cash',
      status: 'Cancelled',
      dateTime: DateTime(2025, 5, 14, 14, 15), // 2:15 PM
    ),
    TripHistoryItem(
      passengerName: 'Maria Santos',
      pickup: 'Lee Super Plaza',
      pickupSub: 'Tayabas City, Quezon',
      dropoff: 'Robinsons Place Tayabas',
      dropoffSub: 'Tayabas City, Quezon',
      distance: '2.1 km',
      duration: '15 min',
      fare: '₱110.00',
      paymentMethod: 'Cash',
      status: 'Completed',
      dateTime: DateTime(2025, 5, 14, 11, 44), // 11:44 AM
    ),
    TripHistoryItem(
      passengerName: 'Anna Reyes',
      pickup: '123 Main St., Barangay Poblacion',
      pickupSub: 'Tayabas City, Quezon',
      dropoff: 'Rizal Boulevard, Barangay Poblacion',
      dropoffSub: 'Tayabas City, Quezon',
      distance: '1.2 km',
      duration: '10 min',
      fare: '₱86.00',
      paymentMethod: 'Cash',
      status: 'Cancelled',
      dateTime: DateTime(2025, 5, 13, 9, 10), // 9:10 AM
    ),
    TripHistoryItem(
      passengerName: 'Carlos Garcia',
      pickup: 'Quezon Ave., Tayabas City',
      pickupSub: 'Tayabas City, Quezon',
      dropoff: 'Layabas City Proper',
      dropoffSub: 'Tayabas City, Quezon',
      distance: '3.0 km',
      duration: '18 min',
      fare: '₱120.00',
      paymentMethod: 'Cash',
      status: 'Completed',
      dateTime: DateTime(2025, 5, 13, 18, 45), // 6:45 PM
    ),
    TripHistoryItem(
      passengerName: 'Pedro Penduko',
      pickup: 'Lucena Grand Terminal',
      pickupSub: 'Lucena City, Quezon',
      dropoff: 'Pacific Mall Lucena',
      dropoffSub: 'Lucena City, Quezon',
      distance: '5.4 km',
      duration: '30 min',
      fare: '₱180.00',
      paymentMethod: 'Cash',
      status: 'Completed',
      dateTime: DateTime(2025, 5, 12, 10, 30), // May 12, 10:30 AM
    ),
    TripHistoryItem(
      passengerName: 'Gloria Arroyo',
      pickup: 'Tayabas Community Hospital',
      pickupSub: 'Tayabas City, Quezon',
      dropoff: 'St. John the Baptist Parish',
      dropoffSub: 'Tayabas City, Quezon',
      distance: '2.8 km',
      duration: '12 min',
      fare: '₱90.00',
      paymentMethod: 'Cash',
      status: 'Completed',
      dateTime: DateTime(2025, 5, 8, 15, 20), // May 8, 3:20 PM
    ),
    TripHistoryItem(
      passengerName: 'Fidel Ramos',
      pickup: 'Kamay ni Hesus',
      pickupSub: 'Lucban, Quezon',
      dropoff: 'Lucban Market',
      dropoffSub: 'Lucban, Quezon',
      distance: '3.5 km',
      duration: '15 min',
      fare: '₱130.00',
      paymentMethod: 'Cash',
      status: 'Completed',
      dateTime: DateTime(2025, 5, 4, 14, 00), // May 4, 2:00 PM
    ),
    TripHistoryItem(
      passengerName: 'Joseph Estrada',
      pickup: 'Sariaya Town Plaza',
      pickupSub: 'Sariaya, Quezon',
      dropoff: 'Sariaya Beach',
      dropoffSub: 'Sariaya, Quezon',
      distance: '8.0 km',
      duration: '40 min',
      fare: '₱250.00',
      paymentMethod: 'Cash',
      status: 'Completed',
      dateTime: DateTime(2025, 4, 30, 16, 15), // April 30, 4:15 PM (Outside May)
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Returns list of all matching trips based on active Category Tab, Search, and Custom Range filters
  List<TripHistoryItem> get _filteredTrips {
    final filtered = _allTrips.where((trip) {
      if (_searchQuery.isNotEmpty) {
        final matchesPickup = trip.pickup.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesDropoff = trip.dropoff.toLowerCase().contains(_searchQuery.toLowerCase());
        if (!matchesPickup && !matchesDropoff) return false;
      }

      if (_selectedTab == 'Completed' && trip.status != 'Completed') return false;
      if (_selectedTab == 'Cancelled' && trip.status != 'Cancelled') return false;

      // Filter by custom range if active
      if (_startDate != null && _endDate != null) {
        if (!_matchesDateFilter(trip.dateTime)) return false;
      }

      return true;
    }).toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

    return filtered;
  }

  bool get _hasFilter {
    return _searchQuery.isNotEmpty ||
        _selectedTab != 'All' ||
        (_startDate != null && _endDate != null);
  }

  // Helper check if a trip DateTime matches the selected date filter
  bool _matchesDateFilter(DateTime tripDateTime) {
    if (_startDate == null || _endDate == null) return false;

    final tripDate = DateTime(tripDateTime.year, tripDateTime.month, tripDateTime.day);
    final start = DateTime(_startDate!.year, _startDate!.month, _startDate!.day);
    final end = DateTime(_endDate!.year, _endDate!.month, _endDate!.day);
    return (tripDate.isAfter(start) || tripDate.isAtSameMomentAs(start)) &&
           (tripDate.isBefore(end) || tripDate.isAtSameMomentAs(end));
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
        return _CalendarFilterBottomSheet(
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
  @override
  Widget build(BuildContext context) {
    final filtered = _filteredTrips;
    final hasFilter = _hasFilter;

    // For default grouped state:
    final today = DateTime(2025, 5, 14);
    final yesterday = DateTime(2025, 5, 13);

    final todayTrips = <TripHistoryItem>[];
    final yesterdayTrips = <TripHistoryItem>[];
    final olderTrips = <TripHistoryItem>[];

    if (!hasFilter) {
      for (final trip in filtered) {
        final tripDate = DateTime(trip.dateTime.year, trip.dateTime.month, trip.dateTime.day);
        if (tripDate.isAtSameMomentAs(today)) {
          todayTrips.add(trip);
        } else if (tripDate.isAtSameMomentAs(yesterday)) {
          yesterdayTrips.add(trip);
        } else {
          olderTrips.add(trip);
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ─── Screen 1 Header ───
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              bottom: 18,
              left: 16,
              right: 16,
            ),
            color: AppColors.primaryNavy,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    final dashboardState = context.findAncestorStateOfType<DashboardScreenState>();
                    if (dashboardState != null) {
                      dashboardState.setIndex(0);
                    }
                  },
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/icons/logo.png',
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Trip History',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24), // Balanced spacer to match back button size
              ],
            ),
          ),

          // ─── Search Bar ───
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14.0,
                  color: AppColors.primaryNavy,
                ),
                decoration: InputDecoration(
                  hintText: 'Search pickup or drop-off',
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14.0,
                    color: Colors.grey.shade400,
                  ),
                  prefixIcon: Icon(Icons.search_rounded, color: Colors.grey.shade400),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),

          // ─── Category Tabs ───
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                _buildCategoryTab('All'),
                const SizedBox(width: 8),
                _buildCategoryTab('Completed'),
                const SizedBox(width: 8),
                _buildCategoryTab('Cancelled'),
              ],
            ),
          ),

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
                      onPressed: resetFilters,
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

          // ─── Scrollable Body ───
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasFilter) ...[
                    if (filtered.isNotEmpty) ...[
                      ...filtered.map((trip) => _buildTripCard(trip)),
                    ] else
                      _buildEmptyState(
                        title: 'No trips found',
                        subtitle: 'No trips fit the chosen filters.',
                      ),
                  ] else ...[
                    // ─── Section 1: TODAY ───
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 6),
                      child: const Text(
                        'TODAY',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryNavy,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    if (todayTrips.isNotEmpty)
                      ...todayTrips.map((trip) => _buildTripCard(trip))
                    else
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        padding: const EdgeInsets.all(20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
                        ),
                        child: const Center(
                          child: Text(
                            'No trips today',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 12),

                    // ─── Section 2: YESTERDAY ───
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
                      child: const Text(
                        'YESTERDAY',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryNavy,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    if (yesterdayTrips.isNotEmpty)
                      ...yesterdayTrips.map((trip) => _buildTripCard(trip))
                    else
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        padding: const EdgeInsets.all(20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
                        ),
                        child: const Center(
                          child: Text(
                            'No trips yesterday',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),

                    // ─── Section 3: OLDER TRIPS ───
                    if (olderTrips.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
                        child: const Text(
                          'OLDER TRIPS',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryNavy,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      ...olderTrips.map((trip) => _buildTripCard(trip)),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    String title = 'No trips found',
    String subtitle = 'No trips fit the chosen filters.',
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.history_rounded, size: 40, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryNavy,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(String title) {
    final bool isSelected = _selectedTab == title;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = title;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryNavy : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.primaryNavy : const Color(0xFFE2E8F0),
              width: 1,
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTripCard(TripHistoryItem trip) {
    final bool isCompleted = trip.status == 'Completed';

    final bool hasFilter = _hasFilter;
    final tripDate = DateTime(trip.dateTime.year, trip.dateTime.month, trip.dateTime.day);
    final today = DateTime(2025, 5, 14);
    final yesterday = DateTime(2025, 5, 13);
    final bool isTodayOrYesterday = tripDate.isAtSameMomentAs(today) || tripDate.isAtSameMomentAs(yesterday);

    final String displayTime;
    if (!hasFilter && isTodayOrYesterday) {
      displayTime = DateFormat('h:mm a').format(trip.dateTime);
    } else {
      displayTime = DateFormat('MMMM d, yyyy • h:mm a').format(trip.dateTime);
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TripDetailsScreen(
                  passengerName: trip.passengerName,
                  pickup: trip.pickup,
                  pickupSub: trip.pickupSub,
                  dropoff: trip.dropoff,
                  dropoffSub: trip.dropoffSub,
                  distance: trip.distance,
                  duration: trip.duration,
                  fare: trip.fare,
                  paymentMethod: trip.paymentMethod,
                  status: trip.status,
                  dateTime: DateFormat('MMMM d, yyyy • h:mm a').format(trip.dateTime),
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        displayTime,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? const Color(0xFFE8F8F0)
                            : const Color(0xFFFDE8E8),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        trip.status,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isCompleted
                              ? const Color(0xFF00B050)
                              : const Color(0xFFE53935),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Column(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF00B050),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            width: 1.5,
                            height: 42, // Adjusted height for sub-addresses
                            color: Colors.grey.shade100,
                          ),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE53935),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trip.pickup,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryNavy,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            trip.pickupSub,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            trip.dropoff,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryNavy,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            trip.dropoffSub,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          trip.fare,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isCompleted ? AppColors.primaryNavy : const Color(0xFFE53935),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          trip.paymentMethod,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.grey.shade400,
                          size: 20,
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(height: 1, thickness: 0.8, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Icon(Icons.edit_road_rounded, size: 14, color: Colors.grey.shade400),
                    const SizedBox(width: 6),
                    Text(
                      trip.distance,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '|',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12.5,
                        color: Colors.grey.shade300,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.access_time_rounded, size: 14, color: Colors.grey.shade400),
                    const SizedBox(width: 6),
                    Text(
                      trip.duration,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── SCREEN 2: FILTER BY DATE BOTTOM SHEET WIDGET ──────────────────────────
class _CalendarFilterBottomSheet extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final Function(DateTime?, DateTime?) onApply;

  const _CalendarFilterBottomSheet({
    required this.initialStartDate,
    required this.initialEndDate,
    required this.onApply,
  });

  @override
  State<_CalendarFilterBottomSheet> createState() => _CalendarFilterBottomSheetState();
}

class _CalendarFilterBottomSheetState extends State<_CalendarFilterBottomSheet> {
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
            ?backgroundHighlight,
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
