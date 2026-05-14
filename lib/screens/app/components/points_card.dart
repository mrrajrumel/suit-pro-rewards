import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
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
        borderRadius: BorderRadius.circular(32.r),
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
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Watermark Icon
          Positioned(
            bottom: -50.h,
            right: -50.w,
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
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              NumberFormat('#,###').format(user.points),
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontSize: 36.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              'pts',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.gold.withOpacity(0.7),
                                fontWeight: FontWeight.w600,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: tierData.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(24.r),
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
                              fontWeight: FontWeight.w900,
                              color: tierData.color,
                              letterSpacing: 1.5,
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
                        fontSize: 22.sp,
                      ),
                    ),
                    if (user.phone != null)
                      Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          user.phone!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.mutedForeground.withOpacity(0.6),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '£${NumberFormat('#,###').format(user.totalSpent)} spent',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (nextTier != null)
                      Text(
                        'Next: ${nextTier.label} at £${NumberFormat('#,###').format(nextTier.threshold)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.gold.withOpacity(0.6),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 12.h),
                if (nextTier != null)
                  Container(
                    height: 6.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppTheme.gold.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppTheme.goldDark, AppTheme.goldLight],
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ).animate().shimmer(duration: 2.seconds),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.05, end: 0, curve: Curves.easeOutCubic);
  }
}
