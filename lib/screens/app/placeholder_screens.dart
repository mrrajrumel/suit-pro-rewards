import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:suit_pro_rewards_flutter/themes/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppTheme.gold),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/dashboard');
            }
          },
        ),
        title: Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 20.sp)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.construction, size: 64.sp, color: AppTheme.gold.withValues(alpha: 0.2)),
            SizedBox(height: 16.h),
            Text('$title Coming Soon', style: TextStyle(color: AppTheme.mutedForeground, fontSize: 16.sp, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }
}

class ShopScreen extends StatelessWidget { const ShopScreen({super.key}); @override Widget build(BuildContext context) => const PlaceholderScreen(title: 'Shop'); }
class ScanReceiptScreen extends StatelessWidget { const ScanReceiptScreen({super.key}); @override Widget build(BuildContext context) => const PlaceholderScreen(title: 'Scan Receipt'); }
class NotificationsScreen extends StatelessWidget { const NotificationsScreen({super.key}); @override Widget build(BuildContext context) => const PlaceholderScreen(title: 'Notifications'); }
class WebsiteLinkScreen extends StatelessWidget { const WebsiteLinkScreen({super.key}); @override Widget build(BuildContext context) => const PlaceholderScreen(title: 'Connect Website'); }
class SupportScreen extends StatelessWidget { const SupportScreen({super.key}); @override Widget build(BuildContext context) => const PlaceholderScreen(title: 'Support'); }
class PrivacyScreen extends StatelessWidget { const PrivacyScreen({super.key}); @override Widget build(BuildContext context) => const PlaceholderScreen(title: 'Privacy Policy'); }
