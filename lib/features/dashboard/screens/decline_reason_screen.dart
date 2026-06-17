import 'package:flutter/material.dart';
import 'package:toda_go_driver/core/constants/app_colors.dart';

// ── Decline Mode Enum ────────────────────────────────────────────────────────
enum DeclineMode { decline, timeout, cancel }

class DeclineReasonScreen extends StatefulWidget {
  final DeclineMode mode;

  const DeclineReasonScreen({super.key, this.mode = DeclineMode.decline});

  @override
  State<DeclineReasonScreen> createState() => _DeclineReasonScreenState();
}

class _DeclineReasonScreenState extends State<DeclineReasonScreen> {
  String? _selectedReason;
  final _otherReasonController = TextEditingController();

  final List<Map<String, dynamic>> _reasons = [
    {"title": "Too far", "icon": Icons.location_on_rounded},
    {"title": "Heavy Traffic", "icon": Icons.directions_car_rounded},
    {"title": "Change of plans", "icon": Icons.calendar_today_rounded},
    {"title": "Vehicle issue", "icon": Icons.build_rounded},
    {"title": "Other", "icon": Icons.more_horiz_rounded},
  ];

  @override
  void dispose() {
    _otherReasonController.dispose();
    super.dispose();
  }

  void _handleConfirm() {
    if (_selectedReason == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select a reason",
            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppColors.offlineRed,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (_selectedReason == "Other" && _otherReasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter your reason",
            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppColors.offlineRed,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Process ride decline
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.mode == DeclineMode.cancel ? "Trip cancelled" : "Ride declined",
          style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.offlineRed,
        duration: const Duration(seconds: 2),
      ),
    );
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Widget _buildReasonRow(Map<String, dynamic> reasonData) {
    final String reason = reasonData["title"];
    final IconData icon = reasonData["icon"];
    final bool isSelected = _selectedReason == reason;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedReason = reason;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        child: Row(
          children: [
            // Custom Radio Button Indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primaryNavy,
                  width: 2,
                ),
              ),
              padding: const EdgeInsets.all(3.0),
              child: isSelected
                  ? Container(
                      decoration: const BoxDecoration(
                        color: AppColors.primaryNavy,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            // Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.primaryNavy,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            // Text
            Expanded(
              child: Text(
                reason,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryNavy,
                ),
              ),
            ),
            // Right Arrow
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFCBD5E1),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── Navy Header with Back Arrow ────────────────────────────────────
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
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Exclamation Icon
                  Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.error_outline_rounded,
                        color: AppColors.primaryNavy,
                        size: 32,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  const Center(
                    child: Text(
                      "Please select a reason",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryNavy,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  const Center(
                    child: Text(
                      "This helps us improve your experience.",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14.0,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── Options Rounded White Card ───────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ...List.generate(_reasons.length * 2 - 1, (index) {
                          if (index.isOdd) {
                            return const Divider(
                              height: 1,
                              thickness: 1,
                              color: Color(0xFFF1F5F9),
                            );
                          }
                          final reasonIndex = index ~/ 2;
                          return _buildReasonRow(_reasons[reasonIndex]);
                        }),

                        // Dynamic text field for "Other" reason
                        if (_selectedReason == "Other") ...[
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                              bottom: 20.0,
                              top: 4.0,
                            ),
                            child: TextField(
                              controller: _otherReasonController,
                              maxLines: 2,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14.0,
                                color: AppColors.primaryNavy,
                              ),
                              decoration: InputDecoration(
                                hintText: "Enter your reason...",
                                hintStyle: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14.0,
                                  color: Color(0xFF94A3B8),
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF8FAFC),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 12.0,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: const BorderSide(
                                    color: AppColors.primaryNavy,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 48),

                  // ── Confirm Navy Button ───────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _handleConfirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryNavy,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Confirm",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
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
}
