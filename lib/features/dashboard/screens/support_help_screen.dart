import 'package:flutter/material.dart';
import 'package:toda_go_driver/core/constants/app_colors.dart';

class SupportHelpScreen extends StatelessWidget {
  const SupportHelpScreen({super.key});

  static const _faqs = [
    _FaqData(
      question: 'How do I report a trip issue?',
      answer:
          'Go to the Trips page, select the trip with an issue, then tap Report Issue. Provide a short description so the support team can review it.',
    ),
    _FaqData(
      question: 'How do I update my driver profile?',
      answer:
          'Go to Account, open Personal Information, then update the editable fields. Some information may require admin approval before changes appear.',
    ),
    _FaqData(
      question: 'How do I check my earnings?',
      answer:
          'Go to Account, then open Earnings Reports. You can filter your earnings by today, this week, this month, or custom date range.',
    ),
    _FaqData(
      question: 'Why is my account not verified yet?',
      answer:
          'Your account may still be under review. Please make sure your profile details, license information, and TODA details are complete and correct.',
    ),
    _FaqData(
      question: 'Can I change my TODA number?',
      answer:
          'TODA number changes must be approved by the admin. Submit a request through your profile or contact support.',
    ),
    _FaqData(
      question: 'What should I do if I cannot log in?',
      answer:
          'Check your email or phone number and password. If the problem continues, use Change Password or contact support.',
    ),
    _FaqData(
      question: 'How are fares calculated?',
      answer:
          'Fares are based on the fixed fare set by the system or admin. Drivers cannot directly edit fare settings.',
    ),
    _FaqData(
      question: 'How do I contact support?',
      answer:
          'Use the Contact Support button below or send a message to the listed phone number or email address.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueBackground,
      body: Column(
        children: [
          // ── Header ────────────────────────────────────────────────────────
          Container(
            width: double.infinity,
            color: AppColors.primaryNavy,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              bottom: 16,
              left: 8,
              right: 16,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.white, size: 24),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Text(
                    'Support & Help',
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

          // ── Content ───────────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // How can we help? card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primaryNavy,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.headset_mic_outlined,
                              color: Colors.white, size: 30),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'How can we help you?',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Find answers to common driver questions or contact support.',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: Colors.white70,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Contact info card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _ContactRow(
                          icon: Icons.phone_outlined,
                          iconColor: const Color(0xFF4CAF50),
                          label: '0912 345 6789',
                          sublabel: 'Call Us',
                        ),
                        const Divider(height: 24),
                        _ContactRow(
                          icon: Icons.email_outlined,
                          iconColor: const Color(0xFF2196F3),
                          label: 'support@todago.com',
                          sublabel: 'Email Us',
                        ),
                        const Divider(height: 24),
                        _ContactRow(
                          icon: Icons.schedule_outlined,
                          iconColor: const Color(0xFF9C27B0),
                          label: 'Mon – Sat, 8:00 AM – 6:00 PM',
                          sublabel: 'Support Hours',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // FAQ heading
                  const Text(
                    'Frequently Asked Questions',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryNavy,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // FAQ items
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: _faqs.asMap().entries.map((e) {
                        final isLast = e.key == _faqs.length - 1;
                        return Column(
                          children: [
                            _FaqTile(data: e.value),
                            if (!isLast)
                              Divider(
                                  height: 1,
                                  thickness: 1,
                                  indent: 16,
                                  endIndent: 16,
                                  color: Colors.grey.shade100),
                          ],
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Contact Support button
                  SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryNavy,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.headset_mic_outlined, size: 20),
                      label: const Text(
                        'Contact Support',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Support request sent. Our team will contact you soon.',
                              style: TextStyle(fontFamily: 'Poppins'),
                            ),
                            backgroundColor: AppColors.primaryNavy,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      },
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

// ── Contact Row ───────────────────────────────────────────────────────────────
class _ContactRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String sublabel;

  const _ContactRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.sublabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            Text(
              sublabel,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── FAQ Data ──────────────────────────────────────────────────────────────────
class _FaqData {
  final String question;
  final String answer;
  const _FaqData({required this.question, required this.answer});
}

// ── FAQ Tile ──────────────────────────────────────────────────────────────────
class _FaqTile extends StatefulWidget {
  final _FaqData data;
  const _FaqTile({required this.data});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding:
            const EdgeInsets.only(left: 16, right: 16, bottom: 14),
        title: Text(
          widget.data.question,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _expanded ? AppColors.primaryNavy : AppColors.textDark,
          ),
        ),
        trailing: Icon(
          _expanded ? Icons.expand_less : Icons.expand_more,
          color: AppColors.primaryNavy,
        ),
        onExpansionChanged: (v) => setState(() => _expanded = v),
        children: [
          Text(
            widget.data.answer,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: AppColors.textLight,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
