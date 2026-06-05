import 'dart:async';
import 'package:flutter/material.dart';
import 'package:toda_go_driver/core/constants/app_colors.dart';
import 'package:toda_go_driver/features/dashboard/screens/navigating_to_pickup_screen.dart';

class NewRideRequestScreen extends StatefulWidget {
  final String pickup;
  final String dropoff;
  final String distance;
  final String fare;

  const NewRideRequestScreen({
    super.key,
    this.pickup = "123 Main St.",
    this.dropoff = "Rizal Boulevard",
    this.distance = "1.2 km",
    this.fare = "86.00",
  });

  @override
  State<NewRideRequestScreen> createState() => _NewRideRequestScreenState();
}

class _NewRideRequestScreenState extends State<NewRideRequestScreen> with SingleTickerProviderStateMixin {
  int _secondsRemaining = 15;
  Timer? _timer;
  bool _isAcceptedByOther = false;
  bool _isAcceptedByMe = false;

  // For animation of buttons
  double _buttonScale = 0.95;
  double _buttonOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    
    // Animate buttons entrance after 1 second
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _buttonScale = 1.0;
          _buttonOpacity = 1.0;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
        _handleCountdownExpired();
      }
    });
  }

  void _handleCountdownExpired() {
    if (!_isAcceptedByMe && !_isAcceptedByOther) {
      _simulateOtherDriverAccept();
    }
  }

  // Simulates when another driver accepts the ride first
  void _simulateOtherDriverAccept() {
    if (_isAcceptedByMe || _isAcceptedByOther) return;

    _timer?.cancel();
    setState(() {
      _isAcceptedByOther = true;
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Ride already accepted by another driver',
                style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.offlineRed,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _handleDecline() {
    if (_isAcceptedByOther || _isAcceptedByMe) return;
    
    _timer?.cancel();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Ride request declined.',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        backgroundColor: AppColors.primaryNavy,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleAccept() {
    if (_isAcceptedByOther || _isAcceptedByMe) return;

    _timer?.cancel();
    setState(() {
      _isAcceptedByMe = true;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => NavigatingToPickupScreen(
          pickup: widget.pickup,
          dropoff: widget.dropoff,
          distance: widget.distance,
          fare: widget.fare,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Disable buttons if another driver accepted or if already accepted by me
    final bool actionsDisabled = _isAcceptedByOther || _isAcceptedByMe;

    return Scaffold(
      backgroundColor: AppColors.lightBlueBackground,
      body: Column(
        children: [
          // ── Navy Header with Back Button (replaces X/Menu) ─────────────────
          Container(
            width: double.infinity,
            height: 100,
            color: AppColors.primaryNavy,
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.only(left: 20.0, bottom: 20.0),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 24.0,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  // ── Ride Details Card ──────────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.notifications_active_outlined,
                              color: AppColors.primaryNavy,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _isAcceptedByOther
                                  ? 'Ride Unavailable'
                                  : 'New Ride Request',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryNavy,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Route pickup & dropoff details
                        _buildRouteStep(
                          icon: Icons.my_location,
                          color: AppColors.onlineGreen,
                          title: "Pickup Location",
                          value: widget.pickup,
                        ),
                        
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              height: 16,
                              child: VerticalDivider(thickness: 1.5, color: Colors.grey),
                            ),
                          ),
                        ),

                        _buildRouteStep(
                          icon: Icons.location_on,
                          color: AppColors.offlineRed,
                          title: "Dropoff Destination",
                          value: widget.dropoff,
                        ),

                        const SizedBox(height: 20),
                        Divider(color: Colors.grey.shade200, thickness: 1),
                        const SizedBox(height: 16),

                        // Distance & Fare Info
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    widget.distance,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryNavy,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Distance',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              width: 1,
                              height: 40,
                              color: Colors.grey.shade200,
                            ),

                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    '₱${widget.fare}',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryNavy,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Est. Fare',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textLight,
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

                  const SizedBox(height: 28),

                  // ── Countdown Timer Indicator ─────────────────────────────
                  if (!_isAcceptedByOther) ...[
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: CircularProgressIndicator(
                            value: _secondsRemaining / 15,
                            strokeWidth: 6,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _secondsRemaining > 5
                                  ? AppColors.onlineGreen
                                  : AppColors.offlineRed,
                            ),
                          ),
                        ),
                        Text(
                          '${_secondsRemaining}s',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: _secondsRemaining > 5
                                ? AppColors.primaryNavy
                                : AppColors.offlineRed,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Respond immediately',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryNavy,
                      ),
                    ),
                  ] else ...[
                    // Unavailable Status Card
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.offlineRed.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.offlineRed.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.error_outline, color: AppColors.offlineRed),
                          SizedBox(width: 8),
                          Text(
                            'Accepted by Another Driver',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.offlineRed,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 36),

                  // ── Decline & Accept Buttons (with entrance animation) ───
                  AnimatedOpacity(
                    opacity: _buttonOpacity,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOut,
                    child: AnimatedScale(
                      scale: _buttonScale,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOut,
                      child: Row(
                        children: [
                          // Decline Button
                          Expanded(
                            child: GestureDetector(
                              onTap: actionsDisabled ? null : _handleDecline,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: 56,
                                decoration: BoxDecoration(
                                  color: actionsDisabled
                                      ? Colors.grey.shade300
                                      : AppColors.offlineRed,
                                  borderRadius: BorderRadius.circular(28),
                                  boxShadow: actionsDisabled
                                      ? []
                                      : [
                                          BoxShadow(
                                            color: AppColors.offlineRed.withValues(alpha: 0.25),
                                            blurRadius: 8,
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
                                        color: actionsDisabled ? Colors.grey.shade400 : Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        color: actionsDisabled ? Colors.white : AppColors.offlineRed,
                                        size: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Decline',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: actionsDisabled ? Colors.grey.shade600 : Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Accept Button
                          Expanded(
                            child: GestureDetector(
                              onTap: actionsDisabled ? null : _handleAccept,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: 56,
                                decoration: BoxDecoration(
                                  color: actionsDisabled
                                      ? Colors.grey.shade300
                                      : AppColors.onlineGreen,
                                  borderRadius: BorderRadius.circular(28),
                                  boxShadow: actionsDisabled
                                      ? []
                                      : [
                                          BoxShadow(
                                            color: AppColors.onlineGreen.withValues(alpha: 0.25),
                                            blurRadius: 8,
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
                                        color: actionsDisabled ? Colors.grey.shade400 : Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        color: actionsDisabled ? Colors.white : AppColors.onlineGreen,
                                        size: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Accept',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: actionsDisabled ? Colors.grey.shade600 : Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ── Simulation Controls (for user testing) ─────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: AppColors.primaryNavy.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primaryNavy.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Simulation Center',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryNavy,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: actionsDisabled ? null : _simulateOtherDriverAccept,
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: actionsDisabled ? Colors.grey : AppColors.offlineRed,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: Text(
                                  'Another Driver Accepts',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: actionsDisabled ? Colors.grey : AppColors.offlineRed,
                                  ),
                                ),
                              ),
                            ),
                            if (actionsDisabled) ...[
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _isAcceptedByOther = false;
                                      _isAcceptedByMe = false;
                                      _secondsRemaining = 15;
                                    });
                                    _startCountdown();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryNavy,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  child: const Text(
                                    'Reset Ride',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ]
                          ],
                        ),
                      ],
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

  Widget _buildRouteStep({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryNavy,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}