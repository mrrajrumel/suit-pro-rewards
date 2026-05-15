import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:suit_pro_rewards_flutter/providers/auth_provider.dart';
import 'package:suit_pro_rewards_flutter/themes/app_theme.dart';
import 'package:suit_pro_rewards_flutter/widgets/logo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:suit_pro_rewards_flutter/services/referral_service.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _step = 1;
  bool _isSubmitting = false;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _referralController = TextEditingController();
  String _suitSize = '40R';
  String _shirtSize = '15.5';
  String _trouserSize = '32';

  @override
  void initState() {
    super.initState();
    _initOnboarding();
  }

  Future<void> _initOnboarding() async {
    final user = ref.read(authStateChangesProvider).asData?.value;
    if (user != null) {
      _nameController.text = user.displayName ?? '';
    }

    // Check for captured Play Store referral
    final String? pendingRef = await ReferralService.getPendingReferral();
    if (pendingRef != null && mounted) {
      _referralController.text = pendingRef;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _referralController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final user = ref.read(authStateChangesProvider).asData?.value;
    if (user == null || _isSubmitting) return;

    setState(() => _isSubmitting = true);

    try {
      final String referralCode = _nameController.text.split(' ')[0].toUpperCase() + user.uid.substring(0, 4).toUpperCase();
      final String inputReferral = _referralController.text.trim().toUpperCase();

      final batch = FirebaseFirestore.instance.batch();
      
      String? referredByUid;
      bool hasValidReferral = false;

      // 1. Verify Referral Code if provided
      if (inputReferral.isNotEmpty) {
        final refQuery = await FirebaseFirestore.instance
            .collection('members')
            .where('referral_code', isEqualTo: inputReferral)
            .limit(1)
            .get();

        if (refQuery.docs.isNotEmpty) {
          referredByUid = refQuery.docs.first.id;
          hasValidReferral = true;
          
          // Credit the referrer (e.g., 200 points)
          final referrerRef = FirebaseFirestore.instance.collection('members').doc(referredByUid);
          batch.update(referrerRef, {
            'points_balance': FieldValue.increment(200),
          });

          // Log transaction for referrer
          final referrerTxRef = FirebaseFirestore.instance.collection('transactions').doc();
          batch.set(referrerTxRef, {
            'member_id': referredByUid,
            'points': 200,
            'type': 'referral',
            'description': 'Referral Bonus: ${_nameController.text}',
            'created_at': FieldValue.serverTimestamp(),
          });
        }
      }

      // 2. Prepare member data
      final memberData = {
        'full_name': _nameController.text.trim(),
        'email': user.email,
        'phone': _phoneController.text.trim(),
        'tier': 'Silver',
        'points_balance': hasValidReferral ? 150 : 50, // 50 welcome + 100 for being referred
        'total_spent': 0,
        'referral_code': referralCode,
        'referred_by': referredByUid,
        'suit_size': _suitSize,
        'shirt_size': _shirtSize,
        'trouser_size': _trouserSize,
        'role': 'user',
        'created_at': FieldValue.serverTimestamp(),
      };

      final memberRef = FirebaseFirestore.instance.collection('members').doc(user.uid);
      batch.set(memberRef, memberData);

      // 3. Log Welcome Bonus for new user
      final welcomeTxRef = FirebaseFirestore.instance.collection('transactions').doc();
      batch.set(welcomeTxRef, {
        'member_id': user.uid,
        'points': 50,
        'type': 'bonus',
        'description': 'Welcome Bonus',
        'created_at': FieldValue.serverTimestamp(),
      });

      if (hasValidReferral) {
        final referralTxRef = FirebaseFirestore.instance.collection('transactions').doc();
        batch.set(referralTxRef, {
          'member_id': user.uid,
          'points': 100,
          'type': 'referral',
          'description': 'Referred by $inputReferral',
          'created_at': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
      await ReferralService.clearPendingReferral();

      if (!mounted) return;
      context.go('/dashboard');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to complete setup: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // Background Glow
          Positioned(
            top: -50.h,
            right: -50.w,
            child: Container(
              width: 250.w,
              height: 250.h,
              decoration: BoxDecoration(
                color: AppTheme.gold.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(color: Colors.transparent),
              ),
            ).animate().fadeIn(duration: 1000.ms),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(height: 40.h),
                          Center(
                            child: Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: AppTheme.gold.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                                border: Border.all(color: AppTheme.gold.withValues(alpha: 0.2)),
                              ),
                              child: const Logo(size: 48),
                            ),
                          ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
                          SizedBox(height: 48.h),
                          AnimatedSwitcher(
                            duration: 400.ms,
                            switchInCurve: Curves.easeOutCubic,
                            switchOutCurve: Curves.easeInCubic,
                            child: _buildStep(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 1:
        return _buildStep1();
      case 2:
        return _buildStep2();
      case 3:
        return _buildStep3();
      default:
        return const SizedBox();
    }
  }

  Widget _buildStep1() {
    return Column(
      key: const ValueKey(1),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 40.sp),
            children: const [
              TextSpan(text: 'Nearly '),
              TextSpan(
                text: 'Ready.',
                style: TextStyle(color: AppTheme.gold, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Join the club and start earning points on every visit.',
          style: TextStyle(color: AppTheme.mutedForeground, fontSize: 14.sp),
        ),
        SizedBox(height: 40.h),
        _buildTextField(
          controller: _nameController,
          label: 'FULL NAME',
          icon: LucideIcons.user,
        ),
        SizedBox(height: 16.h),
        _buildTextField(
          controller: _phoneController,
          label: 'PHONE NUMBER',
          hint: '+44 ...',
          icon: LucideIcons.phone,
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 16.h),
        _buildTextField(
          controller: _referralController,
          label: 'REFERRAL CODE (OPTIONAL)',
          hint: 'e.g. RUMEA5OB',
          icon: LucideIcons.share2,
        ),
      ],
    ).animate().slideX(begin: 0.1, end: 0).fadeIn();
  }

  Widget _buildStep2() {
    return Column(
      key: const ValueKey(2),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 40.sp),
            children: const [
              TextSpan(text: 'Your '),
              TextSpan(
                text: 'Sizes.',
                style: TextStyle(color: AppTheme.gold, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'Help us make your next visit perfect by saving your measurements.',
          style: TextStyle(color: AppTheme.mutedForeground, fontSize: 14.sp),
        ),
        SizedBox(height: 40.h),
        Row(
          children: [
            Expanded(
              child: _buildDropdown(
                label: 'SUIT SIZE (UK)',
                value: _suitSize,
                items: ['36R', '38R', '40R', '42R', '44R', '46R'],
                onChanged: (v) => setState(() => _suitSize = v!),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildDropdown(
                label: 'SHIRT (COLLAR)',
                value: _shirtSize,
                items: ['15', '15.5', '16', '16.5', '17', '17.5'],
                onChanged: (v) => setState(() => _shirtSize = v!),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        _buildDropdown(
          label: 'TROUSER WAIST',
          value: _trouserSize,
          items: ['30', '32', '34', '36', '38', '40'],
          onChanged: (v) => setState(() => _trouserSize = v!),
        ),
      ],
    ).animate().slideX(begin: 0.1, end: 0).fadeIn();
  }

  Widget _buildStep3() {
    return Column(
      key: const ValueKey(3),
      children: [
        Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
          ),
          child: Icon(LucideIcons.star, color: Colors.green, size: 48.sp),
        ),
        SizedBox(height: 24.h),
        Text.rich(
          TextSpan(
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 40.sp),
            children: const [
              TextSpan(text: 'All '),
              TextSpan(
                text: 'Set!',
                style: TextStyle(color: AppTheme.gold, fontStyle: FontStyle.italic),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          'Welcome to the club. Your member account is ready to use.',
          style: TextStyle(color: AppTheme.mutedForeground, fontSize: 14.sp),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 40.h),
        Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(32.r),
            border: Border.all(color: AppTheme.gold.withValues(alpha: 0.15)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'WELCOME REWARD',
                style: TextStyle(color: AppTheme.mutedForeground, fontSize: 10.sp, fontWeight: FontWeight.w900, letterSpacing: 2),
              ),
              Text(
                '+50 Points',
                style: TextStyle(color: Colors.green, fontSize: 14.sp, fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
      ],
    ).animate().slideX(begin: 0.1, end: 0).fadeIn();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: AppTheme.gold.withValues(alpha: 0.6), fontSize: 10.sp, fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(color: Colors.white, fontSize: 14.sp),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppTheme.gold.withValues(alpha: 0.4), size: 18.sp),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: AppTheme.gold.withValues(alpha: 0.6), fontSize: 10.sp, fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: AppTheme.secondary,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppTheme.gold.withValues(alpha: 0.1)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: AppTheme.card,
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
              items: items.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            boxShadow: AppTheme.buttonShadow,
          ),
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : () => _step < 3 ? setState(() => _step++) : _submit(),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (_isSubmitting ? 'STARTING...' : (_step == 3 ? 'START EARNING POINTS' : 'CONTINUE')).toUpperCase(),
                  style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.w900, fontSize: 12.sp),
                ),
                if (!_isSubmitting) ...[
                  SizedBox(width: 8.w),
                  Icon(LucideIcons.arrowRight, size: 16.sp),
                ],
              ],
            ),
          ),
        ),
        if (_step > 1) ...[
          SizedBox(height: 12.h),
          TextButton(
            onPressed: _isSubmitting ? null : () => setState(() => _step--),
            child: Text(
              '← GO BACK',
              style: TextStyle(color: AppTheme.mutedForeground, fontSize: 10.sp, fontWeight: FontWeight.w900, letterSpacing: 2),
            ),
          ),
        ],
      ],
    ).animate().fadeIn(delay: 200.ms);
  }
}
