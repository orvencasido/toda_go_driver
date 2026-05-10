import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'booking_confirmed_screen.dart';
import 'history_screen.dart';
import 'dashboard_screen.dart';

class SearchingTricycleScreen extends StatefulWidget {
  const SearchingTricycleScreen({super.key});

  @override
  State<SearchingTricycleScreen> createState() => _SearchingTricycleScreenState();
}

class _SearchingTricycleScreenState extends State<SearchingTricycleScreen> with TickerProviderStateMixin {
  AnimationController? _pulseController;
  Animation<double>? _pulseAnimation;
  Animation<double>? _radarOpacityAnimation;
  String _dots = '';
  late Timer _dotsTimer;

  @override
  void initState() {
    super.initState();
    
    // Initialize Radar Pulse Controller
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _pulseController!, curve: Curves.easeOut),
    );

    _radarOpacityAnimation = Tween<double>(begin: 0.5, end: 0.0).animate(
      CurvedAnimation(parent: _pulseController!, curve: Curves.easeOut),
    );

    // Start radar animation
    _pulseController!.repeat();

    _dotsTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
          if (_dots == '...') {
            _dots = '';
          } else {
            _dots += '.';
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseController?.dispose();
    _dotsTimer.cancel();
    super.dispose();
  }

  void _showCancelDialog() {
    const Color darkBlue = Color(0xFF000080);
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          title: Text(
            'Do you want to cancel?',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: darkBlue,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Please provide a reason for cancellation',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: reasonController,
                maxLines: 3,
                style: GoogleFonts.poppins(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Enter reason here...',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey[200]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey[200]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: darkBlue, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'No',
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const DashboardScreen(initialIndex: 1)),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Yes',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF000080);
    const Color backgroundColor = Color(0xFFF8F9FA);

    // Check if controller is initialized to prevent crashes
    if (_pulseController == null) {
      return const Scaffold(backgroundColor: backgroundColor, body: SizedBox.shrink());
    }

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
                        Icons.radar_rounded,
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
                          'SEARCHING...',
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
                ],
              ),
            ),
          ),
          
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Modern Animated Radar Search
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Pulsing Rings
                      AnimatedBuilder(
                        animation: _pulseController!,
                        builder: (context, child) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              _buildPulseRing(
                                (_pulseAnimation?.value ?? 1.0), 
                                (_radarOpacityAnimation?.value ?? 0.0)
                              ),
                              _buildPulseRing(
                                (_pulseAnimation?.value ?? 1.0) * 0.7, 
                                (_radarOpacityAnimation?.value ?? 0.0) * 1.2
                              ),
                            ],
                          );
                        },
                      ),
                      // Core Branded Image (Static as requested)
                      SizedBox(
                        height: 140,
                        width: 140,
                        child: Image.asset(
                          'assets/images/toda_go.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.electric_rickshaw_rounded,
                            color: darkBlue,
                            size: 80,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // Status Text
                  Text(
                    'Finding a tricycle nearby$_dots',
                    style: GoogleFonts.poppins(
                      color: darkBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'This usually takes a few seconds',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                  ),
                  
                  const SizedBox(height: 80),
                  
                  // CONTINUE Button (Simulating a found driver)
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BookingConfirmedScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 4,
                        shadowColor: darkBlue.withOpacity(0.3),
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
                  const SizedBox(height: 15),
                  // CANCEL BOOKING Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: TextButton(
                      onPressed: _showCancelDialog,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: BorderSide(color: Colors.redAccent.withOpacity(0.1)),
                        ),
                      ),
                      child: Text(
                        'CANCEL BOOKING',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                        ),
                      ),
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

  Widget _buildPulseRing(double scale, double opacity) {
    const Color darkBlue = Color(0xFF000080);
    return Transform.scale(
      scale: scale,
      child: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: darkBlue.withOpacity(opacity.clamp(0.0, 1.0)),
            width: 3,
          ),
        ),
      ),
    );
  }
}
