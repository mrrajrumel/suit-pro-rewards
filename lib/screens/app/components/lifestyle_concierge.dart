import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:suit_pro_rewards_flutter/themes/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LifestyleConcierge extends StatelessWidget {
  final String tier;
  final List<dynamic> products;

  const LifestyleConcierge({
    super.key,
    required this.tier,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox();

    // Simplified recommendation logic for Flutter
    final recommendations = products.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(LucideIcons.sparkles, color: AppTheme.gold, size: 16.sp)
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(duration: 2.seconds),
                  SizedBox(width: 8.w),
                  Text(
                    'PICKS FOR YOU',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppTheme.gold,
                          letterSpacing: 2.sp,
                          fontSize: 10.sp,
                        ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => context.go('/shop'),
                child: Row(
                  children: [
                    Text(
                      'THE SHOP',
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: AppTheme.mutedForeground,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(LucideIcons.arrowRight, size: 10.sp, color: AppTheme.mutedForeground),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 180.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recommendations.length,
            padding: EdgeInsets.only(bottom: 8.h),
            itemBuilder: (context, index) {
              final product = recommendations[index];
              return Container(
                width: 280.w,
                margin: EdgeInsets.only(right: 16.w),
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: AppTheme.card,
                  borderRadius: BorderRadius.circular(40.r),
                  border: Border.all(color: AppTheme.gold.withOpacity(0.12)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -10.w,
                      bottom: -10.h,
                      child: Opacity(
                        opacity: 0.05,
                        child: Transform.rotate(
                          angle: -0.2,
                          child: Icon(LucideIcons.tag, size: 80.sp, color: AppTheme.gold),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 64.w,
                              height: 64.h,
                              decoration: BoxDecoration(
                                color: AppTheme.secondary,
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(color: AppTheme.gold.withOpacity(0.08)),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.r),
                                child: product['image'] != null
                                    ? Image.network(product['image'], fit: BoxFit.cover)
                                    : Icon(LucideIcons.package, color: AppTheme.gold.withOpacity(0.2)),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: AppTheme.gold.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(color: AppTheme.gold.withOpacity(0.2)),
                                  ),
                                  child: Text(
                                    'OUR PICK',
                                    style: TextStyle(
                                      color: AppTheme.gold,
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  '£${product['price']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          product['name'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0,
                              ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(LucideIcons.star, color: AppTheme.gold, size: 12.sp, fill: AppTheme.gold.value.toDouble()),
                                SizedBox(width: 4.w),
                                Text(
                                  'Recommended for $tier',
                                  style: TextStyle(
                                    color: AppTheme.gold,
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                color: AppTheme.secondary,
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(color: AppTheme.gold.withOpacity(0.1)),
                              ),
                              child: Icon(LucideIcons.arrowRight, size: 14.sp, color: AppTheme.mutedForeground),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.05, end: 0, curve: Curves.easeOutCubic);
            },
          ),
        ),
      ],
    );
  }
}
