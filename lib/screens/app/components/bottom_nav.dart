import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:suit_pro_rewards_flutter/themes/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isAdmin;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {'icon': LucideIcons.home, 'label': 'Home'},
      {'icon': LucideIcons.wallet, 'label': 'Wallet'},
      {'icon': LucideIcons.shoppingBag, 'label': 'Shop'},
      {'icon': LucideIcons.user, 'label': 'Profile'},
      if (isAdmin) {'icon': LucideIcons.layoutDashboard, 'label': 'Admin'},
      {'icon': LucideIcons.list, 'label': 'More'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.card.withOpacity(0.92),
        border: Border(top: BorderSide(color: AppTheme.gold.withOpacity(0.08))),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 68.h,
              child: Row(
                children: items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final bool isSelected = index == currentIndex;

                  return Expanded(
                    child: InkWell(
                      onTap: () => onTap(index),
                      highlightColor: Colors.transparent,
                      splashColor: AppTheme.gold.withOpacity(0.05),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item['icon'],
                            size: 20.sp,
                            color: isSelected ? AppTheme.gold : AppTheme.mutedForeground.withOpacity(0.6),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            item['label'],
                            style: TextStyle(
                              fontSize: 9.sp,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? AppTheme.gold : AppTheme.mutedForeground.withOpacity(0.6),
                              letterSpacing: 0.5,
                            ),
                          ),
                          if (isSelected)
                            Container(
                              margin: EdgeInsets.only(top: 4.h),
                              width: 4.w,
                              height: 4.h,
                              decoration: const BoxDecoration(
                                color: AppTheme.gold,
                                shape: BoxShape.circle,
                              ),
                            ).animate().scale(duration: 200.ms),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
