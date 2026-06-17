import 'package:flutter/material.dart';
import 'package:toda_go_driver/core/constants/app_colors.dart';
import 'package:toda_go_driver/features/dashboard/screens/new_ride_request_screen.dart';

class AllRideRequestsScreen extends StatelessWidget {
  const AllRideRequestsScreen({super.key});

  // Sample ride request data
  static const List<Map<String, String>> _sampleRides = [
    {
      'passenger': 'Maria Santos',
      'pickup': '123 Main St., Arnings',
      'dropoff': 'Rizal Boulevard, City Center',
      'time': '2 min ago',
      'fare': '₱86.00',
      'distance': '1.2 km',
    },
    {
      'passenger': 'John Dela Cruz',
      'pickup': 'SM City Dumaguete',
      'dropoff': 'Silliman University',
      'time': '5 min ago',
      'fare': '₱55.00',
      'distance': '0.8 km',
    },
    {
      'passenger': 'Anna Reyes',
      'pickup': 'Lee Super Plaza',
      'dropoff': 'Robinsons Place',
      'time': '8 min ago',
      'fare': '₱120.00',
      'distance': '2.5 km',
    },
    {
      'passenger': 'Carlos Garcia',
      'pickup': 'Perdices St., Centro',
      'dropoff': 'Dumaguete Port',
      'time': '12 min ago',
      'fare': '₱70.00',
      'distance': '1.0 km',
    },
    {
      'passenger': 'Liza Mendoza',
      'pickup': 'Foundation University',
      'dropoff': 'Dauin Beach Resort',
      'time': '15 min ago',
      'fare': '₱250.00',
      'distance': '6.3 km',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F2FF),
      appBar: AppBar(
        backgroundColor: AppColors.primaryNavy,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'All Ride Requests',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: _sampleRides.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: _sampleRides.length,
              itemBuilder: (context, index) {
                final ride = _sampleRides[index];
                return _RideRequestCard(
                  passenger: ride['passenger']!,
                  pickup: ride['pickup']!,
                  dropoff: ride['dropoff']!,
                  time: ride['time']!,
                  fare: ride['fare']!,
                  distance: ride['distance']!,
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(Icons.inbox_rounded, size: 48, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 20),
          const Text(
            'No ride requests yet',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryNavy,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Stay online to receive new bookings.',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Individual Ride Request Card ─────────────────────────────────────────────
class _RideRequestCard extends StatelessWidget {
  final String passenger;
  final String pickup;
  final String dropoff;
  final String time;
  final String fare;
  final String distance;

  const _RideRequestCard({
    required this.passenger,
    required this.pickup,
    required this.dropoff,
    required this.time,
    required this.fare,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Passenger Info Row ──────────────────────────────────────
          Row(
            children: [
              // Avatar
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primaryNavy.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: AppColors.primaryNavy,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              // Name + Time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      passenger,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryNavy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      time,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Fare badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryNavy.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  fare,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryNavy,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Pickup location ────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(Icons.location_on_rounded, color: Color(0xFF43A047), size: 22),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  pickup,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),

          // Connector line
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 2, bottom: 2),
            child: Container(width: 2, height: 14, color: Colors.grey.shade300),
          ),

          // ── Drop-off location ──────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(Icons.location_on_rounded, color: Color(0xFFE53935), size: 22),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  dropoff,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ── Distance badge + View Details button ───────────────────
          Row(
            children: [
              // Distance chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFF0F0F4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.straighten_rounded, size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(
                      distance,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // View Details button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NewRideRequestScreen(
                          pickup: pickup,
                          dropoff: dropoff,
                          distance: distance,
                          fare: fare,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryNavy,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryNavy.withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.info_outline_rounded, size: 15, color: Colors.white),
                        SizedBox(width: 6),
                        Text(
                          'View Details',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
