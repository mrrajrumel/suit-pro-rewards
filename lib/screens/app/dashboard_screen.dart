import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:suit_pro_rewards_flutter/providers/user_provider.dart';
import 'package:suit_pro_rewards_flutter/providers/dashboard_view_model.dart';
import 'package:suit_pro_rewards_flutter/themes/app_theme.dart';
import 'package:suit_pro_rewards_flutter/widgets/logo.dart';
import 'package:suit_pro_rewards_flutter/screens/app/components/points_card.dart';
import 'package:suit_pro_rewards_flutter/screens/app/components/lifestyle_concierge.dart';
import 'package:suit_pro_rewards_flutter/screens/app/components/ai_style_guide.dart';
import 'package:suit_pro_rewards_flutter/screens/app/components/points_info.dart';
import 'package:timeago/timeago.dart' as timeago;

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _isRefreshing = false;

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    // Simulate refresh
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isRefreshing = false);
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

          return RefreshIndicator(
            onRefresh: _handleRefresh,
            color: AppTheme.gold,
            backgroundColor: AppTheme.card,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 56.h),
                  _buildHeader(),
                  SizedBox(height: 32.h),
                  _buildGreeting(user.fullName, user.tier),
                  SizedBox(height: 32.h),
                  LifestyleConcierge(tier: user.tier, products: dashboardState.products.asData?.value ?? []),
                  SizedBox(height: 32.h),
                  const AIStyleGuide(),
                  if (dashboardState.flashSales.asData?.value.isNotEmpty ?? false) ...[
                    SizedBox(height: 32.h),
                    _buildFlashSales(dashboardState.flashSales),
                  ],
                  SizedBox(height: 32.h),
                  _buildTierProgress(user.tier),
                  SizedBox(height: 32.h),
                  const PointsCard(),
                  SizedBox(height: 32.h),
                  _buildConnectBanner(),
                  SizedBox(height: 32.h),
                  _buildQuickActions(),
                  SizedBox(height: 32.h),
                  _buildConnectWithUs(),
                  SizedBox(height: 32.h),
                  _buildShareExperience(),
                  SizedBox(height: 32.h),
                  _buildConciergeServices(),
                  SizedBox(height: 32.h),
                  _buildActivityHistory(dashboardState.activities),
                  SizedBox(height: 32.h),
                  const PointsInfo(),
                  SizedBox(height: 120.h),
                ],
              ),
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
        const Logo(size: 28),
        Row(
          children: [
            _buildHeaderButton(LucideIcons.qrCode, () => context.go('/profile')),
            SizedBox(width: 12.w),
            _buildHeaderButton(
              LucideIcons.refreshCw,
              _handleRefresh,
              isRotating: _isRefreshing,
            ),
            SizedBox(width: 12.w),
            Stack(
              children: [
                _buildHeaderButton(LucideIcons.bell, () => context.go('/notifications')),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppTheme.gold,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.card, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderButton(IconData icon, VoidCallback onTap, {bool isRotating = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: AppTheme.card,
          shape: BoxShape.circle,
          border: Border.all(color: AppTheme.gold.withOpacity(0.1)),
        ),
        child: Icon(icon, color: AppTheme.gold, size: 16.sp)
            .animate(target: isRotating ? 1 : 0, onPlay: (controller) => controller.repeat())
            .rotate(duration: 1.seconds),
      ),
    );
  }

  Widget _buildGreeting(String name, String tier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 32.sp, fontWeight: FontWeight.w700),
            children: [
              const TextSpan(text: 'Welcome, '),
              TextSpan(
                text: name.split(' ')[0],
                style: const TextStyle(color: AppTheme.gold),
              ),
            ],
          ),
        ),
        SizedBox(height: 6.h),
        Row(
          children: [
            Text('$tier Tier Status', style: TextStyle(color: AppTheme.mutedForeground, fontSize: 13.sp, fontWeight: FontWeight.w500)),
            SizedBox(width: 8.w),
            Container(width: 4.w, height: 4.h, decoration: BoxDecoration(color: AppTheme.gold.withOpacity(0.3), shape: BoxShape.circle)),
            SizedBox(width: 8.w),
            Text('Exclusive Benefits Active', style: TextStyle(color: AppTheme.gold, fontSize: 13.sp, fontWeight: FontWeight.w700)),
          ],
        ),
      ],
    );
  }

  Widget _buildFlashSales(AsyncValue<List<dynamic>> flashSalesAsync) {
    return flashSalesAsync.when(
      data: (sales) {
        if (sales.isEmpty) return const SizedBox();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(LucideIcons.zap, color: AppTheme.gold, size: 16.sp, fill: AppTheme.gold.value.toDouble()),
                    SizedBox(width: 8.w),
                    Text('FLASH SALES', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white, letterSpacing: 2)),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppTheme.gold.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(color: AppTheme.gold.withOpacity(0.1)),
                  ),
                  child: Text('LIMITED TIME', style: TextStyle(color: AppTheme.gold, fontSize: 8.sp, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            SizedBox(
              height: 120.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: sales.length,
                itemBuilder: (context, index) {
                  final sale = sales[index];
                  return Container(
                    width: 240.w,
                    margin: EdgeInsets.only(right: 16.w),
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: AppTheme.card,
                      borderRadius: BorderRadius.circular(32.r),
                      border: Border.all(color: AppTheme.gold.withOpacity(0.2)),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -20.w,
                          bottom: -20.h,
                          child: Icon(LucideIcons.zap, size: 80.sp, color: AppTheme.gold.withOpacity(0.05)),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(sale.name.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w900, letterSpacing: 1)),
                            SizedBox(height: 4.h),
                            Text('Up to ${sale.discountPercentage}% OFF', style: TextStyle(color: AppTheme.gold, fontSize: 10.sp, fontWeight: FontWeight.bold)),
                            const Spacer(),
                            Row(
                              children: [
                                Text('SHOP NOW', style: TextStyle(color: Colors.white, fontSize: 8.sp, fontWeight: FontWeight.w900, letterSpacing: 1)),
                                SizedBox(width: 4.w),
                                Icon(LucideIcons.chevronRight, size: 10.sp, color: Colors.white),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
    );
  }

  Widget _buildTierProgress(String currentTier) {
    final tiers = [
      {'label': 'SILVER', 'bonus': '10x Boost'},
      {'label': 'GOLD', 'bonus': '15x Boost'},
      {'label': 'PLATINUM', 'bonus': '25x Boost'},
    ];

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(color: AppTheme.gold.withOpacity(0.15)),
        boxShadow: AppTheme.premiumShadow,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('YOUR JOURNEY', style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 9.sp, letterSpacing: 3, fontWeight: FontWeight.w900)),
              GestureDetector(
                onTap: () => context.go('/profile'),
                child: Text('VIEW STATUS', style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 8.sp, letterSpacing: 1, color: AppTheme.mutedForeground, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            children: tiers.map((t) {
              final bool isActive = t['label'] == currentTier.toUpperCase();
              return Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: BoxDecoration(
                    color: isActive ? AppTheme.gold : AppTheme.background.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: isActive ? AppTheme.gold : AppTheme.gold.withOpacity(0.08)),
                    boxShadow: isActive ? [BoxShadow(color: AppTheme.gold.withOpacity(0.25), blurRadius: 12, offset: const Offset(0, 4))] : null,
                  ),
                  child: Column(
                    children: [
                      Text(t['label']!, style: TextStyle(color: isActive ? Colors.black : Colors.white.withOpacity(0.4), fontSize: 8.sp, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                      SizedBox(height: 4.h),
                      Text(t['bonus']!, style: TextStyle(color: isActive ? Colors.black.withOpacity(0.6) : Colors.white.withOpacity(0.2), fontSize: 7.sp, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppTheme.gold,
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [BoxShadow(color: AppTheme.gold.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(LucideIcons.externalLink, size: 100.sp, color: Colors.black.withOpacity(0.05)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('CONNECT YOUR WEBSITE ACCOUNT', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.w900)),
              SizedBox(height: 4.h),
              Text('Unlock bespoke order tracking and extra points for online shopping.', style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 10.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 16.h),
              GestureDetector(
                onTap: () => context.go('/website-link'),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.1), borderRadius: BorderRadius.circular(8.r), border: Border.all(color: Colors.black.withOpacity(0.1))),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('CLICK TO LINK', style: TextStyle(color: Colors.black, fontSize: 9.sp, fontWeight: FontWeight.w900, letterSpacing: 1)),
                      SizedBox(width: 8.w),
                      Icon(LucideIcons.chevronRight, size: 12.sp, color: Colors.black),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {'icon': LucideIcons.qrCode, 'label': 'Scan', 'color': AppTheme.gold, 'path': '/scan-receipt', 'special': true},
      {'icon': LucideIcons.wallet, 'label': 'Wallet', 'color': Colors.blue, 'path': '/wallet'},
      {'icon': LucideIcons.gift, 'label': 'Rewards', 'color': Colors.purple, 'path': '/rewards'},
      {'icon': LucideIcons.shoppingBag, 'label': 'Shop', 'color': Colors.green, 'path': '/shop'},
      {'icon': LucideIcons.share2, 'label': 'Refer', 'color': Colors.orange, 'path': '/referral'},
      {'icon': LucideIcons.clock, 'label': 'History', 'color': Colors.blueGrey, 'path': '/notifications'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final color = actions[index]['color'] as Color;
        final bool isSpecial = actions[index]['special'] == true;
        
        return GestureDetector(
          onTap: () => context.go(actions[index]['path'] as String),
          child: Column(
            children: [
              Container(
                width: 56.w,
                height: 56.h,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: color.withOpacity(0.1)),
                  boxShadow: isSpecial ? [BoxShadow(color: color.withOpacity(0.15), blurRadius: 12, offset: const Offset(0, 4))] : null,
                ),
                child: Icon(actions[index]['icon'] as IconData, color: color, size: 24.sp),
              ),
              SizedBox(height: 8.h),
              Text(
                (actions[index]['label'] as String).toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 8.5.sp, letterSpacing: 1, color: AppTheme.mutedForeground, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ).animate().fadeIn(delay: (index * 50).ms).slideY(begin: 0.1, end: 0);
      },
    );
  }

  Widget _buildConnectWithUs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('CONNECT WITH US', style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold, letterSpacing: 1)),
        SizedBox(height: 16.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildSocialCard(
                icon: LucideIcons.star,
                title: 'REVIEW US',
                subtitle: 'Share your experience on Google Maps',
                color: Colors.blue,
              ),
              SizedBox(width: 16.w),
              _buildSocialCard(
                icon: LucideIcons.camera,
                title: 'INSTAGRAM',
                subtitle: 'Follow our latest styles & collections',
                color: Colors.purple,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialCard({required IconData icon, required String title, required String subtitle, required Color color}) {
    return Container(
      width: 200.w,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12.r)),
            child: Icon(icon, color: Colors.white, size: 20.sp),
          ),
          SizedBox(height: 16.h),
          Text(title, style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w900, letterSpacing: 1)),
          SizedBox(height: 4.h),
          Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 9.sp)),
        ],
      ),
    );
  }

  Widget _buildShareExperience() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(40.r),
        border: Border.all(color: AppTheme.gold.withOpacity(0.1)),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            top: -10,
            child: Icon(LucideIcons.star, size: 80.sp, color: AppTheme.gold.withOpacity(0.05), fill: AppTheme.gold.withOpacity(0.05).value.toDouble()),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: List.generate(5, (_) => Icon(LucideIcons.star, size: 16.sp, color: AppTheme.gold, fill: AppTheme.gold.value.toDouble()))),
              SizedBox(height: 16.h),
              Text('Love your SuitPro experience?', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20.sp)),
              SizedBox(height: 8.h),
              Text(
                '"The highest compliment our patrons can pay us is a recommendation to their circle."',
                style: TextStyle(color: AppTheme.mutedForeground, fontSize: 11.sp, fontStyle: FontStyle.italic, height: 1.5),
              ),
              SizedBox(height: 24.h),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(LucideIcons.externalLink, size: 14.sp, color: Colors.black),
                label: const Text('RATE US ON GOOGLE'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConciergeServices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('CONCIERGE SERVICES', style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold, letterSpacing: 1)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(color: AppTheme.gold.withOpacity(0.05), borderRadius: BorderRadius.circular(4.r), border: Border.all(color: AppTheme.gold.withOpacity(0.1))),
              child: Text('PRIORITY ACCESS', style: TextStyle(color: AppTheme.gold, fontSize: 8.sp, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _buildConciergeItem(LucideIcons.clock, 'BOOK FITTING', 'Schedule your expert session', AppTheme.gold)),
            SizedBox(width: 16.w),
            Expanded(child: _buildConciergeItem(LucideIcons.sparkles, 'STYLE ASSISTANT', 'AI-powered fashion advice', Colors.purple)),
          ],
        ),
      ],
    );
  }

  Widget _buildConciergeItem(IconData icon, String title, String subtitle, Color color) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(24.r), border: Border.all(color: AppTheme.gold.withOpacity(0.1))),
      child: Column(
        children: [
          Container(padding: EdgeInsets.all(12.w), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16.r)), child: Icon(icon, color: color, size: 24.sp)),
          SizedBox(height: 12.h),
          Text(title, style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          SizedBox(height: 4.h),
          Text(subtitle, style: TextStyle(color: AppTheme.mutedForeground, fontSize: 8.sp), textAlign: TextAlign.center),
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
            Text('WALLET HISTORY', style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold, letterSpacing: 1)),
            GestureDetector(
              onTap: () => context.go('/wallet'),
              child: Text('VIEW ALL', style: TextStyle(color: AppTheme.gold, fontSize: 10.sp, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        activitiesAsync.when(
          data: (activities) {
            if (activities.isEmpty) {
              return Container(
                width: double.infinity,
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(24.r), border: Border.all(color: AppTheme.gold.withOpacity(0.05))),
                child: Text('No recent activity found.', style: TextStyle(color: AppTheme.mutedForeground, fontSize: 12.sp, fontStyle: FontStyle.italic), textAlign: TextAlign.center),
              );
            }
            return Column(
              children: activities.take(5).map((activity) => _buildActivityItem(activity)).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.gold)),
          error: (e, st) => Text('Error loading activities', style: TextStyle(color: Colors.red, fontSize: 12.sp)),
        ),
      ],
    );
  }

  Widget _buildActivityItem(dynamic activity) {
    final bool isPositive = activity.type == 'earn' || activity.type == 'referral' || activity.type == 'bonus';
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(24.r), border: Border.all(color: AppTheme.gold.withOpacity(0.1))),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: isPositive ? AppTheme.gold.withOpacity(0.1) : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(isPositive ? LucideIcons.trophy : LucideIcons.gift, color: isPositive ? AppTheme.gold : Colors.red, size: 16.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity.description, style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 4.h),
                Text(activity.createdAt != null ? timeago.format(activity.createdAt!) : 'Just now', style: TextStyle(color: AppTheme.mutedForeground, fontSize: 10.sp)),
              ],
            ),
          ),
          Text(
            '${isPositive ? '+' : '-'}${activity.points}',
            style: TextStyle(color: isPositive ? AppTheme.gold : Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
