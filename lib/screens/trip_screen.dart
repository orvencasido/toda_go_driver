import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/booking_model.dart';
import '../services/auth_service.dart';
import '../services/booking_service.dart';

class TripScreen extends StatelessWidget {
  const TripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF000080);
    const Color backgroundColor = Color(0xFFF8F9FA);
    final driverId = AuthService().currentUser?.uid;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Container(
            height: 180,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [darkBlue, Color(0xFF1A237E)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SafeArea(
              child: Row(
                children: [
                  Container(
                    height: 115,
                    width: 115,
                    padding: const EdgeInsets.all(5),
                    child: Image.asset(
                      'assets/images/toda_go_white.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.history_rounded,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'TRIP HISTORY',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: driverId == null
                ? const Center(child: Text('Please log in to view trip history.'))
                : FutureBuilder<List<Booking>>(
                    future: BookingService().getDriverHistory(driverId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final trips = snapshot.data ?? [];
                      if (trips.isEmpty) {
                        return Center(
                          child: Text(
                            'No completed trips yet.',
                            style: GoogleFonts.poppins(color: Colors.grey[500]),
                          ),
                        );
                      }
                      final total = trips
                          .where((trip) => trip.status == BookingStatus.completed)
                          .fold<double>(0, (sum, trip) => sum + trip.fare);
                      return ListView(
                        padding: const EdgeInsets.all(25.0),
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 25),
                            decoration: BoxDecoration(
                              color: darkBlue,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                              child: Text(
                                'PHP ${total.toStringAsFixed(0)}',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          ...trips.map((trip) => _HistoryItem(booking: trip)),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final Booking booking;
  const _HistoryItem({required this.booking});

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF000080);
    final date = DateFormat('MMM d, yyyy h:mm a').format(booking.createdAt.toLocal());
    final completed = booking.status == BookingStatus.completed;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.route_rounded, color: completed ? Colors.green : Colors.orange),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.dropoffAddress,
                  style: GoogleFonts.poppins(
                    color: darkBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(date, style: GoogleFonts.poppins(color: Colors.grey[500], fontSize: 12)),
              ],
            ),
          ),
          Text(
            'PHP ${booking.fare.toStringAsFixed(0)}',
            style: GoogleFonts.poppins(
              color: darkBlue,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
