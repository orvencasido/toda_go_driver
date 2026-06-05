import 'package:flutter/material.dart';
import 'package:toda_go_driver/core/constants/app_colors.dart';

class TripsTab extends StatefulWidget {
  const TripsTab({super.key});

  @override
  State<TripsTab> createState() => _TripsTabState();
}

class _TripsTabState extends State<TripsTab> {
  // 0: Today, 1: Weekly, 2: Monthly
  int _selectedPeriod = 0;

  // Sample ride data
  final List<Map<String, String>> _todayRides = const [
    {
      'title': 'Ride #4',
      'origin': 'P.Gomez St.',
      'destination': 'Tayabas Cathedral',
      'distance': '2.4 km',
      'duration': '10 mins',
      'fare': '₱120',
    },
    {
      'title': 'Ride #3',
      'origin': 'Tayabas Terminal',
      'destination': 'Brgy. Camago',
      'distance': '3.8 km',
      'duration': '15 mins',
      'fare': '₱180',
    },
    {
      'title': 'Ride #2',
      'origin': 'Luis Palad National HS',
      'destination': 'City Hall',
      'distance': '1.2 km',
      'duration': '5 mins',
      'fare': '₱80',
    },
  ];

  final List<Map<String, String>> _weeklyRides = const [
    {
      'title': 'Ride #10',
      'origin': 'Market Area',
      'destination': 'Brgy. Isabang',
      'distance': '4.1 km',
      'duration': '18 mins',
      'fare': '₱200',
    },
    {
      'title': 'Ride #9',
      'origin': 'Tayabas Terminal',
      'destination': 'P.Gomez St.',
      'distance': '1.5 km',
      'duration': '7 mins',
      'fare': '₱90',
    },
  ];

  final List<Map<String, String>> _monthlyRides = const [
    {
      'title': 'Ride #25',
      'origin': 'City Hall',
      'destination': 'Brgy. Camago',
      'distance': '3.2 km',
      'duration': '12 mins',
      'fare': '₱150',
    },
  ];

  String get _earningsAmount {
    switch (_selectedPeriod) {
      case 0:
        return '1,240';
      case 1:
        return '5,680';
      case 2:
        return '22,450';
      default:
        return '1,240';
    }
  }

  String get _earningsLabel {
    switch (_selectedPeriod) {
      case 0:
        return "Today's Earnings (₱)";
      case 1:
        return "Weekly Earnings (₱)";
      case 2:
        return "Monthly Earnings (₱)";
      default:
        return "Today's Earnings (₱)";
    }
  }

  String get _ridesLabel {
    switch (_selectedPeriod) {
      case 0:
        return "Today's Rides";
      case 1:
        return "This Week's Rides";
      case 2:
        return "This Month's Rides";
      default:
        return "Today's Rides";
    }
  }

  List<Map<String, String>> get _currentRides {
    switch (_selectedPeriod) {
      case 0:
        return _todayRides;
      case 1:
        return _weeklyRides;
      case 2:
        return _monthlyRides;
      default:
        return _todayRides;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueBackground,
      body: Column(
        children: [
          // ─── DARK BLUE HEADER ───
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              bottom: 24,
            ),
            decoration: const BoxDecoration(
              color: AppColors.primaryNavy,
            ),
            child: const Center(
              child: Text(
                "Trips",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // ─── SCROLLABLE CONTENT ───
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── TODAY / WEEKLY / MONTHLY TOGGLE ───
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        _buildPeriodTab("Today", 0),
                        _buildPeriodTab("Weekly", 1),
                        _buildPeriodTab("Monthly", 2),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ─── EARNINGS CARD ───
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 24),
                    decoration: BoxDecoration(
                      color: AppColors.primaryNavy,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          _earningsAmount,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _earningsLabel,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ─── RIDES SECTION HEADER ───
                  Text(
                    _ridesLabel,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryNavy,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ─── RIDE CARDS ───
                  ..._currentRides.map((ride) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildRideCard(
                          title: ride['title']!,
                          origin: ride['origin']!,
                          destination: ride['destination']!,
                          distance: ride['distance']!,
                          duration: ride['duration']!,
                          fare: ride['fare']!,
                        ),
                      )),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a single period toggle tab (Today / Weekly / Monthly)
  Widget _buildPeriodTab(String label, int index) {
    final bool isSelected = _selectedPeriod == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPeriod = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.onlineGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: isSelected ? Colors.white : AppColors.primaryNavy,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a single ride info card matching the screenshot layout
  Widget _buildRideCard({
    required String title,
    required String origin,
    required String destination,
    required String distance,
    required String duration,
    required String fare,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side: Ride info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryNavy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$origin → $destination",
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$distance • $duration",
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
          // Right side: Fare
          Text(
            fare,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.onlineGreen,
            ),
          ),
        ],
      ),
    );
  }
}
