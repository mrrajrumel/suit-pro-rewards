import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:suit_pro_rewards_flutter/providers/user_provider.dart';
import 'package:suit_pro_rewards_flutter/themes/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class ReferralScreen extends ConsumerStatefulWidget {
  const ReferralScreen({super.key});

  @override
  ConsumerState<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends ConsumerState<ReferralScreen> {
  bool _copied = false;

  void _copyToClipboard(String link) {
    Clipboard.setData(ClipboardData(text: link));
    setState(() => _copied = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link copied to clipboard!')),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  void _shareReferral(String link, String code) {
    Share.share(
      'Join me on Suit Pro Rewards and get 100 bonus points! Use my code: $code \n$link',
      subject: 'Join Suit Pro Rewards',
    );
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);
    final user = userAsync.asData?.value;

    final String referralCode = user?.referralCode ?? user?.uid.substring(0, 8).toUpperCase() ?? 'SUITPRO';
    // Format for Play Store Install Referrer tracking
    final String referralLink = 'https://play.google.com/store/apps/details?id=com.suitpro.app&referrer=ref%3D$referralCode';

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 64.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(context),
            SizedBox(height: 32.h),
            heroCard(),
            SizedBox(height: 48.h),
            referralLinkSection(referralLink),
            SizedBox(height: 24.h),
            shareButton(referralLink, referralCode),
            SizedBox(height: 32.h),
            rewardsInfo(),
          ],
        ),
      ),
    );
  }

  Widget header(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/dashboard');
            }
          },
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppTheme.card,
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.gold.withValues(alpha: 0.1)),
            ),
            child: Icon(LucideIcons.arrowLeft, color: AppTheme.mutedForeground, size: 20.sp),
          ),
        ),
        SizedBox(width: 16.w),
        Text('Refer a Friend', style: Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }

  Widget heroCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(40.r),
        border: Border.all(color: AppTheme.gold.withValues(alpha: 0.15)),
        boxShadow: AppTheme.premiumShadow,
      ),
      child: Stack(
        children: [
          Positioned(
            right: -25.w,
            top: -25.h,
            child: Opacity(
              opacity: 0.05,
              child: Icon(LucideIcons.trophy, size: 120.sp, color: AppTheme.gold),
            ),
          ),
          Column(
            children: [
              Container(
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                  color: AppTheme.gold.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(LucideIcons.users, color: AppTheme.gold, size: 40.sp),
              ),
              SizedBox(height: 24.h),
              Text(
                'Spread the Excellence',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 22.sp, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  '"Gift your inner circle 100 points, and receive 200 points for every successful bespoke referral."',
                  style: TextStyle(
                    color: AppTheme.mutedForeground,
                    fontSize: 13.sp,
                    fontStyle: FontStyle.italic,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget referralLinkSection(String link) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'YOUR REFERRAL LINK',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.gold),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppTheme.secondary,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppTheme.gold.withValues(alpha: 0.1)),
                ),
                child: Text(
                  link,
                  style: TextStyle(
                    color: AppTheme.mutedForeground,
                    fontSize: 12.sp,
                    fontFamily: 'monospace',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: () => _copyToClipboard(link),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppTheme.gold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppTheme.gold.withValues(alpha: 0.2)),
                ),
                child: Icon(
                  _copied ? LucideIcons.check : LucideIcons.copy,
                  color: AppTheme.gold,
                  size: 20.sp,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget shareButton(String link, String code) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _shareReferral(link, code),
        icon: Icon(LucideIcons.share2, size: 16.sp, color: Colors.black),
        label: const Text('SHARE MY CODE'),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        ),
      ),
    );
  }

  Widget rewardsInfo() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppTheme.secondary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppTheme.gold.withValues(alpha: 0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.trophy, color: AppTheme.gold, size: 16.sp),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'REWARDS PROGRAM',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Points are awarded automatically once your friend completes their first bespoke fitting session.',
                  style: TextStyle(
                    color: AppTheme.mutedForeground,
                    fontSize: 10.sp,
                    height: 1.5,
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
