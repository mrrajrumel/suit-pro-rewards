import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suit_pro_rewards_flutter/providers/user_provider.dart';
import 'package:suit_pro_rewards_flutter/providers/wallet_view_model.dart';
import 'package:suit_pro_rewards_flutter/screens/app/components/points_card.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:suit_pro_rewards_flutter/themes/app_theme.dart';
import 'package:suit_pro_rewards_flutter/widgets/logo.dart';

class UserDashboardScreen extends ConsumerWidget {
  const UserDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: userAsync.when(
            data: (user) {
              if (user == null) return const Center(child: Text("User not found."));
              return ListView( // Use ListView for better scrolling on all screen sizes
                padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: _buildHeader(context),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome,',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          user.fullName.split(' ')[0], // Get first name
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppTheme.gold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              '${user.role.toUpperCase()} Tier Status',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: AppTheme.gold.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Exclusive Benefits Active',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.gold,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                   Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: const PointsCard(),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: _buildQuickActions(context),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('Error: $e')),
          ),
        ),
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Logo(size: 30),
        Row(
          children: [
            _buildHeaderButton(icon: LucideIcons.qrCode, onTap: () {}),
            const SizedBox(width: 12),
            _buildHeaderButton(icon: LucideIcons.refreshCw, onTap: () {}),
            const SizedBox(width: 12),
            _buildHeaderButton(icon: LucideIcons.bell, onTap: () {}),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.card,
          shape: BoxShape.circle,
          border: Border.all(color: AppTheme.border.withOpacity(0.5)),
        ),
        child: Icon(icon, color: AppTheme.mutedForeground, size: 20),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildActionItem(context, icon: LucideIcons.qrCode, label: 'Scan', path: '/scan-receipt'),
        _buildActionItem(context, icon: LucideIcons.wallet, label: 'Wallet', path: '/wallet'),
        _buildActionItem(context, icon: LucideIcons.gift, label: 'Rewards', path: '/rewards'),
        _buildActionItem(context, icon: LucideIcons.shoppingBag, label: 'Shop', path: '/shop'),
        _buildActionItem(context, icon: LucideIcons.share2, label: 'Refer', path: '/referral'),
        _buildActionItem(context, icon: LucideIcons.history, label: 'History', path: '/notifications'),
      ],
    );
  }

  Widget _buildActionItem(BuildContext context, {required IconData icon, required String label, required String path}) {
    return GestureDetector(
      onTap: () => context.go(path),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56, // 14 * 4
            height: 56,
            decoration: BoxDecoration(
              color: AppTheme.card,
              borderRadius: BorderRadius.circular(20), // rounded-2xl
              border: Border.all(color: AppTheme.border.withOpacity(0.5)),
              boxShadow: [
                 BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            ),
            child: Icon(icon, color: AppTheme.mutedForeground, size: 24),
          ),
          const SizedBox(height: 8),
          Text(label.toUpperCase(), style: Theme.of(context).textTheme.bodySmall?.copyWith(letterSpacing: 1)),
        ],
      ),
    );
  }
}
