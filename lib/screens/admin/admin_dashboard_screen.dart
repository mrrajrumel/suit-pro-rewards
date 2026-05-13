import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: Center(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(LucideIcons.users),
              title: const Text('Manage Users'),
              trailing: const Icon(LucideIcons.chevronRight),
              onTap: () {
                context.go('/admin/users');
              },
            ),
            // Add other admin options here (Vouchers, Orders, etc.)
          ],
        ),
      ),
    );
  }
}
