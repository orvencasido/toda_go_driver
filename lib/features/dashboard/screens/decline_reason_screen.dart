import 'package:flutter/material.dart';
import 'package:toda_go_driver/core/constants/app_colors.dart';

class DeclineReasonScreen extends StatefulWidget {
  const DeclineReasonScreen({super.key});

  @override
  State<DeclineReasonScreen> createState() => _DeclineReasonScreenState();
}

class _DeclineReasonScreenState extends State<DeclineReasonScreen> {
  String? _selectedReason;
  final _otherReasonController = TextEditingController();

  final List<String> _reasons = [
    "Too far",
    "Heavy Traffic",
    "Change of plans",
    "Vehicle issue",
    "Other",
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
      const SnackBar(
        content: Text(
          "Ride declined",
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.offlineRed,
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Widget _buildReasonRow(String reason) {
    final bool isSelected = _selectedReason == reason;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedReason = reason;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
        child: Row(
          children: [
            // Custom Radio Button Indicator
            Container(
              width: 22,
              height: 22,
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
            Text(
              reason,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryNavy,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueBackground,
      body: Column(
        children: [
          // ── Navy Header with Back Arrow and Title ────────────────────────
          Container(
            width: double.infinity,
            height: 100,
            color: AppColors.primaryNavy,
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                const Text(
                  "Decline Reason",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Subtitle Prompt
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        "Please select a reason",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryNavy,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ── Options Rounded White Card ───────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
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
                              left: 16.0,
                              right: 16.0,
                              bottom: 16.0,
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
                                hintStyle: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14.0,
                                  color: AppColors.primaryNavy.withValues(alpha: 0.5),
                                ),
                                filled: true,
                                fillColor: AppColors.greyBg,
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
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _handleConfirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryNavy,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26.0),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        "Confirm",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
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
