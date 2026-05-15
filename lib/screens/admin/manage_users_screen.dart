import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suit_pro_rewards_flutter/providers/admin/user_list_view_model.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:suit_pro_rewards_flutter/themes/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManageUsersScreen extends ConsumerStatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  ConsumerState<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends ConsumerState<ManageUsersScreen> {
  String _roleFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final userListAsync = ref.watch(userListProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Manage Members'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search by name or email...',
                    prefixIcon: Icon(LucideIcons.search),
                  ),
                  onChanged: (query) {
                    ref.read(userListProvider.notifier).filterUsers(query);
                  },
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    _buildFilterChip('all', 'All Members'),
                    SizedBox(width: 8.w),
                    _buildFilterChip('admin', 'Staff'),
                    SizedBox(width: 8.w),
                    _buildFilterChip('user', 'Patrons'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: userListAsync.when(
              data: (users) {
                final filteredUsers = _roleFilter == 'all' 
                    ? users 
                    : users.where((u) => u.role == _roleFilter).toList();

                if (filteredUsers.isEmpty) {
                  return const Center(child: Text('No matching members found.', style: TextStyle(color: AppTheme.mutedForeground)));
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
                    return Card(
                      color: AppTheme.secondary,
                      margin: EdgeInsets.only(bottom: 8.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        title: Text(user.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(user.email, style: const TextStyle(color: AppTheme.mutedForeground, fontSize: 12)),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: user.role == 'admin' ? AppTheme.gold.withValues(alpha: 0.1) : Colors.white10,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            user.role.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: user.role == 'admin' ? AppTheme.gold : Colors.white70,
                            ),
                          ),
                        ),
                        onTap: () {
                          context.go('/admin/users/edit', extra: user);
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.gold)),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String role, String label) {
    final bool isSelected = _roleFilter == role;
    return GestureDetector(
      onTap: () => setState(() => _roleFilter = role),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.gold : AppTheme.secondary,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: isSelected ? AppTheme.gold : AppTheme.gold.withValues(alpha: 0.2)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontSize: 10.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
