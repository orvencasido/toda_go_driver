import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pickup_dropoff_screen.dart';

class PassengerTypeScreen extends StatefulWidget {
  const PassengerTypeScreen({super.key});

  @override
  State<PassengerTypeScreen> createState() => _PassengerTypeScreenState();
}

class _PassengerTypeScreenState extends State<PassengerTypeScreen> {
  final Map<String, bool> _selectedTypes = {
    'Senior Citizens': false,
    'Student': false,
    'PWD': false,
    'Regular': true,
  };

  final Map<String, int> _quantities = {
    'Senior Citizens': 1,
    'Student': 1,
    'PWD': 1,
    'Regular': 1,
  };

  int get _totalCount {
    int total = 0;
    _selectedTypes.forEach((key, isSelected) {
      if (isSelected) {
        total += _quantities[key] ?? 0;
      }
    });
    return total;
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
                          'PASSENGERS',
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
                  const SizedBox(height: 10),
                  Text(
                    'Select passenger types and quantities',
                    style: GoogleFonts.poppins(
                      color: darkBlue.withOpacity(0.6),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 25),
                  
                  _buildPassengerCard('Regular', Icons.person_outline_rounded),
                  const SizedBox(height: 16),
                  _buildPassengerCard('Student', Icons.school_outlined),
                  const SizedBox(height: 16),
                  _buildPassengerCard('Senior Citizens', Icons.elderly_rounded),
                  const SizedBox(height: 16),
                  _buildPassengerCard('PWD', Icons.accessible_rounded),
                  
                  const SizedBox(height: 30),
                  
                  // Total Count Display
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    decoration: BoxDecoration(
                      color: darkBlue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Passengers:',
                          style: GoogleFonts.poppins(
                            color: darkBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '$_totalCount / 4',
                          style: GoogleFonts.poppins(
                            color: darkBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // CONFIRM Button
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _totalCount > 0 ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PickupDropoffScreen(),
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

  Widget _buildPassengerCard(String title, IconData icon) {
    const Color darkBlue = Color(0xFF000080);
    bool isSelected = _selectedTypes[title] ?? false;
    int quantity = _quantities[title] ?? 1;

    return GestureDetector(
      onTap: () {
        if (!isSelected && _totalCount >= 4) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Maximum of 4 passengers allowed'),
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }
        setState(() {
          _selectedTypes[title] = !isSelected;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? darkBlue : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? darkBlue.withOpacity(0.1) : Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected ? darkBlue.withOpacity(0.05) : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? darkBlue : Colors.grey[400],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: darkBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: darkBlue,
                    size: 20,
                  ),
              ],
            ),
            if (isSelected) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Divider(height: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Quantity',
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      _buildQtyBtn(title, -1, quantity > 1),
                      const SizedBox(width: 15),
                      Text(
                        quantity.toString(),
                        style: GoogleFonts.poppins(
                          color: darkBlue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 15),
                      _buildQtyBtn(title, 1, _totalCount < 4),
                    ],
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQtyBtn(String title, int delta, bool enabled) {
    const Color darkBlue = Color(0xFF000080);
    return GestureDetector(
      onTap: enabled ? () {
        setState(() {
          _quantities[title] = (_quantities[title] ?? 1) + delta;
        });
      } : null,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: enabled ? darkBlue : Colors.grey[200],
          shape: BoxShape.circle,
        ),
        child: Icon(
          delta > 0 ? Icons.add : Icons.remove,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }
}
