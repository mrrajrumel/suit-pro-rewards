import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:suit_pro_rewards_flutter/providers/dashboard_view_model.dart';
import 'package:suit_pro_rewards_flutter/screens/app/components/points_card.dart';
import 'package:suit_pro_rewards_flutter/widgets/logo.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildGreeting(),
                const SizedBox(height: 24),
                // Tier Progress (Placeholder)
                Container(
                  height: 100,
                  color: Colors.grey[800],
                  child: const Center(child: Text('Tier Progress - Coming Soon')),
                ),
                const SizedBox(height: 24),
                const PointsCard(),
                const SizedBox(height: 24),
                _buildQuickActions(context),
                const SizedBox(height: 24),
                dashboardState.activities.when(
                  data: (activities) => Column(
                    children: activities
                        .map((activity) => Text(activity.description))
                        .toList(),
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stackTrace) => Text('Error: $error'),
                ),
              ],
            ),
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
            IconButton(
              onPressed: () {},
              icon: const Icon(LucideIcons.qrCode),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(LucideIcons.refreshCw),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(LucideIcons.bell),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome, Member',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Silver Tier Status',
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {'icon': LucideIcons.qrCode, 'label': 'Scan'},
      {'icon': LucideIcons.wallet, 'label': 'Wallet'},
      {'icon': LucideIcons.gift, 'label': 'Rewards'},
      {'icon': LucideIcons.shoppingBag, 'label': 'Shop'},
      {'icon': LucideIcons.share2, 'label': 'Refer'},
      {'icon': LucideIcons.clock, 'label': 'History'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return Column(
          children: [
            CircleAvatar(
              radius: 30,
              child: Icon(action['icon'] as IconData),
            ),
            const SizedBox(height: 8),
            Text(action['label'] as String),
          ],
        );
      },
    );
  }
}
