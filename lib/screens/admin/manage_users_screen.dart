import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suit_pro_rewards_flutter/providers/admin/user_list_view_model.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:go_router/go_router.dart';

class ManageUsersScreen extends ConsumerWidget {
  const ManageUsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userListAsync = ref.watch(userListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search by name or email...',
                prefixIcon: Icon(LucideIcons.search),
              ),
              onChanged: (query) {
                ref.read(userListProvider.notifier).filterUsers(query);
              },
            ),
          ),
          // Add sorting UI here if needed
          Expanded(
            child: userListAsync.when(
              data: (users) {
                if (users.isEmpty) {
                  return const Center(child: Text('No users found.'));
                }
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      title: Text(user.fullName),
                      subtitle: Text(user.email),
                      trailing: Text(user.role.toUpperCase()),
                      onTap: () {
                        context.go('/admin/users/edit', extra: user);
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
