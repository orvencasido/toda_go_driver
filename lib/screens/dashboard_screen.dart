import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'select_trip_screen.dart';
import 'history_screen.dart';
import 'account_screen.dart';

// Optimization: Using constant theme data to avoid recreation in build methods
class DashboardTheme {
  static const Color darkBlue = Color(0xFF000080);
  static const Color primaryBlue = Color(0xFF1A237E);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color white = Colors.white;
  
  static final TextStyle headerStyle = GoogleFonts.poppins(
    color: white,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  
  static final TextStyle subHeaderStyle = GoogleFonts.poppins(
    color: Colors.white70,
    fontSize: 14,
  );
}

class DashboardScreen extends StatefulWidget {
  final int initialIndex;
  const DashboardScreen({super.key, this.initialIndex = 0});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Optimization: Pre-defining views as const to prevent rebuilds
    final List<Widget> _views = const [
      _DashboardHomeView(),
      HistoryScreen(),
      AccountScreen(),
    ];

    return Scaffold(
      backgroundColor: DashboardTheme.backgroundColor,
      body: _views[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              activeIcon: Icon(Icons.home_rounded, size: 28),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_rounded),
              activeIcon: Icon(Icons.history_rounded, size: 28),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              activeIcon: Icon(Icons.person_rounded, size: 28),
              label: 'Account',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: DashboardTheme.darkBlue,
          unselectedItemColor: Colors.grey.withOpacity(0.5),
          backgroundColor: DashboardTheme.white,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        ),
      ),
    );
  }
}

class _DashboardHomeView extends StatelessWidget {
  const _DashboardHomeView();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _DashboardHeader(),
          SizedBox(height: 30),
          _BookNowButton(),
          SizedBox(height: 35),
          _SectionTitle(title: 'Safety & Tips'),
          SizedBox(height: 15),
          _InfoCardsSection(),
          SizedBox(height: 30),
          _SectionTitle(title: 'Recent Trips'),
          SizedBox(height: 10),
          _RecentTripItem(
            title: 'Tayabas Public Market',
            subtitle: 'San Diego St, Tayabas City',
          ),
          _RecentTripItem(
            title: 'SM City Lucena',
            subtitle: 'Dalahican Rd, Lucena City',
          ),
          SizedBox(height: 25),
        ],
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180, 
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            DashboardTheme.darkBlue,
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
            // Welcome Text
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
                    'Hello, Joross!',
                    style: DashboardTheme.headerStyle.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  Text(
                    'Ready for a ride?',
                    style: DashboardTheme.subHeaderStyle.copyWith(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookNowButton extends StatelessWidget {
  const _BookNowButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: ElevatedButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SelectTripScreen()),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: DashboardTheme.darkBlue,
          foregroundColor: DashboardTheme.white,
          minimumSize: const Size(double.infinity, 65),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 35,
              width: 35,
              child: Image.asset(
                'assets/images/toda_go_white.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.electric_rickshaw_rounded,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 15),
            const Text(
              'BOOK A TRICYCLE',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: DashboardTheme.primaryBlue,
        ),
      ),
    );
  }
}

class _InfoCardsSection extends StatelessWidget {
  const _InfoCardsSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: [
          Row(
            children: const [
              Expanded(
                child: _InfoCard(
                  title: 'Ride Safely',
                  description: 'Always wear your helmet.',
                  color: Color(0xFFE3F2FD),
                  icon: Icons.security_rounded,
                  iconColor: Colors.blue,
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: _InfoCard(
                  title: 'Fair Rates',
                  description: 'Check our fare guide.',
                  color: Color(0xFFFFF3E0),
                  icon: Icons.payments_rounded,
                  iconColor: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: const [
              Expanded(
                child: _InfoCard(
                  title: 'Be Kind',
                  description: 'Respect our drivers.',
                  color: Color(0xFFE8F5E9),
                  icon: Icons.favorite_rounded,
                  iconColor: Colors.green,
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: _InfoCard(
                  title: 'Support',
                  description: 'Contact us anytime.',
                  color: Color(0xFFF3E5F5),
                  icon: Icons.help_outline_rounded,
                  iconColor: Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String description;
  final Color color;
  final IconData icon;
  final Color iconColor;

  const _InfoCard({
    required this.title,
    required this.description,
    required this.color,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor.withOpacity(0.6), size: 30),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            maxLines: 2,
            style: const TextStyle(color: Colors.black54, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _RecentTripItem extends StatelessWidget {
  final String title;
  final String subtitle;

  const _RecentTripItem({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: Color(0xFFEEEEEE), shape: BoxShape.circle),
            child: const Icon(Icons.history_rounded, color: Colors.grey, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
