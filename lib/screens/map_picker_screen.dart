import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MapPickerScreen extends StatelessWidget {
  final String title;
  const MapPickerScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF000080);
    const Color backgroundColor = Color(0xFFF8F9FA);

    // Simulated locations in Tayabas City
    final List<Map<String, String>> tayabasLocations = [
      {'address': 'Tayabas City Hall', 'sub': 'City Center, Tayabas'},
      {'address': 'Minor Basilica of St. Michael', 'sub': 'San Roque St, Tayabas'},
      {'address': 'Brgy. Baguio', 'sub': 'Ilaya-Tayabas, Quezon'},
      {'address': 'Sa lumang court', 'sub': 'CTS De Tayabas, P. Norte'},
      {'address': 'Tayabas Community Hospital', 'sub': 'Brgy. Wakas, Tayabas'},
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
                        Icons.map_outlined,
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
                          'PICK ON MAP',
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
          
          // Simulated Map View Area
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                border: Border.all(color: Colors.grey[300]!, width: 1),
              ),
              child: Stack(
                children: [
                  // Placeholder for Map Content
                  Center(
                    child: Opacity(
                      opacity: 0.1,
                      child: Icon(Icons.map_rounded, size: 150, color: darkBlue),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Tayabas City Map View',
                      style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  // Professional Center Marker
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on_rounded, color: Colors.redAccent, size: 45),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: darkBlue,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8),
                            ],
                          ),
                          child: Text(
                            'CONFIRM $title',
                            style: GoogleFonts.poppins(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 40), // Offset for the pin tip
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Location Suggestions List
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.history_rounded, color: darkBlue, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        'Nearby Places',
                        style: GoogleFonts.poppins(
                          color: darkBlue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: tayabasLocations.length,
                      physics: const BouncingScrollPhysics(),
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final loc = tayabasLocations[index];
                        return _buildLocationSuggestion(loc, context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSuggestion(Map<String, String> loc, BuildContext context) {
    const Color darkBlue = Color(0xFF000080);
    return InkWell(
      onTap: () => Navigator.pop(context, loc),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[100]!),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: darkBlue.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.location_on_outlined, color: darkBlue, size: 20),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc['address']!,
                    style: GoogleFonts.poppins(
                      color: darkBlue,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    loc['sub']!,
                    style: GoogleFonts.poppins(
                      color: Colors.grey[500],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: darkBlue.withOpacity(0.2), size: 14),
          ],
        ),
      ),
    );
  }
}
