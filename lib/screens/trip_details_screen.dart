import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'payment_screen.dart';
import '../services/booking_service.dart';
import '../models/booking_model.dart';

class TripDetailsScreen extends StatefulWidget {
  final ValueChanged<bool>? onBusyChanged;
  final bool initialIsBusy;
  final String? bookingId;

  const TripDetailsScreen({
    super.key, 
    this.onBusyChanged,
    this.initialIsBusy = false,
    this.bookingId,
  });

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  late bool _isConfirmed;
  final BookingService _bookingService = BookingService();

  @override
  void initState() {
    super.initState();
    _isConfirmed = widget.initialIsBusy;
  }

  void _updateBusyStatus(bool isBusy) {
    setState(() {
      _isConfirmed = isBusy;
    });
    widget.onBusyChanged?.call(isBusy);
  }

  Future<void> _handleCompleteBooking() async {
    if (widget.bookingId != null) {
      bool success = await _bookingService.updateTripStatus(widget.bookingId!, BookingStatus.completed);
      if (success) {
        _updateBusyStatus(false);
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PaymentScreen()),
          );
        }
      }
    }
  }

  Future<void> _handleCancelBooking() async {
    if (widget.bookingId != null) {
      bool success = await _bookingService.updateTripStatus(widget.bookingId!, BookingStatus.cancelled);
      if (success) {
        _updateBusyStatus(false);
        if (mounted) {
          Navigator.pop(context); // Close dialog
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Booking Cancelled')),
          );
        }
      }
    }
  }

  void _showConfirmationPopup(String passengerName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFF00C853),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 60),
              ),
              const SizedBox(height: 25),
              Text(
                'Booking Confirmed!',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF000080),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Safe travels with $passengerName',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF000080),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCancellationPopup() {
    final TextEditingController reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Cancel Booking?',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF000080),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Please state the reason for cancellation',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: reasonController,
                maxLines: 3,
                style: GoogleFonts.poppins(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Enter reason here...',
                  hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Back', 
                        style: GoogleFonts.poppins(color: Colors.grey[600], fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _handleCancelBooking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: Text(
                        'Confirm',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF000080);
    const Color backgroundColor = Color(0xFFF8F9FA);

    if (widget.bookingId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('No booking ID provided')),
      );
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('bookings').doc(widget.bookingId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(body: Center(child: Text('Booking not found')));
        }

        final booking = Booking.fromMap(snapshot.data!.data() as Map<String, dynamic>, snapshot.data!.id);
        final String passengerName = "Passenger ${booking.passengerId.substring(0, 5)}"; // Placeholder for passenger name

        return Scaffold(
          backgroundColor: backgroundColor,
          body: Column(
            children: [
              // Header (Redesigned to match Dashboard)
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
                      // Left-aligned Logo
                      Container(
                        height: 115,
                        width: 115,
                        padding: const EdgeInsets.all(5),
                        child: Image.asset(
                          'assets/images/toda_go_white.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.electric_rickshaw_rounded,
                            size: 60,
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
                              'TODA GO DRIVER',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Text(
                              'Trip Details',
                              style: GoogleFonts.poppins(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Back Button moved to the right
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(25.0),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Map Card (Stylized Navigation View)
                      Container(
                        height: 250,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Map Grid Background Placeholder
                            Positioned.fill(
                              child: Opacity(
                                opacity: 0.05,
                                child: GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 10,
                                  ),
                                  itemBuilder: (context, index) => Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: darkBlue),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Map Icon Overlay
                            Center(
                              child: Opacity(
                                opacity: 0.1,
                                child: Icon(Icons.map_rounded, size: 180, color: darkBlue),
                              ),
                            ),
                            // Route Line Placeholder
                            Center(
                              child: CustomPaint(
                                size: const Size(200, 200),
                                painter: _RoutePainter(),
                              ),
                            ),
                            // Driver Marker
                            Positioned(
                              left: 60,
                              bottom: 40,
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: darkBlue,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.electric_rickshaw_rounded, color: Colors.white, size: 24),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                                    ),
                                    child: Text(
                                      'Driver (You)', 
                                      style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: darkBlue),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Passenger Marker (Pickup)
                            Positioned(
                              right: 50,
                              top: 40,
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: Colors.redAccent,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.person_pin_circle_rounded, color: Colors.white, size: 24),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                                    ),
                                    child: Text(
                                      passengerName, 
                                      style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.redAccent),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Passenger Information (Simplified)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.person_outline_rounded, color: darkBlue, size: 28),
                            const SizedBox(width: 15),
                            Text(
                              passengerName,
                              style: GoogleFonts.poppins(
                                color: darkBlue,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Location Card
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            _buildLocationItem('Pick-Up', booking.pickupAddress, 'Now'),
                            const Divider(height: 1),
                            _buildLocationItem('Drop-Off', booking.dropoffAddress, 'ETA 15m'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Fare Summary Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fare Summary',
                              style:GoogleFonts.poppins(
                                color: darkBlue,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildFareRow('Total Fare', '₱${booking.fare.toStringAsFixed(2)}'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      // Action Button(s)
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 65,
                            child: ElevatedButton(
                              onPressed: () {
                                if (!_isConfirmed) {
                                  _showConfirmationPopup(passengerName);
                                  _updateBusyStatus(true);
                                } else {
                                  _handleCompleteBooking();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00C853),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                _isConfirmed ? 'Complete Booking' : 'Confirm Booking',
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          if (_isConfirmed) ...[
                            const SizedBox(height: 15),
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: TextButton(
                                onPressed: () {
                                  _showCancellationPopup();
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.redAccent,
                                ),
                                child: Text(
                                  'Cancel Booking',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildLocationItem(String title, String subtitle, String time) {
    const Color darkBlue = Color(0xFF000080);
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: darkBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: GoogleFonts.poppins(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFareRow(String label, String amount) {
    const Color darkBlue = Color(0xFF000080);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: darkBlue.withOpacity(0.7),
              fontSize: 15,
            ),
          ),
          Text(
            amount,
            style: GoogleFonts.poppins(
              color: darkBlue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF000080).withOpacity(0.2)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.3, size.height * 0.7)
      ..quadraticBezierTo(
        size.width * 0.5, 
        size.height * 0.6, 
        size.width * 0.7, 
        size.height * 0.3
      );

    canvas.drawPath(path, paint);
    
    // Add dots along the path
    final dotPaint = Paint()..color = const Color(0xFF000080).withOpacity(0.4);
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.7), 4, dotPaint);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.3), 4, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
