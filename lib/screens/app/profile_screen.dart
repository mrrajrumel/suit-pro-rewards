import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suit_pro_rewards_flutter/providers/user_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('User not found.'));
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(LucideIcons.user),
                  title: const Text('Full Name'),
                  subtitle: Text(user.fullName, style: const TextStyle(fontSize: 16)),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(LucideIcons.mail),
                  title: const Text('Email'),
                  subtitle: Text(user.email, style: const TextStyle(fontSize: 16)),
                ),
                const Divider(),
                 ListTile(
                  leading: const Icon(LucideIcons.shield),
                  title: const Text('Role'),
                  subtitle: Text(user.role.toUpperCase(), style: const TextStyle(fontSize: 16)),
                ),
                if (user.role == 'admin') ... [
                  const Divider(),
                  ListTile(
                    leading: const Icon(LucideIcons.userCog),
                    title: const Text('Admin Panel'),
                    trailing: const Icon(LucideIcons.chevronRight),
                    onTap: () {
                      context.go('/admin');
                    },
                  ),
                ],
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {
                    context.go('/profile/edit');
                  },
                  icon: const Icon(LucideIcons.edit),
                  label: const Text('Edit Profile'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
