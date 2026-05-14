import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:suit_pro_rewards_flutter/providers/user_provider.dart';
import 'package:suit_pro_rewards_flutter/themes/app_theme.dart';

import 'package:suit_pro_rewards_flutter/widgets/glass_container.dart';

class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final userAsync = ref.watch(userProvider);

    final rewards = [
      {
        'id': 1,
        'title': 'Complimentary Pocket Square',
        'points': 500,
        'description': 'Silk pocket square with bespoke pattern.',
        'icon': LucideIcons.star,
        'color': Colors.blue,
      },
      {
        'id': 2,
        'title': 'Bespoke Fitting Session',
        'points': 1200,
        'description': 'One-on-one expert tailoring consultation.',
        'icon': LucideIcons.zap,
        'color': AppTheme.gold,
      },
      {
        'id': 3,
        'title': 'Member Only Gala Entry',
        'points': 5000,
        'description': 'VIP access to our annual sartorial event.',
        'icon': LucideIcons.gift,
        'color': Colors.purple,
      },
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: userAsync.when(
        data: (user) {
          if (user == null) return const Center(child: Text('User not found'));

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 64.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                SizedBox(height: 32.h),
                _buildBalanceCard(user.points),
                SizedBox(height: 32.h),
                Text(
                  'EXCLUSIVE OFFERS',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.gold),
                ),
                SizedBox(height: 16.h),
                ...rewards.asMap().entries.map((entry) => _buildRewardCard(entry.value, entry.key)),
                SizedBox(height: 32.h),
                _buildFooterBox(),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.gold)),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.pop(),
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
        Text('Available Rewards', style: Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }

  Widget _buildBalanceCard(int points) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: AppTheme.gold,
        borderRadius: BorderRadius.circular(40.r),
        boxShadow: [
          BoxShadow(
            color: AppTheme.gold.withValues(alpha: 0.2),
            blurRadius: 25,
            offset: const Offset(0, 12),
          )
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -25.w,
            bottom: -25.h,
            child: Icon(LucideIcons.gift, size: 120.sp, color: Colors.black.withValues(alpha: 0.08)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'YOUR BALANCE',
                style: TextStyle(color: Colors.black.withValues(alpha: 0.6), fontSize: 10.sp, fontWeight: FontWeight.w900, letterSpacing: 3),
              ),
              SizedBox(height: 6.h),
              Text(
                '$points PTS',
                style: TextStyle(color: Colors.black, fontSize: 34.sp, fontWeight: FontWeight.w900, letterSpacing: -1),
              ),
            ],
          ),
        ],
      ),
    ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack);
  }

  Widget _buildRewardCard(Map<String, dynamic> reward, int index) {
    final Color color = reward['color'] as Color;
    return GlassContainer(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(24.w),
      borderRadius: 32,
      opacity: 0.05,
      blur: 10,
      border: Border.all(color: AppTheme.gold.withValues(alpha: 0.1)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ],
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: color.withValues(alpha: 0.1)),
            ),
            child: Icon(reward['icon'] as IconData, color: color, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(reward['title'] as String, style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w700)),
                SizedBox(height: 4.h),
                Text(reward['description'] as String, style: TextStyle(color: AppTheme.mutedForeground, fontSize: 11.sp, height: 1.4)),
                SizedBox(height: 10.h),
                Text(
                  '${reward['points']} PTS',
                  style: TextStyle(color: AppTheme.gold, fontSize: 11.sp, fontWeight: FontWeight.w900, letterSpacing: 1.5),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppTheme.secondary,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppTheme.gold.withValues(alpha: 0.05)),
            ),
            child: Icon(LucideIcons.chevronRight, color: AppTheme.mutedForeground.withValues(alpha: 0.5), size: 16.sp),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 100).ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic);
  }


  Widget _buildFooterBox() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: AppTheme.secondary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(40.r),
        border: Border.all(color: AppTheme.gold.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Icon(LucideIcons.clock, color: AppTheme.gold.withValues(alpha: 0.2), size: 32.sp),
          SizedBox(height: 16.h),
          Text(
            '"Patience is the companion of wisdom. More rewards coming soon."',
            style: TextStyle(color: AppTheme.mutedForeground, fontSize: 12.sp, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
