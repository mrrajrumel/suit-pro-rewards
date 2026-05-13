import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suit_pro_rewards_flutter/providers/user_provider.dart';
import 'package:suit_pro_rewards_flutter/providers/wallet_view_model.dart';
import 'package:suit_pro_rewards_flutter/screens/app/components/points_card.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:go_router/go_router.dart';

class UserDashboardScreen extends ConsumerWidget {
  const UserDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final ordersAsync = ref.watch(walletViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Dashboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) return const Center(child: Text("User not found."));
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // Ensures children take full width
              children: [
                Text('Welcome, ${user.fullName}', style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text('Tier: ${user.role.toUpperCase()}', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                
                const PointsCard(), // Your existing points card
                
                const SizedBox(height: 24),
                Text('Order Summary', style: Theme.of(context).textTheme.titleLarge),
                const Divider(),
                
                ordersAsync.when(
                  data: (orders) => ListTile(
                    leading: const Icon(LucideIcons.shoppingCart),
                    title: const Text('Total Orders'),
                    trailing: Text(orders.length.toString(), style: Theme.of(context).textTheme.headlineSmall),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, st) => const ListTile(title: Text('Could not load orders')),
                ),

                const SizedBox(height: 24),
                Text('Quick Actions', style: Theme.of(context).textTheme.titleLarge),
                const Divider(),
                
                ListTile(
                  leading: const Icon(LucideIcons.wallet),
                  title: const Text('View My Orders & Vouchers'),
                  trailing: const Icon(LucideIcons.chevronRight),
                  onTap: () => context.go('/wallet'),
                ),
                ListTile(
                  leading: const Icon(LucideIcons.user),
                  title: const Text('Manage My Profile'),
                  trailing: const Icon(LucideIcons.chevronRight),
                  onTap: () => context.go('/profile'),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
