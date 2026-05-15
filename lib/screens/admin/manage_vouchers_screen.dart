import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:suit_pro_rewards_flutter/themes/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ManageVouchersScreen extends ConsumerStatefulWidget {
  const ManageVouchersScreen({super.key});

  @override
  ConsumerState<ManageVouchersScreen> createState() => _ManageVouchersScreenState();
}

class _ManageVouchersScreenState extends ConsumerState<ManageVouchersScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  void _addVoucher() {
    showDialog(
      context: context,
      builder: (ctx) {
        final titleController = TextEditingController();
        final codeController = TextEditingController();
        final pointsController = TextEditingController();
        final discountController = TextEditingController();
        
        return AlertDialog(
          backgroundColor: AppTheme.card,
          title: const Text('Create Master Voucher', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'Voucher Title'),
                ),
                SizedBox(height: 12.h),
                TextField(
                  controller: codeController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'Promo Code (Base)'),
                ),
                SizedBox(height: 12.h),
                TextField(
                  controller: pointsController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'Points Required'),
                ),
                SizedBox(height: 12.h),
                TextField(
                  controller: discountController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'Discount %'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isEmpty) return;
                
                await FirebaseFirestore.instance.collection('master_vouchers').add({
                  'title': titleController.text.trim(),
                  'code_base': codeController.text.trim().toUpperCase(),
                  'points_required': int.tryParse(pointsController.text) ?? 1000,
                  'discount_percentage': int.tryParse(discountController.text) ?? 10,
                  'active': true,
                  'created_at': FieldValue.serverTimestamp(),
                });
                
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Voucher System'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search issued vouchers...',
                prefixIcon: Icon(LucideIcons.search),
              ),
              onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('RECENTLY ISSUED', style: TextStyle(color: AppTheme.gold, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                TextButton(
                  onPressed: () {
                    // TODO: Show master vouchers list
                  },
                  child: const Text('VIEW MASTER LIST', style: TextStyle(fontSize: 10)),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('vouchers').orderBy('created_at', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: AppTheme.gold));
                
                final vouchers = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return data['title'].toString().toLowerCase().contains(_searchQuery) ||
                         data['code'].toString().toLowerCase().contains(_searchQuery);
                }).toList();

                if (vouchers.isEmpty) return const Center(child: Text('No vouchers found.', style: TextStyle(color: AppTheme.mutedForeground)));

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: vouchers.length,
                  itemBuilder: (context, index) {
                    final data = vouchers[index].data() as Map<String, dynamic>;
                    final expiresAt = (data['expires_at'] as Timestamp?)?.toDate();
                    
                    return Card(
                      color: AppTheme.secondary,
                      margin: EdgeInsets.only(bottom: 12.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.w),
                        leading: Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(color: AppTheme.gold.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12.r)),
                          child: const Icon(LucideIcons.ticket, color: AppTheme.gold),
                        ),
                        title: Text(data['title'] ?? 'Voucher', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('CODE: ${data['code']}', style: const TextStyle(fontFamily: 'monospace', color: AppTheme.gold)),
                            if (expiresAt != null) 
                              Text('Expires: ${DateFormat('dd MMM yyyy').format(expiresAt)}', style: const TextStyle(fontSize: 10, color: AppTheme.mutedForeground)),
                          ],
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: data['status'] == 'active' ? Colors.green.withValues(alpha: 0.1) : Colors.redAccent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            data['status']?.toString().toUpperCase() ?? 'INACTIVE',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: data['status'] == 'active' ? Colors.green : Colors.redAccent,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addVoucher,
        backgroundColor: AppTheme.gold,
        tooltip: 'Create Master Voucher',
        child: const Icon(LucideIcons.plus, color: Colors.black),
      ),
    );
  }
}
