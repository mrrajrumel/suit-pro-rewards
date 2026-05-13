import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:suit_pro_rewards_flutter/providers/user_provider.dart';
import 'package:suit_pro_rewards_flutter/providers/dashboard_view_model.dart';
import 'package:suit_pro_rewards_flutter/themes/app_theme.dart';
import 'package:suit_pro_rewards_flutter/screens/app/components/points_card.dart';
import 'package:timeago/timeago.dart' as timeago;

class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});

  @override
  ConsumerState<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen> {
  bool _isRefreshing = false;

  void _handleRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isRefreshing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wallet synchronized')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);
    final dashboardState = ref.watch(dashboardViewModelProvider);

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
                _buildHeader(),
                SizedBox(height: 32.h),
                const PointsCard(),
                SizedBox(height: 32.h),
                _buildStatsGrid(dashboardState.activities.asData?.value ?? []),
                SizedBox(height: 32.h),
                _buildActivityHistory(dashboardState.activities),
                SizedBox(height: 32.h),
                _buildQRClaimButton(),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.gold)),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppTheme.card,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.gold.withOpacity(0.1)),
                ),
                child: Icon(LucideIcons.arrowLeft, color: AppTheme.mutedForeground, size: 20.sp),
              ),
            ),
            SizedBox(width: 16.w),
            Text('My Wallet', style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
        GestureDetector(
          onTap: _handleRefresh,
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppTheme.card,
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.gold.withOpacity(0.1)),
            ),
            child: Icon(LucideIcons.refreshCw, color: AppTheme.gold, size: 16.sp)
                .animate(target: _isRefreshing ? 1 : 0)
                .rotate(duration: 1.seconds, iterations: -1),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(List<dynamic> activities) {
    final int totalEarned = activities
        .where((a) => a.type != 'spend')
        .fold(0, (sum, item) => sum + (item.points as int));
    final int totalSpent = activities
        .where((a) => a.type == 'spend')
        .fold(0, (sum, item) => sum + (item.points as int));

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'TOTAL EARNED',
            totalEarned.toString(),
            LucideIcons.trendingUp,
            AppTheme.gold,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildStatCard(
            'USED POINTS',
            totalSpent.toString(),
            LucideIcons.creditCard,
            Colors.redAccent,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppTheme.gold.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color.withOpacity(0.6), size: 14.sp),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  color: color.withOpacity(0.6),
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 20.sp),
              children: [
                TextSpan(text: value),
                TextSpan(
                  text: ' pts',
                  style: TextStyle(fontSize: 10.sp, color: Colors.white24),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityHistory(AsyncValue<List<dynamic>> activitiesAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'RECENT ACTIVITY',
              style: TextStyle(
                color: AppTheme.gold,
                fontSize: 10.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
            Row(
              children: [
                Icon(LucideIcons.download, size: 12.sp, color: AppTheme.mutedForeground.withOpacity(0.6)),
                SizedBox(width: 6.w),
                Text(
                  'EXPORT STATEMENT',
                  style: TextStyle(
                    color: AppTheme.mutedForeground.withOpacity(0.6),
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 16.h),
        activitiesAsync.when(
          data: (activities) {
            if (activities.isEmpty) {
              return Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 40.h),
                decoration: BoxDecoration(
                  color: AppTheme.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(color: AppTheme.gold.withOpacity(0.05)),
                ),
                child: Column(
                  children: [
                    Icon(LucideIcons.history, size: 40.sp, color: AppTheme.mutedForeground.withOpacity(0.1)),
                    SizedBox(height: 16.h),
                    Text(
                      'No transactions recorded yet.',
                      style: TextStyle(color: AppTheme.mutedForeground, fontSize: 12.sp, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                return _buildActivityItem(activity, index);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.gold)),
          error: (e, st) => const Center(child: Text('Error loading transactions')),
        ),
      ],
    );
  }

  Widget _buildActivityItem(dynamic activity, int index) {
    final bool isPositive = activity.type != 'spend';
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: AppTheme.gold.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: isPositive ? AppTheme.gold.withOpacity(0.1) : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(LucideIcons.trophy, color: isPositive ? AppTheme.gold : Colors.redAccent, size: 16.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.description,
                  style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.h),
                Text(
                  activity.createdAt != null ? timeago.format(activity.createdAt!) : 'Just now',
                  style: TextStyle(
                    color: AppTheme.mutedForeground,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isPositive ? '+' : '-'}${activity.points}',
                style: TextStyle(
                  color: isPositive ? AppTheme.gold : Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'PTS',
                style: TextStyle(
                  color: AppTheme.mutedForeground.withOpacity(0.3),
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 50).ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildQRClaimButton() {
    return GestureDetector(
      onTap: () => context.go('/scan-receipt'),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: AppTheme.secondary.withOpacity(0.8),
          borderRadius: BorderRadius.circular(32.r),
          border: Border.all(color: AppTheme.gold.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppTheme.gold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(LucideIcons.qrCode, color: AppTheme.gold, size: 20.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Claim with QR Code',
                    style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'SCAN YOUR SUITPRO RECEIPT',
                    style: TextStyle(
                      color: AppTheme.mutedForeground,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            Icon(LucideIcons.chevronRight, color: AppTheme.mutedForeground.withOpacity(0.3), size: 16.sp),
          ],
        ),
      ),
    );
  }
}
