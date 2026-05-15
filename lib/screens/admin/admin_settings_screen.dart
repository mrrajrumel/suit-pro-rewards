import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:suit_pro_rewards_flutter/themes/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _logoUrlController = TextEditingController();
  final _pointsPerPoundController = TextEditingController();
  final _referralBonusController = TextEditingController();
  final _loginBonusController = TextEditingController();
  final _welcomeBonusController = TextEditingController();
  final _couponThresholdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchSettings();
  }

  Future<void> _fetchSettings() async {
    setState(() => _isLoading = true);
    try {
      final doc = await FirebaseFirestore.instance
          .collection('site_settings')
          .doc('global')
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        _logoUrlController.text = data['logo_url'] ?? '';
        _pointsPerPoundController.text = (data['points_per_pound'] ?? 10).toString();
        _referralBonusController.text = (data['referral_bonus'] ?? 100).toString();
        _loginBonusController.text = (data['login_bonus'] ?? 10).toString();
        _welcomeBonusController.text = (data['welcome_bonus'] ?? 50).toString();
        _couponThresholdController.text = (data['coupon_threshold'] ?? 1000).toString();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading settings: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await FirebaseFirestore.instance
          .collection('site_settings')
          .doc('global')
          .set({
        'logo_url': _logoUrlController.text.trim(),
        'points_per_pound': int.tryParse(_pointsPerPoundController.text) ?? 10,
        'referral_bonus': int.tryParse(_referralBonusController.text) ?? 100,
        'login_bonus': int.tryParse(_loginBonusController.text) ?? 10,
        'welcome_bonus': int.tryParse(_welcomeBonusController.text) ?? 50,
        'coupon_threshold': int.tryParse(_couponThresholdController.text) ?? 1000,
        'updated_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Global settings updated successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save settings: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Global Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading && _logoUrlController.text.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppTheme.gold))
          : SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Branding'),
                    _buildTextField(
                      controller: _logoUrlController,
                      label: 'Network Logo URL',
                      hint: 'https://example.com/logo.png',
                      icon: LucideIcons.image,
                    ),
                    SizedBox(height: 32.h),
                    _buildSectionTitle('Reward Configuration'),
                    _buildTextField(
                      controller: _pointsPerPoundController,
                      label: 'Points per £1 spent',
                      icon: LucideIcons.poundSterling,
                      keyboardType: TextInputType.number,
                    ),
                    _buildTextField(
                      controller: _referralBonusController,
                      label: 'Referral Bonus (Points)',
                      icon: LucideIcons.userPlus,
                      keyboardType: TextInputType.number,
                    ),
                    _buildTextField(
                      controller: _loginBonusController,
                      label: 'Daily Login Bonus (Points)',
                      icon: LucideIcons.logIn,
                      keyboardType: TextInputType.number,
                    ),
                    _buildTextField(
                      controller: _welcomeBonusController,
                      label: 'Welcome Bonus (Points)',
                      icon: LucideIcons.gift,
                      keyboardType: TextInputType.number,
                    ),
                    _buildTextField(
                      controller: _couponThresholdController,
                      label: 'Points required for Auto-Coupon',
                      icon: LucideIcons.ticket,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 48.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveSettings,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 18.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                height: 20.h,
                                width: 20.h,
                                child: const CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                              )
                            : const Text('SAVE GLOBAL SETTINGS'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: AppTheme.gold,
          fontSize: 12.sp,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.white70, fontSize: 11.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon, color: AppTheme.gold.withValues(alpha: 0.5), size: 18.sp),
            ),
          ),
        ],
      ),
    );
  }
}
