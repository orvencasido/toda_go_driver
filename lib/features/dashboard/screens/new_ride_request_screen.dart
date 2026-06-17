import 'dart:async';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:toda_go_driver/core/constants/app_colors.dart';
import 'package:toda_go_driver/features/dashboard/screens/decline_reason_screen.dart';
import 'package:toda_go_driver/features/dashboard/screens/waiting_for_passenger_screen.dart';
import 'package:toda_go_driver/widgets/open_street_map_widget.dart';

class NewRideRequestScreen extends StatefulWidget {
  final String pickup;
  final String dropoff;
  final String distance;
  final String fare;
  final String passengerName;
  final String passengerPhone;

  const NewRideRequestScreen({
    super.key,
    this.pickup = '123 Main St., Arnings',
    this.dropoff = 'Rizal Boulevard',
    this.distance = '1.2 km',
    this.fare = '₱86.00',
    this.passengerName = 'Juan Dela Cruz',
    this.passengerPhone = '09123456789',
  });

  @override
  State<NewRideRequestScreen> createState() => _NewRideRequestScreenState();
}

class _NewRideRequestScreenState extends State<NewRideRequestScreen>
    with SingleTickerProviderStateMixin {
  // ── Countdown ──────────────────────────────────────────────────────────────
  static const int _totalSeconds = 15;
  int _secondsRemaining = _totalSeconds;
  Timer? _countdownTimer;

  // ── State Flags ────────────────────────────────────────────────────────────
  bool _isAcceptedByOther = false;
  bool _isAccepted = false;
  bool _isDeclineClicked = false;

  // ── Pulse animation on the card ────────────────────────────────────────────
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  // Map coordinates matching other screens
  final ll.LatLng _pickupLocation = const ll.LatLng(14.0256, 121.5831);
  final ll.LatLng _dropoffLocation = const ll.LatLng(14.0290, 121.5900);

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.015).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _startCountdown();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  // ── Countdown Logic ────────────────────────────────────────────────────────
  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        t.cancel();
        _onCountdownExpired();
      }
    });
  }

  void _onCountdownExpired() {
    if (_isAccepted || _isAcceptedByOther) return;
    setState(() => _isAcceptedByOther = true);
    _pulseController.stop();
  }

  // ── Action Handlers ────────────────────────────────────────────────────────
  void _handleDecline() {
    if (_isAccepted || _isAcceptedByOther || _isDeclineClicked) return;
    _countdownTimer?.cancel();
    _pulseController.stop();
    setState(() {
      _isDeclineClicked = true;
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const DeclineReasonScreen(mode: DeclineMode.decline),
        ),
      );
    });
  }

  void _handleCancelRide() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const DeclineReasonScreen(mode: DeclineMode.decline),
      ),
    );
  }

  void _handleAccept() {
    if (_isAccepted || _isAcceptedByOther) return;
    _countdownTimer?.cancel();
    _pulseController.stop();
    setState(() => _isAccepted = true);
    _showSnack('✅ Ride accepted! Waiting for passenger.', AppColors.onlineGreen);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => WaitingForPassengerScreen(
            pickup: widget.pickup,
            dropoff: widget.dropoff,
            distance: widget.distance,
            fare: widget.fare,
          ),
        ),
      );
    });
  }

  void _showSnack(String msg, Color bg, {int seconds = 2}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 13),
        ),
        backgroundColor: bg,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: Duration(seconds: seconds),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F8FF),
      body: Column(
        children: [
          // ── Header ─────────────────────────────────────────────────────
          Container(
            width: double.infinity,
            color: AppColors.primaryNavy,
            padding: EdgeInsets.only(
              top: topPad + 8,
              left: 4,
              right: 16,
              bottom: 16,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded,
                      color: Colors.white, size: 24),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Text(
                    'Ride Request',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),

          // ── Body ───────────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                children: [
                  // ── Map Preview Card ───────────────────────────────────
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: OpenStreetMapWidget(
                      pickupLocation: _pickupLocation,
                      dropoffLocation: _dropoffLocation,
                      routePoints: [
                        _pickupLocation,
                        const ll.LatLng(14.0262, 121.5852),
                        const ll.LatLng(14.0270, 121.5870),
                        const ll.LatLng(14.0280, 121.5885),
                        _dropoffLocation,
                      ],
                      showRoute: true,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Ride Request Card ──────────────────────────────────
                  ScaleTransition(
                    scale: _pulseAnim,
                    child: Column(
                      children: [
                        // Passenger Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE8F2FF),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person_rounded,
                                  color: AppColors.primaryNavy,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.passengerName,
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryNavy,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    const Text(
                                      'Passenger',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 13,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Locations Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    width: 12,
                                    height: 12,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF22C55E),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Pickup',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 12,
                                            color: Color(0xFF64748B),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          widget.pickup,
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primaryNavy,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5, top: 4, bottom: 4),
                                child: Column(
                                  children: List.generate(
                                    3,
                                    (_) => Container(
                                      width: 2,
                                      height: 4,
                                      margin: const EdgeInsets.symmetric(vertical: 2),
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    width: 12,
                                    height: 12,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE53935),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Drop-off',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 12,
                                            color: Color(0xFF64748B),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          widget.dropoff,
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primaryNavy,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Metrics chips
                        Row(
                          children: [
                            _buildMetricChip(
                              icon: Icons.straighten_rounded,
                              value: widget.distance,
                              label: 'Distance',
                            ),
                            const SizedBox(width: 10),
                            _buildMetricChip(
                              icon: Icons.payments_outlined,
                              value: widget.fare,
                              label: 'Fixed Fare',
                            ),
                            const SizedBox(width: 10),
                            _buildMetricChip(
                              icon: Icons.access_time_rounded,
                              value: '~5 min',
                              label: 'ETA',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  // ── Decline + Accept Buttons ───────────────────────────
                  if (!_isAcceptedByOther && !_isAccepted)
                    Row(
                      children: [
                        // Decline Button
                        Expanded(
                          child: _buildDeclineButton(),
                        ),
                        const SizedBox(width: 14),
                        // Accept Button
                        Expanded(
                          flex: 2,
                          child: _buildAcceptButton(),
                        ),
                      ],
                    )
                  else if (_isAccepted)
                    // Cancel button after accepting
                    _buildCancelButton()
                  else
                    // Accepted by another driver status bar
                    _buildAcceptedByOtherStatusBar(),


                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Metric Chip Widget Builder ───────────────────────────────────────────
  Widget _buildMetricChip({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primaryNavy, size: 22),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryNavy,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Decline Button Widget ────────────────────────────────────────────────
  Widget _buildDeclineButton() {
    final bool redState = _isDeclineClicked;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _handleDecline,
        borderRadius: BorderRadius.circular(28),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 56,
          decoration: BoxDecoration(
            color: redState ? const Color(0xFFE53935) : Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: redState ? const Color(0xFFE53935) : const Color(0xFFE2E8F0),
              width: 1.5,
            ),
            boxShadow: redState
                ? [
                    BoxShadow(
                      color: const Color(0xFFE53935).withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: redState
                      ? Colors.white.withValues(alpha: 0.2)
                      : const Color(0xFF64748B).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  color: redState ? Colors.white : const Color(0xFF64748B),
                  size: 14,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Decline',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: redState ? Colors.white : const Color(0xFF64748B),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Accept Button Widget ─────────────────────────────────────────────────
  Widget _buildAcceptButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _handleAccept,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.primaryNavy,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryNavy.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Accept Ride',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Cancel Button Widget ─────────────────────────────────────────────────
  Widget _buildCancelButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _handleCancelRide,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFE53935),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE53935).withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cancel_outlined, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Cancel Ride',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Accepted by Another Driver Status Bar Widget ─────────────────────────
  Widget _buildAcceptedByOtherStatusBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFCE8E6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFF5C2C1),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/warning_custom.png',
            width: 20,
            height: 20,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 8),
          const Text(
            'Accepted by Another Driver',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFFC5221F),
            ),
          ),
        ],
      ),
    );
  }
}