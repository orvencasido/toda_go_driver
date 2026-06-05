import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toda_go_driver/core/constants/app_colors.dart';
import 'package:toda_go_driver/features/dashboard/providers/profile_provider.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState
    extends State<PersonalInformationScreen> {
  // ── Editable controllers ──────────────────────────────────────────────────
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _addressCtrl;

  // ── Pending admin approval requests ──────────────────────────────────────
  final List<_PendingRequest> _pendingRequests = [];

  // ── Admin-only request controllers ───────────────────────────────────────
  late final TextEditingController _nameCtrl;
  late final TextEditingController _todaCtrl;
  late final TextEditingController _licenseCtrl;
  late final TextEditingController _vehicleCtrl;

  bool _isSaving = false;
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileProvider>().profile;
    _phoneCtrl = TextEditingController(text: profile.contact);
    _emailCtrl = TextEditingController(text: profile.email);
    _addressCtrl = TextEditingController(text: profile.address);
    _nameCtrl = TextEditingController(text: profile.name);
    _todaCtrl = TextEditingController(text: profile.todaNumber);
    _licenseCtrl = TextEditingController(text: profile.licenseNumber);
    _vehicleCtrl = TextEditingController(text: profile.vehicleDetails);
    _imagePath = profile.imagePath;
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    _nameCtrl.dispose();
    _todaCtrl.dispose();
    _licenseCtrl.dispose();
    _vehicleCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _imagePath = pickedFile.path;
        });
        if (mounted) {
          await context.read<ProfileProvider>().updateProfileImage(pickedFile.path);
        }
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  void _showImageSourceSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.primaryNavy),
              title: const Text('Photo Gallery', style: TextStyle(fontFamily: 'Poppins')),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera, color: AppColors.primaryNavy),
              title: const Text('Camera', style: TextStyle(fontFamily: 'Poppins')),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveEditable() async {
    final contact = _phoneCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final address = _addressCtrl.text.trim();

    if (contact.isEmpty || email.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please fill in all editable fields.',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: AppColors.offlineRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    final success = await context.read<ProfileProvider>().updateProfile(
      contact: contact,
      email: email,
      address: address,
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Profile updated successfully.',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: AppColors.onlineGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      final updatedProfile = context.read<ProfileProvider>().profile;
      setState(() {
        _phoneCtrl.text = updatedProfile.contact;
        _emailCtrl.text = updatedProfile.email;
        _addressCtrl.text = updatedProfile.address;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Failed to update profile. Please verify your inputs.',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: AppColors.offlineRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _submitAdminRequest(String field, String newValue) {
    // Check if there's already a pending request for this field
    final exists = _pendingRequests.any((r) => r.field == field);
    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'A request for $field is already pending.',
            style: const TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    setState(() {
      _pendingRequests.add(_PendingRequest(
        field: field,
        requestedValue: newValue,
        submittedAt: DateTime.now(),
      ));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Your update request has been submitted for admin approval.',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        backgroundColor: AppColors.primaryNavy,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showAdminRequestDialog(String field, TextEditingController ctrl) {
    final tempCtrl = TextEditingController(text: ctrl.text);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Request Change: $field',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: AppColors.primaryNavy,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This change requires admin approval. Enter the new value and submit your request.',
              style: TextStyle(
                  fontFamily: 'Poppins', fontSize: 12, color: AppColors.textLight),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: tempCtrl,
              decoration: InputDecoration(
                labelText: field,
                labelStyle: const TextStyle(fontFamily: 'Poppins'),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.primaryNavy, width: 2)),
              ),
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(fontFamily: 'Poppins', color: AppColors.textLight)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryNavy,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              final val = tempCtrl.text.trim();
              Navigator.pop(ctx);
              if (val.isNotEmpty) _submitAdminRequest(field, val);
            },
            child: const Text('Submit Request',
                style: TextStyle(fontFamily: 'Poppins')),
          ),
        ],
      ),
    );
  }

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
                    'Personal Information',
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
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Profile photo card
                  _profileCard(),

                  const SizedBox(height: 20),

                  // ── Section A: Editable Information ──────────────────────
                  _SectionHeader(
                    icon: Icons.edit_outlined,
                    label: 'A. Editable Information',
                    color: const Color(0xFF4CAF50),
                    subtitle: 'You can update these fields anytime.',
                  ),
                  const SizedBox(height: 10),
                  _card(
                    children: [
                      _EditableField(
                        label: 'Phone Number',
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        icon: Icons.phone_outlined,
                      ),
                      const SizedBox(height: 14),
                      _EditableField(
                        label: 'Email Address',
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        icon: Icons.email_outlined,
                      ),
                      const SizedBox(height: 14),
                      _EditableField(
                        label: 'Address',
                        controller: _addressCtrl,
                        icon: Icons.home_outlined,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── Section B: View-Only Information ─────────────────────
                  _SectionHeader(
                    icon: Icons.lock_outline,
                    label: 'B. Admin-Managed Information',
                    color: const Color(0xFF2196F3),
                    subtitle:
                        'These fields are managed by the admin. Tap to request a change.',
                  ),
                  const SizedBox(height: 10),
                  _card(
                    children: [
                      _AdminField(
                        label: 'Full Name',
                        controller: _nameCtrl,
                        icon: Icons.person_outline,
                        onRequest: () => _showAdminRequestDialog('Full Name', _nameCtrl),
                      ),
                      const SizedBox(height: 14),
                      _AdminField(
                        label: 'TODA Number / TODA ID',
                        controller: _todaCtrl,
                        icon: Icons.badge_outlined,
                        onRequest: () => _showAdminRequestDialog('TODA Number', _todaCtrl),
                      ),
                      const SizedBox(height: 14),
                      _AdminField(
                        label: 'License Number',
                        controller: _licenseCtrl,
                        icon: Icons.credit_card_outlined,
                        onRequest: () =>
                            _showAdminRequestDialog('License Number', _licenseCtrl),
                      ),
                      const SizedBox(height: 14),
                      _AdminField(
                        label: 'Vehicle / Tricycle Details',
                        controller: _vehicleCtrl,
                        icon: Icons.electric_rickshaw_outlined,
                        onRequest: () => _showAdminRequestDialog(
                            'Vehicle / Tricycle Details', _vehicleCtrl),
                      ),
                      const SizedBox(height: 14),
                      _ReadOnlyField(
                        label: 'Driver Verification Status',
                        value: 'Verified',
                        icon: Icons.verified_outlined,
                        valueColor: AppColors.onlineGreen,
                      ),
                      const SizedBox(height: 14),
                      _ReadOnlyField(
                        label: 'Account Status',
                        value: 'Active',
                        icon: Icons.check_circle_outline,
                        valueColor: AppColors.onlineGreen,
                      ),
                    ],
                  ),

                  // ── Section C: Pending Admin Approval ────────────────────
                  if (_pendingRequests.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _SectionHeader(
                      icon: Icons.hourglass_top_outlined,
                      label: 'C. Pending Admin Approval',
                      color: const Color(0xFFFF9800),
                      subtitle:
                          'These requests are waiting for admin review.',
                    ),
                    const SizedBox(height: 10),
                    _card(
                      children: _pendingRequests
                          .map((r) => _PendingTile(request: r))
                          .toList(),
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Info notice
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primaryNavy.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: AppColors.primaryNavy.withValues(alpha: 0.12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.info_outline,
                            color:
                                AppColors.primaryNavy.withValues(alpha: 0.7),
                            size: 18),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'Some fields require admin approval. Changes will reflect once the admin reviews and approves your request.',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: AppColors.textDark,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // ── Save Changes Button (Full-width, fixed at bottom) ─────────────
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              MediaQuery.of(context).padding.bottom + 12,
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryNavy,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
                onPressed: _isSaving ? null : _saveEditable,
                child: _isSaving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5))
                    : const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 0.5,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.profileCardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryNavy, width: 2.5),
                ),
                child: ClipOval(
                  child: _imagePath != null
                      ? Image.file(
                          File(_imagePath!),
                          width: 76,
                          height: 76,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.person,
                          size: 50, color: AppColors.primaryNavy),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _showImageSourceSelector,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryNavy,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(
                            color: AppColors.primaryNavy.withValues(alpha: 0.15),
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Calling passenger...'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.call, size: 16, color: AppColors.primaryNavy),
                            SizedBox(width: 8),
                            Text(
                              "Call Passenger",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryNavy,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Joross A. Buera',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryNavy,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: const [
                  Icon(Icons.verified, size: 15, color: AppColors.onlineGreen),
                  SizedBox(width: 4),
                  Text(
                    'Verified Driver',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onlineGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              const Text(
                'Tap camera icon to update photo',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _card({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
    );
  }
}

// ── Section Header ────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final String subtitle;

  const _SectionHeader({
    required this.icon,
    required this.label,
    required this.color,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Editable Field ────────────────────────────────────────────────────────────
class _EditableField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final IconData icon;

  const _EditableField({
    required this.label,
    required this.controller,
    required this.icon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textLight,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textDark,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primaryNavy, size: 18),
            filled: true,
            fillColor: AppColors.lightBlueBackground,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: AppColors.primaryNavy.withValues(alpha: 0.15)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.primaryNavy, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Admin Field (view with request button) ────────────────────────────────────
class _AdminField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final VoidCallback onRequest;

  const _AdminField({
    required this.label,
    required this.controller,
    required this.icon,
    required this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textLight,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: AppColors.greyBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.textLight, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  controller.text,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onRequest,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primaryNavy.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Request',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryNavy,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Read-Only Field (no request button) ──────────────────────────────────────
class _ReadOnlyField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const _ReadOnlyField({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = valueColor ?? AppColors.textDark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textLight,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: AppColors.greyBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 10),
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'View Only',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.black45,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Pending Request Model ─────────────────────────────────────────────────────
class _PendingRequest {
  final String field;
  final String requestedValue;
  final DateTime submittedAt;

  const _PendingRequest({
    required this.field,
    required this.requestedValue,
    required this.submittedAt,
  });
}

// ── Pending Tile ──────────────────────────────────────────────────────────────
class _PendingTile extends StatelessWidget {
  final _PendingRequest request;

  const _PendingTile({required this.request});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFFCC02).withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            const Icon(Icons.hourglass_top_outlined,
                color: Color(0xFFFF9800), size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.field,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    'Requested: ${request.requestedValue}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFF9800).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Pending',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFF9800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
