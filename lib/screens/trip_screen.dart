import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TripScreen extends StatefulWidget {
  const TripScreen({super.key});

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  String _selectedFilter = 'Today';

  // Dummy Data sets
  final Map<String, Map<String, dynamic>> _filterData = {
    'Today': {
      'total': '850',
      'items': [
        {'title': 'Morning Shift', 'subtitle': '6:00 AM - 12:00 PM', 'trips': '12 trips', 'earnings': '450', 'rating': '5.0'},
        {'title': 'Afternoon Shift', 'subtitle': '1:00 PM - 5:00 PM', 'trips': '8 trips', 'earnings': '400', 'rating': 'No Review'},
      ]
    },
    'Weekly': {
      'total': '25,430',
      'items': [
        {'title': 'This Week', 'subtitle': 'May 04 - May 10', 'trips': '85 trips', 'earnings': '25,430'},
        {'title': 'Last Week', 'subtitle': 'Apr 27 - May 03', 'trips': '92 trips', 'earnings': '28,100'},
      ]
    },
    'Monthly': {
      'total': '145,800',
      'items': [
        {'title': 'April', 'subtitle': 'P.Gomez S;', 'trips': '135 trips', 'earnings': '25,430'},
        {'title': 'March', 'subtitle': 'P.Gomez S;', 'trips': '145 trips', 'earnings': '145,800'},
        {'title': 'February', 'subtitle': 'P.Gomez S;', 'trips': '130 trips', 'earnings': '22,800'},
        {'title': 'January', 'subtitle': 'P.Gomez S;', 'trips': '115 trips', 'earnings': '18,340'},
      ]
    },
  };

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF000080);
    const Color backgroundColor = Color(0xFFF8F9FA);

    final currentData = _filterData[_selectedFilter]!;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // Retained Header Design
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TODA GO DRIVER',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          'TRIP HISTORY',
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
                ],
              ),
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Filter Tabs
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildFilterBtn('Today'),
                      _buildFilterBtn('Weekly'),
                      _buildFilterBtn('Monthly'),
                    ],
                  ),
                  const SizedBox(height: 25),
                  
                  // Big Summary Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    decoration: BoxDecoration(
                      color: darkBlue,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: darkBlue.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '₱${currentData['total']}',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Dynamic Breakdown List
                  ... (currentData['items'] as List<Map<String, String>>).map((item) {
                    return _buildHistoryItem(
                      item['title']!, 
                      item['subtitle']!, 
                      item['trips']!, 
                      item['earnings']!,
                      rating: item['rating'],
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBtn(String label) {
    bool isSelected = _selectedFilter == label;
    const Color darkBlue = Color(0xFF000080);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: GestureDetector(
          onTap: () => setState(() => _selectedFilter = label),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 50,
            decoration: BoxDecoration(
              color: isSelected ? darkBlue : const Color(0xFF64B5F6).withOpacity(0.2),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  color: isSelected ? Colors.white : darkBlue.withOpacity(0.6),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItem(String title, String subtitle, String trips, String earnings, {String? rating}) {
    const Color darkBlue = Color(0xFF000080);
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: darkBlue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        color: darkBlue,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '/ $trips',
                      style: GoogleFonts.poppins(
                        color: Colors.grey[400],
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                if (rating != null) ...[
                  const SizedBox(height: 5),
                  if (rating == 'No Review')
                    Text(
                      'No Review',
                      style: GoogleFonts.poppins(
                        color: Colors.grey[400],
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  else
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                        const SizedBox(width: 2),
                        Text(
                          rating,
                          style: GoogleFonts.poppins(
                            color: darkBlue.withOpacity(0.6),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(5.0 rating)',
                          style: GoogleFonts.poppins(
                            color: Colors.grey[400],
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                ],
              ],
            ),
          ),
          Text(
            '₱$earnings',
            style: GoogleFonts.poppins(
              color: darkBlue,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
