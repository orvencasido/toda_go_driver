import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF000080);
    const Color backgroundColor = Color(0xFFF8F9FA);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              
              // App Icon / Logo - Plain
              SizedBox(
                height: 200,
                width: 200,
                child: Image.asset(
                  'assets/images/toda_go.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.directions_bike_rounded, size: 120, color: darkBlue);
                  },
                ),
              ),
              
              const SizedBox(height: 30),
              
              // App Name
              Text(
                'TODA GO Driver',
                style: GoogleFonts.poppins(
                  color: darkBlue,
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                ),
              ),
              
              // Tagline
              Text(
                '"Your safe tricycle ride in Tayabas"',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: darkBlue.withOpacity(0.6),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
              ),
              
              const Spacer(flex: 2),
              
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.login_rounded, size: 24),
                      const SizedBox(width: 12),
                      Text(
                        'Login as Driver',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 25),
              
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
