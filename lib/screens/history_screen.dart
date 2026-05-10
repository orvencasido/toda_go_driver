import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF000080);
    const Color backgroundColor = Color(0xFFF8F9FA);

    final List<Map<String, dynamic>> rides = const [
      {
        'destination': 'Tayabas Public Market',
        'pickup': 'Dap-dap',
        'date': 'February 12, 2026 1:07 PM',
        'price': '50',
        'status': 'Completed',
      },
      {
        'destination': 'Tayabas Primark',
        'pickup': 'Malagonlong Bridge',
        'date': 'February 12, 2026 2:48 PM',
        'price': '50',
        'status': 'Cancelled',
      },
      {
        'destination': 'Tayabas City Hall',
        'pickup': 'Alandy Compound',
        'date': 'February 04, 2026 7:15 AM',
        'price': '50',
        'status': 'Completed',
      },
      {
        'destination': 'Ibabang Wakas',
        'pickup': 'Ilaya Lalo',
        'date': 'February 02, 2026 4:36 PM',
        'price': '40',
        'status': 'Completed',
      },
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // Modern Header synchronized with Dashboard
          Container(
            height: 180,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  darkBlue,
                  Color(0xFF1A237E),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SafeArea(
              child: Row(
                children: [
                  // Left-aligned Logo consistent with Dashboard
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
                  // Branding & Title
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TODA GO',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          'RIDE HISTORY',
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          'Total Rides: ${rides.length}',
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20.0),
              physics: const BouncingScrollPhysics(),
              itemCount: rides.length,
              itemBuilder: (context, index) {
                return _RideCard(ride: rides[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RideCard extends StatelessWidget {
  final Map<String, dynamic> ride;
  const _RideCard({required this.ride});

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF000080);
    final bool isCompleted = ride['status'] == 'Completed';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Left Indicator & Icon
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.blue[50] : Colors.orange[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.electric_rickshaw_rounded,
                    color: isCompleted ? Colors.blue[700] : Colors.orange[700],
                    size: 24,
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.grey[200],
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            
            // Info Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ride['destination'],
                    style: GoogleFonts.poppins(
                      color: darkBlue,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 12, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          ride['pickup'],
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ride['date'],
                    style: GoogleFonts.poppins(
                      color: Colors.grey[400],
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '₱${ride['price']}',
                        style: GoogleFonts.poppins(
                          color: Colors.green[700],
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isCompleted ? Colors.green[50] : Colors.orange[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          ride['status'],
                          style: GoogleFonts.poppins(
                            color: isCompleted ? Colors.green[700] : Colors.orange[700],
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Rebook Action
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.replay_rounded),
                  color: darkBlue,
                  tooltip: 'Rebook',
                ),
                Text(
                  'Rebook',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: darkBlue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
