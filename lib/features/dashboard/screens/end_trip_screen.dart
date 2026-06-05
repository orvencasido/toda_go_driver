import 'package:flutter/material.dart';
import 'package:toda_go_driver/core/constants/app_colors.dart';

class EndTripScreen extends StatelessWidget {
  final String pickup;
  final String dropoff;
  final String distance;
  final String fare;

  const EndTripScreen({
    super.key,
    required this.pickup,
    required this.dropoff,
    required this.distance,
    required this.fare,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 1),

              // Success Icon
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: AppColors.onlineGreen,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_circle_outline_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Title
              const Center(
                child: Text(
                  'Trip Completed',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryNavy,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              const Center(
                child: Text(
                  'Thank you for completing this trip safely!',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryNavy,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Summary Card
              Container(
                padding: const EdgeInsets.all(24.0),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Trip Summary',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryNavy,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Pickup
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on, color: AppColors.onlineGreen, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Pickup Location',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textLight,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                pickup,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryNavy,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 9.0),
                      child: SizedBox(
                        height: 24,
                        child: VerticalDivider(
                          color: AppColors.primaryNavy,
                          thickness: 1.5,
                        ),
                      ),
                    ),

                    // Drop-off
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on, color: AppColors.offlineRed, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Drop-off Location',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textLight,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                dropoff,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryNavy,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 12),

                    // Metrics Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Distance',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textLight,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              distance,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryNavy,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Total Fare',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textLight,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              fare,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: AppColors.onlineGreen,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // Confirm End Trip Button (Green, Full-width)
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Returns directly to Dashboard (first screen in stack)
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.onlineGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    'Confirm End Trip',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
