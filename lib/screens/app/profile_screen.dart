import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:suit_pro_rewards_flutter/providers/user_provider.dart';
import 'package:suit_pro_rewards_flutter/themes/app_theme.dart';
import 'package:suit_pro_rewards_flutter/widgets/logo.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _showQR = false;

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);
    final user = userAsync.asData?.value;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: userAsync.when(
        data: (user) {
          if (user == null) return const Center(child: Text('User not found'));

          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 64.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(user),
                    SizedBox(height: 32.h),
                    _buildQRCard(user),
                    SizedBox(height: 24.h),
                    _buildSectionHeader(LucideIcons.user, 'Profile Information'),
                    _buildInfoSection(user),
                    SizedBox(height: 24.h),
                    _buildSectionHeader(LucideIcons.shield, 'Shipping Address'),
                    _buildAddressSection(user),
                    SizedBox(height: 24.h),
                    _buildSectionHeader(LucideIcons.scissors, 'Your Sizes'),
                    _buildSizesSection(user),
                    SizedBox(height: 24.h),
                    _buildSectionHeader(LucideIcons.settings, 'Settings'),
                    _buildSettingsSection(),
                    SizedBox(height: 48.h),
                    _buildFooter(user),
                  ],
                ),
              ),
              if (_showQR) _buildQRModal(user),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.gold)),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildHeader(dynamic user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 64.w,
              height: 64.h,
              decoration: BoxDecoration(
                color: AppTheme.secondary.withOpacity(0.8),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: AppTheme.gold.withOpacity(0.1)),
              ),
              child: Icon(LucideIcons.user, color: AppTheme.gold.withOpacity(0.6), size: 32.sp),
            ),
            SizedBox(width: 16.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.fullName, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 24.sp)),
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppTheme.gold.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: AppTheme.gold.withOpacity(0.2)),
                  ),
                  child: Text(
                    '${user.tier.toUpperCase()} MEMBER',
                    style: TextStyle(color: AppTheme.gold, fontSize: 9.sp, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            _buildIconButton(LucideIcons.qrCode, () => setState(() => _showQR = true), color: AppTheme.gold),
            SizedBox(width: 8.w),
            _buildIconButton(LucideIcons.logOut, () => FirebaseAuth.instance.signOut(), color: Colors.white24),
          ],
        ),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap, {Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: color == AppTheme.gold ? AppTheme.gold.withOpacity(0.1) : AppTheme.secondary,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: color == AppTheme.gold ? AppTheme.gold.withOpacity(0.2) : AppTheme.gold.withOpacity(0.1)),
        ),
        child: Icon(icon, color: color == AppTheme.gold ? AppTheme.gold : AppTheme.mutedForeground, size: 20.sp),
      ),
    );
  }

  Widget _buildQRCard(dynamic user) {
    return GestureDetector(
      onTap: () => setState(() => _showQR = true),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(40.r),
          border: Border.all(color: AppTheme.gold.withOpacity(0.2)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(color: AppTheme.gold.withOpacity(0.1), borderRadius: BorderRadius.circular(16.r)),
              child: Icon(LucideIcons.qrCode, color: AppTheme.gold, size: 24.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Digital ID Card', style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4.h),
                  Text('SHOW IN-STORE TO EARN POINTS', style: TextStyle(color: AppTheme.mutedForeground, fontSize: 10.sp, fontWeight: FontWeight.w900, letterSpacing: 1)),
                ],
              ),
            ),
            Icon(LucideIcons.chevronRight, color: AppTheme.mutedForeground.withOpacity(0.3), size: 16.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.gold, size: 14.sp),
              SizedBox(width: 8.w),
              Text(
                title.toUpperCase(),
                style: TextStyle(color: AppTheme.gold, fontSize: 10.sp, fontWeight: FontWeight.w900, letterSpacing: 2),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => context.go('/profile/edit'),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppTheme.gold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: AppTheme.gold.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(LucideIcons.edit3, size: 12.sp, color: Colors.white),
                  SizedBox(width: 4.w),
                  Text('EDIT', style: TextStyle(color: Colors.white, fontSize: 9.sp, fontWeight: FontWeight.w900)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(dynamic user) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(color: AppTheme.gold.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          _buildInfoRow('Full Name', user.fullName),
          SizedBox(height: 16.h),
          _buildInfoRow('Phone', user.phone ?? 'Not Shared'),
          SizedBox(height: 16.h),
          _buildInfoRow('Email', user.email, isMono: true),
        ],
      ),
    );
  }

  Widget _buildAddressSection(dynamic user) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(color: AppTheme.gold.withOpacity(0.1)),
      ),
      child: Text(
        user.address ?? 'No address saved',
        style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSizesSection(dynamic user) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(color: AppTheme.gold.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSizeItem('Suit', user.suitSize),
          _buildSizeItem('Shirt', user.shirtSize),
          _buildSizeItem('Waist', user.trouserSize),
        ],
      ),
    );
  }

  Widget _buildSizeItem(String label, String? value) {
    return Column(
      children: [
        Text(label.toUpperCase(), style: TextStyle(color: AppTheme.mutedForeground, fontSize: 8.sp, fontWeight: FontWeight.w900, letterSpacing: 1)),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(color: AppTheme.secondary.withOpacity(0.4), borderRadius: BorderRadius.circular(12.r), border: Border.all(color: AppTheme.gold.withOpacity(0.05))),
          child: Text(value ?? 'N/A', style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w900)),
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      children: [
        _buildSettingsItem(LucideIcons.bell, 'Notifications', 'Alerts are on', Colors.blue),
        SizedBox(height: 12.h),
        _buildSettingsItem(LucideIcons.shield, 'Privacy & Security', 'Securely Encrypted', Colors.emerald),
      ],
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, String subtitle, Color color) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(color: AppTheme.gold.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16.r), border: Border.all(color: color.withOpacity(0.2))),
            child: Icon(icon, color: color, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 4.h),
                Text(subtitle.toUpperCase(), style: TextStyle(color: AppTheme.mutedForeground, fontSize: 9.sp, fontWeight: FontWeight.w900, letterSpacing: 1)),
              ],
            ),
          ),
          Icon(LucideIcons.chevronRight, color: AppTheme.mutedForeground.withOpacity(0.3), size: 16.sp),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isMono = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: TextStyle(color: AppTheme.mutedForeground, fontSize: 8.sp, fontWeight: FontWeight.w900, letterSpacing: 2)),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: isMono ? FontWeight.normal : FontWeight.bold,
            fontFamily: isMono ? 'monospace' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(dynamic user) {
    final String date = user.createdAt != null ? DateFormat('MMMM yyyy').format(user.createdAt!) : 'Just joined';
    return Center(
      child: Text(
        'MEMBER SINCE $date'.toUpperCase(),
        style: TextStyle(color: AppTheme.mutedForeground.withOpacity(0.3), fontSize: 9.sp, fontWeight: FontWeight.w900, letterSpacing: 3, fontStyle: FontStyle.italic),
      ),
    );
  }

  Widget _buildQRModal(dynamic user) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: AppTheme.background.withOpacity(0.95),
        alignment: Alignment.center,
        padding: EdgeInsets.all(24.w),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(maxWidth: 360.w),
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(48.r),
            border: Border.all(color: AppTheme.gold.withOpacity(0.3)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(32.w),
                decoration: BoxDecoration(
                  color: AppTheme.gold.withOpacity(0.1),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(48.r)),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () => setState(() => _showQR = false),
                        child: Icon(LucideIcons.x, color: AppTheme.mutedForeground, size: 20.sp),
                      ),
                    ),
                    Center(
                      child: Column(
                        children: [
                          const Logo(size: 32),
                          SizedBox(height: 16.h),
                          Text('Member ID Card', style: Theme.of(context).textTheme.headlineSmall),
                          SizedBox(height: 8.h),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                            decoration: BoxDecoration(color: AppTheme.gold.withOpacity(0.1), borderRadius: BorderRadius.circular(20.r), border: Border.all(color: AppTheme.gold.withOpacity(0.2))),
                            child: Text('${user.tier.toUpperCase()} MEMBER', style: TextStyle(color: AppTheme.gold, fontSize: 9.sp, fontWeight: FontWeight.bold, letterSpacing: 1)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(40.w),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32.r)),
                      child: QrImageView(
                        data: user.id,
                        version: QrVersions.auto,
                        size: 200.w,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    Text(user.fullName, style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4.h),
                    Text('ID: ${user.id.substring(0, 16).toUpperCase()}...', style: TextStyle(color: AppTheme.mutedForeground, fontSize: 10.sp, fontFamily: 'monospace')),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(color: AppTheme.secondary, borderRadius: BorderRadius.vertical(bottom: Radius.circular(48.r))),
                child: Column(
                  children: [
                    Text('STORE STAFF', style: TextStyle(color: AppTheme.gold, fontSize: 10.sp, fontWeight: FontWeight.bold, letterSpacing: 2)),
                    SizedBox(height: 4.h),
                    Text(
                      'Scan this code to verify member status and award points for this visit.',
                      style: TextStyle(color: AppTheme.mutedForeground, fontSize: 10.sp, fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn();
  }
}
