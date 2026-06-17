import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:toda_go_driver/core/constants/app_colors.dart';
import 'package:toda_go_driver/features/dashboard/screens/end_trip_screen.dart';
import 'package:toda_go_driver/widgets/open_street_map_widget.dart';

class NavigatingToDropoffScreen extends StatefulWidget {
  final String pickup;
  final String dropoff;
  final String distance;
  final String fare;

  const NavigatingToDropoffScreen({
    super.key,
    required this.pickup,
    required this.dropoff,
    required this.distance,
    required this.fare,
  });

  @override
  State<NavigatingToDropoffScreen> createState() => _NavigatingToDropoffScreenState();
}

class _NavigatingToDropoffScreenState extends State<NavigatingToDropoffScreen> with TickerProviderStateMixin {
  late final MapController mapController;
  final ll.LatLng _pickupLocation = const ll.LatLng(14.0256, 121.5831); // 123 Main St., Arnings
  final ll.LatLng _dropoffLocation = const ll.LatLng(14.0290, 121.5900); // Rizal Boulevard
  late final List<ll.LatLng> polylinePoints;

  @override
  void initState() {
    super.initState();
    mapController = MapController();

    // Setup polyline path mimicking street navigation route
    polylinePoints = [
      _pickupLocation,
      const ll.LatLng(14.0262, 121.5852),
      const ll.LatLng(14.0270, 121.5870),
      const ll.LatLng(14.0280, 121.5885),
      _dropoffLocation,
    ];
  }

  void _animatedMapMove(ll.LatLng destCenter, double destZoom) {
    final latTween = Tween<double>(begin: mapController.camera.center.latitude, end: destCenter.latitude);
    final lngTween = Tween<double>(begin: mapController.camera.center.longitude, end: destCenter.longitude);
    final zoomTween = Tween<double>(begin: mapController.camera.zoom, end: destZoom);

    final controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    final animation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
        ll.LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── Header Block (No back button) ───────────────────────────────
          Container(
            width: double.infinity,
            color: AppColors.primaryNavy,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              bottom: 16,
              left: 4,
              right: 16,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Text(
                    'Navigating to Drop-off',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 48), // Spacer to balance back button
              ],
            ),
          ),

          // ── Map / Live GoogleMap Section with overlays ───────────────────
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                OpenStreetMapWidget(
                  mapController: mapController,
                  pickupLocation: _pickupLocation,
                  dropoffLocation: _dropoffLocation,
                  routePoints: polylinePoints,
                  showRoute: true,
                  initialCenter: _pickupLocation,
                  initialZoom: 15.0,
                ),

                // 1. Pickup Address card overlay
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on, color: AppColors.primaryNavy, size: 24),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.pickup.split(',').first,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryNavy,
                              ),
                            ),
                            const Text(
                              'Tayabas City, Quezon',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 11,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // 2. Route duration badge overlay (8 min)
                Positioned(
                  top: 170,
                  left: 170,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Text(
                      '8 min',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // 3. My Location locator button overlay
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: () {
                      _animatedMapMove(_pickupLocation, 15.0);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.my_location_rounded,
                        color: AppColors.primaryNavy,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Bottom Panel card and action button ──────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Column(
              children: [
                // Distance and ETA cards row
                Row(
                  children: [
                    Expanded(
                      child: _RouteInfoCard(
                        icon: Icons.location_on_rounded,
                        label: 'Distance',
                        value: widget.distance,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _RouteInfoCard(
                        icon: Icons.access_time_rounded,
                        label: 'Estimated Time',
                        value: '8 mins',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Destination description Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.navigation_rounded, color: Color(0xFF2563EB), size: 32),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Heading to drop-off',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.dropoff,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryNavy,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Tayabas City, Quezon',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Arrived at Drop-off Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EndTripScreen(
                            pickup: widget.pickup,
                            dropoff: widget.dropoff,
                            distance: widget.distance,
                            fare: widget.fare,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryNavy,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 0,
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
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Arrived at Drop-off',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).padding.bottom + 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _RouteInfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFE8F2FF),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primaryNavy, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryNavy,
                  ),
                ),
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
        ],
      ),
    );
  }
}
