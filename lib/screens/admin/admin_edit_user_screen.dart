import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:suit_pro_rewards_flutter/models/app/user.dart';
import 'package:suit_pro_rewards_flutter/providers/admin/user_edit_view_model.dart';
import 'package:flutter/services.dart';

class AdminEditUserScreen extends ConsumerStatefulWidget {
  final AppUser user;
  const AdminEditUserScreen({super.key, required this.user});

  @override
  ConsumerState<AdminEditUserScreen> createState() => _AdminEditUserScreenState();
}

class _AdminEditUserScreenState extends ConsumerState<AdminEditUserScreen> {
  late String _selectedRole;
  final List<String> _roles = ['user', 'admin'];

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.user.role;
  }

  void _addPoints() {
    // Show a dialog to get the amount of points to add
    showDialog(
      context: context,
      builder: (ctx) {
        final pointsController = TextEditingController();
        return AlertDialog(
          title: const Text('Add Points'),
          content: TextField(
            controller: pointsController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(labelText: 'Points to Add'),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                final amount = int.tryParse(pointsController.text);
                if (amount != null) {
                  ref.read(userEditViewModelProvider(widget.user.uid).notifier).addPoints(amount);
                  Navigator.of(ctx).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _saveChanges() {
    ref.read(userEditViewModelProvider(widget.user.uid).notifier).updateUserRole(_selectedRole);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(userEditViewModelProvider(widget.user.uid), (_, state) {
      if (state is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${state.error}')));
      } else if (state is AsyncData) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User role updated successfully!')));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.user.fullName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: const Text('Current Points'),
              trailing: Text(widget.user.points.toString(), style: Theme.of(context).textTheme.headlineSmall),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _addPoints,
              icon: const Icon(LucideIcons.plus),
              label: const Text('Add Points'),
            ),
            const Divider(height: 40),
            DropdownButtonFormField<String>(
              initialValue: _selectedRole,
              items: _roles.map((String role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role.toUpperCase()),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedRole = newValue!;
                });
              },
              decoration: const InputDecoration(labelText: 'User Role'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
