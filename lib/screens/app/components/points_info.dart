import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:suit_pro_rewards_flutter/themes/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PointsInfo extends StatefulWidget {
  const PointsInfo({super.key});

  @override
  State<PointsInfo> createState() => _PointsInfoState();
}

class _PointsInfoState extends State<PointsInfo> {
  Map<String, dynamic>? _settings;

  @override
  void initState() {
    super.initState();
    _fetchSettings();
  }

  void _fetchSettings() {
    FirebaseFirestore.instance
        .collection('site_settings')
        .doc('global')
        .snapshots()
        .listen((snap) {
      if (mounted && snap.exists) {
        setState(() {
          _settings = snap.data();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final rules = [
      {
        'icon': LucideIcons.shoppingBag,
        'title': 'Luxury Purchases',
        'description': 'Earn ${_settings?['points_per_pound'] ?? 10} points for every £1 spent in-store or online.',
        'color': AppTheme.gold,
        'bg': AppTheme.gold.withOpacity(0.1),
      },
      {
        'icon': LucideIcons.userPlus,
        'title': 'Refer a Friend',
        'description': 'Get ${_settings?['referral_bonus'] ?? 100} points when a new member joins using your code.',
        'color': Colors.green,
        'bg': Colors.green.withOpacity(0.1),
      },
      {
        'icon': LucideIcons.logIn,
        'title': 'Daily Visit',
        'description': 'Simply open the app for a daily bonus of ${_settings?['login_bonus'] ?? 10} points.',
        'color': Colors.blue,
        'bg': Colors.blue.withOpacity(0.1),
      },
      {
        'icon': LucideIcons.gift,
        'title': 'Welcome Gift',
        'description': 'New members start their journey with ${_settings?['welcome_bonus'] ?? 50} points.',
        'color': Colors.purple,
        'bg': Colors.purple.withOpacity(0.1),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            children: [
              Icon(LucideIcons.helpCircle, color: AppTheme.gold, size: 14.sp),
              SizedBox(width: 8.w),
              Text(
                'WAYS TO EARN',
                style: TextStyle(
                  color: AppTheme.gold,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        ...rules.map((rule) => _buildRuleCard(rule)),
        SizedBox(height: 24.h),
        _buildInfoBox(),
      ],
    );
  }

  Widget _buildRuleCard(Map<String, dynamic> rule) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppTheme.gold.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: rule['bg'],
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(rule['icon'], color: rule['color'], size: 20.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rule['title'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  rule['description'],
                  style: TextStyle(
                    color: AppTheme.mutedForeground,
                    fontSize: 10.sp,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          Icon(LucideIcons.chevronRight, color: AppTheme.gold.withOpacity(0.2), size: 16.sp),
        ],
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppTheme.secondary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppTheme.gold.withOpacity(0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.info, color: AppTheme.gold.withOpacity(0.6), size: 16.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'Points are awarded automatically for daily visits and referrals. Points for purchases are added manually by our tailors after your fitting/transaction is confirmed.',
              style: TextStyle(
                color: AppTheme.mutedForeground,
                fontSize: 9.sp,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
