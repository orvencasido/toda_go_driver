import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'trip_screen.dart';
import 'account_screen.dart';
import 'trip_details_screen.dart';
import '../services/booking_service.dart';
import '../models/booking_model.dart';
import '../services/auth_service.dart';

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
  bool _isOnline = false;

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
    final List<Widget> _views = [
      _DashboardHomeView(
        isOnline: _isOnline,
        onToggleOnline: (val) => setState(() => _isOnline = val),
      ),
      const TripScreen(),
      const AccountScreen(),
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
              label: 'HOME',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_rounded),
              activeIcon: Icon(Icons.list_alt_rounded, size: 28),
              label: 'TRIP',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              activeIcon: Icon(Icons.person_rounded, size: 28),
              label: 'ACCOUNT',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: DashboardTheme.darkBlue,
          unselectedItemColor: Colors.grey.withOpacity(0.5),
          backgroundColor: DashboardTheme.white,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 10),
          unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 10),
        ),
      ),
    );
  }
}



class _DashboardHomeView extends StatefulWidget {
  final bool isOnline;
  final ValueChanged<bool> onToggleOnline;

  const _DashboardHomeView({
    required this.isOnline,
    required this.onToggleOnline,
  });

  @override
  State<_DashboardHomeView> createState() => _DashboardHomeViewState();
}

class _DashboardHomeViewState extends State<_DashboardHomeView> {
  final BookingService _bookingService = BookingService();
  final AuthService _authService = AuthService();
  bool _isAccepting = false; // Prevent double-taps while accepting
  
  late final String _driverId;
  late final Stream<Booking?> _activeBookingStream;
  late final Stream<List<Booking>> _pendingBookingsStream;

  @override
  void initState() {
    super.initState();
    _driverId = _authService.currentUser?.uid ?? '';
    _activeBookingStream = _bookingService.streamActiveBooking(_driverId);
    _pendingBookingsStream = _bookingService.streamPendingBookings();
  }

  @override
  Widget build(BuildContext context) {
    if (_driverId.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _DashboardHeader(),
          const SizedBox(height: 25),
          _ProfileCard(),
          const SizedBox(height: 25),
          _OnlineToggle(isOnline: widget.isOnline, onToggle: widget.onToggleOnline),
          const SizedBox(height: 35),

          if (widget.isOnline)
            // Stream the active booking to persist state across app restarts.
            StreamBuilder<Booking?>(
              stream: _activeBookingStream,
              builder: (context, activeSnapshot) {
                if (activeSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                // If there's a stream error, fall through to pending requests
                // rather than showing a blank screen.
                final activeBooking = activeSnapshot.hasError ? null : activeSnapshot.data;

                if (activeBooking != null) {
                  // Driver has an ongoing trip — show the busy card (always tappable)
                  return _BusyPlaceholder(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TripDetailsScreen(
                            onBusyChanged: (_) {},
                            initialIsBusy: true,
                            bookingId: activeBooking.id,
                          ),
                        ),
                      );
                    },
                  );
                }

                // No active booking — show pending requests
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionTitle(title: 'Incoming Ride Requests'),
                    const SizedBox(height: 15),
                    StreamBuilder<List<Booking>>(
                      stream: _pendingBookingsStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: Text(
                                'Unable to load requests. Check your connection.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(color: Colors.red[400]),
                              ),
                            ),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: Column(
                                children: [
                                  Icon(Icons.radar_rounded, size: 50, color: Colors.grey[300]),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Scanning for passengers...',
                                    style: GoogleFonts.poppins(color: Colors.grey[500]),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return Column(
                          children: snapshot.data!.map((booking) {
                            return _UpcomingRideItem(
                              location: booking.pickupAddress,
                              earnings: '₱${booking.fare.toStringAsFixed(2)}',
                              time: 'Now',
                              onTap: _isAccepting
                                  ? null
                                  : () async {
                                      setState(() => _isAccepting = true);
                                      try {
                                        final driver = await _authService.getDriverData(_driverId);
                                        if (driver == null) {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Could not load driver profile. Please try again.')),
                                            );
                                          }
                                          return;
                                        }

                                        final success = await _bookingService.acceptBooking(
                                          booking.id,
                                          driver.uid,
                                          driver.fullName,
                                          driver.plateNumber,
                                        );

                                        if (success && context.mounted) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => TripDetailsScreen(
                                                onBusyChanged: (_) {},
                                                initialIsBusy: true,
                                                bookingId: booking.id,
                                              ),
                                            ),
                                          );
                                        } else if (!success && context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Failed to accept booking. It may have been taken.')),
                                          );
                                        }
                                      } finally {
                                        if (mounted) setState(() => _isAccepting = false);
                                      }
                                    },
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                );
              },
            )
          else
            const _OfflinePlaceholder(),

          const SizedBox(height: 25),
        ],
      ),
    );
  }
}

class _BusyPlaceholder extends StatelessWidget {
  final VoidCallback onTap;
  const _BusyPlaceholder({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 40.0, left: 25, right: 25),
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.orange.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              const Icon(Icons.timer_rounded, size: 50, color: Colors.orange),
              const SizedBox(height: 15),
              Text(
                'Ongoing Booking',
                style: GoogleFonts.poppins(
                  color: Colors.orange[800],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Complete your current trip to see new requests.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.orange[700],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[800],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 0,
                  ),
                  child: Text(
                    'View Active Trip',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OfflinePlaceholder extends StatelessWidget {
  const _OfflinePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: Column(
          children: [
            Icon(Icons.info_outline_rounded, size: 50, color: Colors.grey[300]),
            const SizedBox(height: 15),
            Text(
              'Go Online to see ride requests',
              style: GoogleFonts.poppins(
                color: Colors.grey[400],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF000080);
    return Container(
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
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    'Tayabas City TODA',
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
    );
  }
}

class _ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF000080);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              darkBlue,
              Color(0xFF1A237E),
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 35,
                backgroundColor: Colors.grey[200],
                child: const Icon(Icons.person_rounded, size: 40, color: darkBlue),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Joross A. Buera',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Total Earnings: ₱300',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
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

class _OnlineToggle extends StatelessWidget {
  final bool isOnline;
  final ValueChanged<bool> onToggle;

  const _OnlineToggle({required this.isOnline, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: GestureDetector(
        onTap: () => onToggle(!isOnline),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 100,
          decoration: BoxDecoration(
            color: isOnline ? const Color(0xFFFF5252) : const Color(0xFF00C853),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: (isOnline ? const Color(0xFFFF5252) : const Color(0xFF00C853)).withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.power_settings_new_rounded,
                  color: isOnline ? const Color(0xFFFF5252) : const Color(0xFF00C853),
                  size: 35,
                ),
              ),
              const SizedBox(width: 20),
              Text(
                isOnline ? 'GO Offline' : 'GO Online',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
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

class _UpcomingRideItem extends StatelessWidget {
  final String location;
  final String earnings;
  final String time;
  final VoidCallback? onTap;

  const _UpcomingRideItem({
    required this.location,
    required this.earnings,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
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
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Incoming Request',
                      style: GoogleFonts.poppins(
                        color: DashboardTheme.darkBlue.withOpacity(0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      time,
                      style: GoogleFonts.poppins(
                        color: Colors.orange,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.location_on_rounded, color: Colors.red, size: 28),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pick up: $location',
                            style: GoogleFonts.poppins(
                              color: DashboardTheme.darkBlue,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Earnings: $earnings',
                            style: GoogleFonts.poppins(
                              color: Colors.green[700],
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
