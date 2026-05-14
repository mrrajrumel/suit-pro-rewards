import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:suit_pro_rewards_flutter/screens/app/components/bottom_nav.dart';
import 'package:suit_pro_rewards_flutter/providers/user_provider.dart';
import 'package:suit_pro_rewards_flutter/themes/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class MemberLayout extends ConsumerStatefulWidget {
  final Widget child;

  const MemberLayout({super.key, required this.child});

  @override
  ConsumerState<MemberLayout> createState() => _MemberLayoutState();
}

class _MemberLayoutState extends ConsumerState<MemberLayout> {
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/wallet')) return 1;
    if (location.startsWith('/shop')) return 2;
    if (location.startsWith('/profile')) return 3;
    if (location.startsWith('/admin')) return 4;
    return 0;
  }

  void _onItemTapped(int index, bool isAdmin) {
    int moreIndex = isAdmin ? 5 : 4;
    int adminIndex = 4;

    if (index == moreIndex) {
      _showMoreMenu(isAdmin);
      return;
    }

    if (isAdmin && index == adminIndex) {
      context.go('/admin');
      return;
    }

    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/wallet');
        break;
      case 2:
        context.go('/shop');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  void _showMoreMenu(bool isAdmin) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          width: double.infinity,
          margin: EdgeInsets.all(24.w),
          padding: EdgeInsets.fromLTRB(32.w, 32.h, 32.w, 40.h),
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(40.r),
            border: Border.all(color: AppTheme.gold.withValues(alpha: 0.15)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppTheme.gold,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Discover More',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(LucideIcons.x, size: 20.sp),
                    style: IconButton.styleFrom(
                      backgroundColor: AppTheme.secondary,
                      foregroundColor: AppTheme.mutedForeground,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),
              _buildMenuItem(
                label: 'Visit Website',
                icon: LucideIcons.globe,
                color: Colors.blue,
                onTap: () => _launchURL('https://suitprolondon.com'),
              ),
              _buildMenuItem(
                label: 'Refer a Friend',
                icon: LucideIcons.share2,
                color: AppTheme.gold,
                onTap: () {
                  Navigator.pop(context);
                  context.go('/referral');
                },
              ),
              _buildMenuItem(
                label: 'Concierge Support',
                icon: LucideIcons.messageSquare,
                color: Colors.purple,
                onTap: () {
                  Navigator.pop(context);
                  context.go('/support');
                },
              ),
              _buildMenuItem(
                label: 'Privacy Policy',
                icon: LucideIcons.shield,
                color: AppTheme.mutedForeground,
                onTap: () {
                  Navigator.pop(context);
                  context.go('/privacy');
                },
              ),
              if (isAdmin) ...[
                SizedBox(height: 12.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      context.go('/admin');
                    },
                    icon: const Icon(LucideIcons.settings, size: 16),
                    label: const Text('GO TO ADMIN CONSOLE'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 18.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                    ),
                  ),
                ),
              ],
              SizedBox(height: 16.h),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => FirebaseAuth.instance.signOut(),
                  icon: const Icon(LucideIcons.logOut, size: 16),
                  label: const Text('SIGN OUT FROM APP'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.2)),
                    padding: EdgeInsets.symmetric(vertical: 18.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                  ),
                ),
              ),
              SizedBox(height: 32.h),
              Text(
                'SUIT PRO REWARDS • VERSION 1.1.0',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontSize: 8.sp,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 3,
                      color: AppTheme.mutedForeground.withValues(alpha: 0.4),
                    ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItem({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppTheme.secondary.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppTheme.gold.withValues(alpha: 0.05)),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: color, size: 16.sp),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                ),
              ),
              Icon(LucideIcons.chevronRight, size: 16.sp, color: Colors.white.withValues(alpha: 0.2)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);
    final isAdmin = userAsync.asData?.value?.role == 'admin';

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNav(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, isAdmin),
        isAdmin: isAdmin,
      ),
    );
  }
}
