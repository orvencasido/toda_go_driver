import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'map_picker_screen.dart';
import 'fare_summary_screen.dart';

class PickupDropoffScreen extends StatefulWidget {
  const PickupDropoffScreen({super.key});

  @override
  State<PickupDropoffScreen> createState() => _PickupDropoffScreenState();
}

class _PickupDropoffScreenState extends State<PickupDropoffScreen> {
  String _pickupAddress = 'Select Pick-up Location';
  String _pickupSub = 'Tap to choose on map';
  String _dropoffAddress = 'Select Drop-off Location';
  String _dropoffSub = 'Tap to choose on map';
  
  double _distance = 0.0;
  int _tripFare = 0;
  int _doorToDoorFare = 100;

  void _calculateFare() {
    if (_pickupAddress != 'Select Pick-up Location' && _dropoffAddress != 'Select Drop-off Location') {
      _distance = 6.5; 
      if (_distance <= 5) {
        _tripFare = 15;
      } else {
        _tripFare = 15 + ((_distance - 5).ceil() * 2);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF000080);
    const Color backgroundColor = Color(0xFFF8F9FA);

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
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                        Icons.electric_rickshaw_rounded,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
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
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          'LOCATION',
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Back Button on Right Side
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
                    ),
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
                  // Location Input Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildLocationItem(
                          icon: Icons.my_location_rounded,
                          iconColor: Colors.blue,
                          label: 'Pick-up',
                          address: _pickupAddress,
                          sub: _pickupSub,
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MapPickerScreen(title: 'Pick-up'),
                              ),
                            );
                            if (result != null && result is Map<String, String>) {
                              setState(() {
                                _pickupAddress = result['address']!;
                                _pickupSub = result['sub']!;
                                _calculateFare();
                              });
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 45, top: 5, bottom: 5),
                          child: Container(
                            height: 30,
                            width: 1.5,
                            color: Colors.grey[200],
                          ),
                        ),
                        _buildLocationItem(
                          icon: Icons.location_on_rounded,
                          iconColor: Colors.redAccent,
                          label: 'Drop-off',
                          address: _dropoffAddress,
                          sub: _dropoffSub,
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MapPickerScreen(title: 'Drop-off'),
                              ),
                            );
                            if (result != null && result is Map<String, String>) {
                              setState(() {
                                _dropoffAddress = result['address']!;
                                _dropoffSub = result['sub']!;
                                _calculateFare();
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Estimated Fare Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                          child: Text(
                            'Fare Estimation',
                            style: GoogleFonts.poppins(
                              color: darkBlue,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Divider(height: 1),
                        _buildFareRow('Trip Fare', '₱$_tripFare'),
                        const Divider(height: 1, indent: 20, endIndent: 20),
                        _buildFareRow('Service Fee', '₱$_doorToDoorFare'),
                        
                        if (_distance > 0)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: darkBlue.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.route_rounded, size: 16, color: darkBlue),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Distance: ${_distance.toStringAsFixed(1)} km',
                                    style: GoogleFonts.poppins(
                                      color: darkBlue,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // CONTINUE Button
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: (_tripFare > 0) ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FareSummaryScreen(
                              tripFare: _tripFare,
                              doorToDoorFare: _doorToDoorFare,
                            ),
                          ),
                        );
                      } : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 4,
                        shadowColor: darkBlue.withOpacity(0.3),
                        disabledBackgroundColor: Colors.grey[300],
                      ),
                      child: Text(
                        'CONTINUE',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String address,
    required String sub,
    required VoidCallback onTap,
  }) {
    const Color darkBlue = Color(0xFF000080);
    bool isPlaceholder = address.contains('Select');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[100]!),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      color: Colors.grey[500],
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: isPlaceholder ? Colors.grey[400] : darkBlue,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    sub,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.map_rounded, color: darkBlue.withOpacity(0.3), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFareRow(String label, String amount) {
    const Color darkBlue = Color(0xFF000080);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.grey[600],
              fontSize: 15,
              fontWeight: FontWeight.w500,
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
