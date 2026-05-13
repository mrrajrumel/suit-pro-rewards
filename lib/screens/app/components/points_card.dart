import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:suit_pro_rewards_flutter/providers/user_provider.dart';
import 'package:suit_pro_rewards_flutter/themes/app_theme.dart';
import 'package:suit_pro_rewards_flutter/utils/tier_utils.dart';
import 'package:intl/intl.dart';

class PointsCard extends ConsumerWidget {
  const PointsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final user = userAsync.asData?.value;

    if (user == null) return const SizedBox();

    final tierData = TierUtils.tiers[user.tier] ?? TierUtils.tiers['Silver']!;
    final nextTier = TierUtils.getNextTier(user.tier);

    final double progress = nextTier != null
        ? (user.totalSpent / nextTier.threshold).clamp(0.0, 1.0)
        : 1.0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppTheme.gold.withOpacity(0.2)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.gold.withOpacity(0.15),
            AppTheme.gold.withOpacity(0.05),
            Colors.transparent,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.gold.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Watermark Icon
          Positioned(
            bottom: -40.h,
            right: -40.w,
            child: Transform.rotate(
              angle: -0.2,
              child: Icon(
                LucideIcons.crown,
                size: 160.sp,
                color: AppTheme.gold.withOpacity(0.05),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AVAILABLE POINTS',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppTheme.gold,
                            letterSpacing: 2,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              NumberFormat('#,###').format(user.points),
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'pts',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.gold.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: tierData.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: tierData.color.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            user.tier == 'Silver' ? LucideIcons.star :
                            user.tier == 'Gold' ? LucideIcons.crown : LucideIcons.gem,
                            size: 12.sp,
                            color: tierData.color,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            user.tier.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: tierData.color,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontFamily: GoogleFonts.playfairDisplay().fontFamily,
                      ),
                    ),
                    if (user.phone != null)
                      Text(
                        user.phone!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '£${NumberFormat('#,###').format(user.totalSpent)} spent',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (nextTier != null)
                      Text(
                        'Next: ${nextTier.label} at £${NumberFormat('#,###').format(nextTier.threshold)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.gold.withOpacity(0.6),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 8.h),
                if (nextTier != null)
                  Container(
                    height: 6.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppTheme.gold.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppTheme.goldDark, AppTheme.goldLight],
                          ),
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                      ).animate().shimmer(duration: 2.seconds),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0);
  }
}
