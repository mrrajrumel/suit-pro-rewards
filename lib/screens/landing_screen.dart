import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:suit_pro_rewards_flutter/providers/auth_view_model.dart';
import 'package:suit_pro_rewards_flutter/providers/auth_provider.dart';
import 'package:suit_pro_rewards_flutter/themes/app_theme.dart';
import 'package:suit_pro_rewards_flutter/widgets/google_icon.dart';
import 'package:suit_pro_rewards_flutter/widgets/logo.dart';

import 'package:suit_pro_rewards_flutter/widgets/premium_button.dart';
import 'package:suit_pro_rewards_flutter/widgets/glass_container.dart';


enum AuthMode { landing, login, register, forgotPassword, phoneAuth, verifyOtp, adminLogin }


class LandingScreen extends ConsumerStatefulWidget {
  const LandingScreen({super.key});

  @override
  ConsumerState<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends ConsumerState<LandingScreen> {
  AuthMode _mode = AuthMode.landing;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _verificationId;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _verifyPhone() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) return;

    final repo = ref.read(authRepositoryProvider);
    await repo.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (credential) async {
        await repo.signInWithCredential(credential);
      },
      verificationFailed: (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Verification failed')),
        );
      },
      codeSent: (verificationId, resendToken) {
        setState(() {
          _verificationId = verificationId;
          _mode = AuthMode.verifyOtp;
        });
      },
      codeAutoRetrievalTimeout: (verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  void _submitOtp() async {
    final otp = _otpController.text.trim();
    if (otp.isEmpty || _verificationId == null) return;

    final repo = ref.read(authRepositoryProvider);
    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: otp,
    );

    try {
      await repo.signInWithCredential(credential);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid verification code')),
      );
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final notifier = ref.read(authViewModelProvider.notifier);
      if (_mode == AuthMode.login || _mode == AuthMode.adminLogin) {
        notifier.signInWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      } else if (_mode == AuthMode.register) {
        notifier.createUserWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          _nameController.text.trim(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Premium Background Glows
          Positioned(
            top: -50.h,
            right: -100.w,
            child: Container(
              width: 320.w,
              height: 320.h,
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
          Positioned(
            bottom: -50.h,
            left: -100.w,
            child: Container(
              width: 320.w,
              height: 320.h,
              decoration: BoxDecoration(
                color: AppTheme.gold.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(color: Colors.transparent),
              ),
            ).animate().fadeIn(duration: 1200.ms),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 1.sh - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom - 48.h,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 24.h),
                        AnimatedSwitcher(
                          duration: 400.ms,
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          child: _buildCurrentView(),
                        ),
                      ],
                    ),
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (_mode) {
      case AuthMode.landing:
        return _buildLandingView();
      case AuthMode.phoneAuth:
        return _buildPhoneAuthView();
      case AuthMode.verifyOtp:
        return _buildVerifyOtpView();
      default:
        return _buildAuthForm();
    }
  }

  Widget _buildLandingView() {
    return Column(
      key: const ValueKey('landing'),
      children: [
        const Logo(size: 64).animate().slideY(begin: -0.2, end: 0, duration: 600.ms, curve: Curves.easeOutBack).fadeIn(),
        SizedBox(height: 48.h),
        Column(
          children: [
            Text(
              'Join the',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: 40.sp,
                height: 1.1,
              ),
            ),
            Text(
              'London Club.',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 40.sp,
                    fontStyle: FontStyle.italic,
                    color: AppTheme.gold,
                    height: 1.1,
                  ),
            ),
          ],
        ).animate().slideY(begin: 0.1, end: 0, duration: 600.ms, curve: Curves.easeOutCubic).fadeIn(),
        SizedBox(height: 16.h),
        Text(
          'Connect with Suit Pro, collect points, and enjoy member rewards.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                height: 1.6,
                color: Colors.white.withValues(alpha: 0.5),
                fontWeight: FontWeight.w600,
              ),
        ).animate().fadeIn(delay: 200.ms),
        SizedBox(height: 48.h),
        _buildFeatureGrid(),
        SizedBox(height: 48.h),
        _buildLandingButtons(),
      ],
    ).animate().scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1), duration: 600.ms, curve: Curves.easeOutCubic).fadeIn();
  }

  Widget _buildFeatureGrid() {
    final features = [
      {'icon': LucideIcons.shoppingCart, 'label': 'Shop'},
      {'icon': LucideIcons.gift, 'label': 'Rewards'},
      {'icon': LucideIcons.trophy, 'label': 'Rank'},
      {'icon': LucideIcons.zap, 'label': 'Bonus'},
    ];

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildFeatureItem(features[0], 0)),
            SizedBox(width: 12.w),
            Expanded(child: _buildFeatureItem(features[1], 1)),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(child: _buildFeatureItem(features[2], 2)),
            SizedBox(width: 12.w),
            Expanded(child: _buildFeatureItem(features[3], 3)),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureItem(Map<String, dynamic> feature, int index) {
    return GlassContainer(
      borderRadius: 24,
      opacity: 0.05,
      blur: 10,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(feature['icon'] as IconData, color: AppTheme.gold, size: 20.sp),
          SizedBox(height: 8.h),
          Text(
            (feature['label'] as String).toUpperCase(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 9.sp,
                  color: Colors.white.withValues(alpha: 0.4),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
          ),
        ],
      ),
    ).animate().scale(delay: (index * 100).ms, duration: 400.ms, curve: Curves.easeOutBack);
  }


  Widget _buildLandingButtons() {
    return Column(
      children: [
        PremiumButton(
          label: 'CONNECT WITH GOOGLE',
          onPressed: () {
            // TODO: Google Sign In
          },
          iconWidget: const GoogleIcon(size: 20),
          color: Colors.white,
          textColor: Colors.black,
        ),


        SizedBox(height: 16.h),
        SizedBox(
          width: double.infinity,
          child: GlassContainer(
            borderRadius: 16,
            opacity: 0.04,
            blur: 10,
            padding: EdgeInsets.zero,
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            child: InkWell(
              onTap: () {
                FocusScope.of(context).unfocus();
                Future.delayed(const Duration(milliseconds: 50), () {
                  if (mounted) setState(() => _mode = AuthMode.phoneAuth);
                });
              },
              borderRadius: BorderRadius.circular(16.r),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.phone, size: 14.sp, color: AppTheme.gold),
                    SizedBox(width: 8.w),
                    Text(
                      'SIGN IN WITH PHONE',
                      style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.white.withValues(alpha: 0.8)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: GlassContainer(
                borderRadius: 16,
                opacity: 0.1,
                blur: 10,
                padding: EdgeInsets.zero,
                color: AppTheme.gold.withValues(alpha: 0.08),
                border: Border.all(color: AppTheme.gold.withValues(alpha: 0.15)),
                child: InkWell(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    Future.delayed(const Duration(milliseconds: 50), () {
                      if (mounted) setState(() => _mode = AuthMode.login);
                    });
                  },
                  borderRadius: BorderRadius.circular(16.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 18.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.logIn, size: 12.sp, color: AppTheme.gold),
                        SizedBox(width: 8.w),
                        Text(
                          'LOG IN',
                          style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w900, letterSpacing: 1, color: AppTheme.gold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: GlassContainer(
                borderRadius: 16,
                opacity: 0.04,
                blur: 10,
                padding: EdgeInsets.zero,
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                child: InkWell(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    Future.delayed(const Duration(milliseconds: 50), () {
                      if (mounted) setState(() => _mode = AuthMode.register);
                    });
                  },
                  borderRadius: BorderRadius.circular(16.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 18.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.userPlus, size: 12.sp, color: Colors.white.withValues(alpha: 0.8)),
                        SizedBox(width: 8.w),
                        Text(
                          'SIGN UP',
                          style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w900, letterSpacing: 1, color: Colors.white.withValues(alpha: 0.8)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: () {
              FocusScope.of(context).unfocus();
              Future.delayed(const Duration(milliseconds: 50), () {
                if (mounted) setState(() => _mode = AuthMode.adminLogin);
              });
            },
            icon: Icon(LucideIcons.lock, size: 10.sp),
            label: Text(
              'STAFF ACCESS',
              style: TextStyle(fontSize: 8.sp, fontWeight: FontWeight.w900, letterSpacing: 3),
            ),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white.withValues(alpha: 0.2),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic);
  }


  Widget _buildPhoneAuthView() {
    return Column(
      key: const ValueKey('phone-auth'),
      children: [
        _buildAuthHeader('Enter your phone number'),
        SizedBox(height: 48.h),
        _buildTextField(
          controller: _phoneController,
          label: 'PHONE NUMBER',
          hint: '+44 7000 000000',
          icon: LucideIcons.phone,
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 8.h),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Include country code (e.g. +44 or +1)',
            style: TextStyle(fontSize: 8.sp, color: Colors.white.withValues(alpha: 0.2)),
          ),
        ),
        SizedBox(height: 32.h),
        PremiumButton(
          label: 'SEND CODE',
          onPressed: _verifyPhone,
          isLoading: false, // Manage this state if needed
        ),

      ],
    ).animate().fadeIn().slideX(begin: 0.1, end: 0);
  }

  Widget _buildVerifyOtpView() {
    return Column(
      key: const ValueKey('verify-otp'),
      children: [
        _buildAuthHeader('Check your messages'),
        SizedBox(height: 48.h),
        _buildTextField(
          controller: _otpController,
          label: 'VERIFICATION CODE',
          hint: '000000',
          icon: LucideIcons.shieldCheck,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 32.h),
        PremiumButton(
          label: 'VERIFY & CONTINUE',
          onPressed: _submitOtp,
        ),

        SizedBox(height: 16.h),
        TextButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            setState(() => _mode = AuthMode.phoneAuth);
          },
          child: Text(
            'CHANGE NUMBER',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10.sp),
          ),
        ),
      ],
    ).animate().fadeIn().slideX(begin: 0.1, end: 0);
  }

  Widget _buildAuthHeader(String subtitle) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                Future.delayed(const Duration(milliseconds: 50), () {
                  if (mounted) setState(() => _mode = AuthMode.landing);
                });
              },
              icon: const Icon(LucideIcons.chevronLeft),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.05),
              ),
            ),
            Text(
              (_mode == AuthMode.login ? 'Welcome Back' : _mode == AuthMode.register ? 'Join the Club' : _mode == AuthMode.adminLogin ? 'Staff Login' : 'Reset Password').toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppTheme.gold,
                    letterSpacing: 3,
                  ),
            ),
            const SizedBox(width: 48),
          ],
        ),
        SizedBox(height: 40.h),
        Text(
          (_mode == AuthMode.login ? 'Sign In' : _mode == AuthMode.register ? 'Register' : _mode == AuthMode.adminLogin ? 'Admin Login' : 'Reset Password'),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(height: 8.h),
        Text(
          subtitle.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontSize: 8.sp,
              ),
        ),
      ],
    );
  }

  Widget _buildAuthForm() {
    final isLoading = ref.watch(authViewModelProvider).isLoading;

    return Form(
      key: _formKey,
      child: Column(
        key: const ValueKey('auth-form'),
        children: [
          _buildAuthHeader('Please enter your details below'),
          SizedBox(height: 48.h),
          if (_mode == AuthMode.register) ...[
            _buildTextField(
              controller: _nameController,
              label: 'FULL NAME',
              hint: 'John Doe',
              icon: LucideIcons.userCircle2,
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            SizedBox(height: 16.h),
          ],
          if (_mode != AuthMode.adminLogin) ...[
            PremiumButton(
              label: 'CONNECT WITH GOOGLE',
              onPressed: () {
                // TODO: Google Sign In
              },
              iconWidget: const GoogleIcon(size: 16),
              color: Colors.white,
              textColor: Colors.black,
            ),

            SizedBox(height: 16.h),
            Row(
              children: [
                const Expanded(child: Divider(color: Colors.white10)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    'OR USE EMAIL',
                    style: TextStyle(fontSize: 8.sp, color: Colors.white.withValues(alpha: 0.2), fontWeight: FontWeight.w900, letterSpacing: 2),
                  ),
                ),
                const Expanded(child: Divider(color: Colors.white10)),
              ],
            ),
            SizedBox(height: 16.h),
          ],
          _buildTextField(
            controller: _emailController,
            label: 'EMAIL ADDRESS',
            hint: 'email@address.com',
            icon: LucideIcons.mail,
            keyboardType: TextInputType.emailAddress,
            validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
          ),
          if (_mode != AuthMode.forgotPassword) ...[
            SizedBox(height: 16.h),
            _buildTextField(
              controller: _passwordController,
              label: 'PASSWORD',
              hint: '••••••••',
              icon: LucideIcons.key,
              obscureText: true,
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              trailing: (_mode == AuthMode.login || _mode == AuthMode.adminLogin)
                  ? GestureDetector(
                      onTap: () {
                      FocusScope.of(context).unfocus();
                      Future.delayed(const Duration(milliseconds: 50), () {
                        if (mounted) setState(() => _mode = AuthMode.forgotPassword);
                      });
                    },
                    child: Text(
                        'FORGOT?',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontSize: 9.sp,
                            ),
                      ),
                    )
                  : null,
            ),
          ],
          SizedBox(height: 32.h),
          PremiumButton(
            label: _mode == AuthMode.login || _mode == AuthMode.adminLogin ? 'LOGIN' : _mode == AuthMode.register ? 'JOIN NOW' : 'SEND RESET LINK',
            onPressed: _submit,
            isLoading: isLoading,
          ),

          SizedBox(height: 24.h),
          if (_mode == AuthMode.login)
            _buildAuthToggle('NEW AROUND HERE? ', 'JOIN NOW', () {
              FocusScope.of(context).unfocus();
              Future.delayed(const Duration(milliseconds: 50), () {
                if (mounted) setState(() => _mode = AuthMode.register);
              });
            }),
          if (_mode == AuthMode.register)
            _buildAuthToggle('ALREADY JOINED? ', 'LOG IN', () {
              FocusScope.of(context).unfocus();
              Future.delayed(const Duration(milliseconds: 50), () {
                if (mounted) setState(() => _mode = AuthMode.login);
              });
            }),
        ],
      ).animate().fadeIn().slideX(begin: 0.1, end: 0),
    );
  }

  Widget _buildAuthToggle(String text, String action, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 10.sp,
              ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            action,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.gold,
                  fontWeight: FontWeight.bold,
                  fontSize: 10.sp,
                  decoration: TextDecoration.underline,
                  decorationColor: AppTheme.gold.withValues(alpha: 0.3),
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    Widget? trailing,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppTheme.gold,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(fontSize: 14.sp, color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.white.withValues(alpha: 0.3), size: 16.sp),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Column(
        children: [
          Text(
            'SUIT PRO REWARDS',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 8.sp,
                  color: Colors.white.withValues(alpha: 0.1),
                  letterSpacing: 4,
                  fontWeight: FontWeight.w900,
                ),
          ),
          SizedBox(height: 4.h),
          Text(
            'CRAFTING EXCELLENCE',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 7.sp,
                  color: Colors.white.withValues(alpha: 0.05),
                  letterSpacing: 2,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}
