import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:suit_pro_rewards_flutter/themes/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManageProductsScreen extends ConsumerStatefulWidget {
  const ManageProductsScreen({super.key});

  @override
  ConsumerState<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends ConsumerState<ManageProductsScreen> {
  String _searchQuery = '';
  String _categoryFilter = 'all';

  final List<String> _categories = ['all', 'Suits', 'Shirts', 'Accessories', 'Shoes'];

  void _addProduct() {
    showDialog(
      context: context,
      builder: (ctx) {
        final nameController = TextEditingController();
        final priceController = TextEditingController();
        String selectedCategory = _categories[1]; // Default to first non-'all' category
        
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppTheme.card,
              title: const Text('Add Product', style: TextStyle(color: Colors.white)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'Product Name'),
                  ),
                  SizedBox(height: 12.h),
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'Price (£)'),
                  ),
                  SizedBox(height: 12.h),
                  DropdownButtonFormField<String>(
                    initialValue: selectedCategory,
                    dropdownColor: AppTheme.card,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: _categories.where((c) => c != 'all').map((cat) {
                      return DropdownMenuItem(value: cat, child: Text(cat));
                    }).toList(),
                    onChanged: (v) => setDialogState(() => selectedCategory = v!),
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isEmpty) return;
                    
                    await FirebaseFirestore.instance.collection('custom_products').add({
                      'name': nameController.text.trim(),
                      'price': double.tryParse(priceController.text) ?? 0.0,
                      'category': selectedCategory,
                      'created_at': FieldValue.serverTimestamp(),
                    });
                    
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Product Inventory'),
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
                    hintText: 'Search products...',
                    prefixIcon: Icon(LucideIcons.search),
                  ),
                  onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
                ),
                SizedBox(height: 12.h),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((cat) => _buildCategoryChip(cat)).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('custom_products').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: AppTheme.gold));
                
                final products = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final matchesSearch = data['name'].toString().toLowerCase().contains(_searchQuery);
                  final matchesCategory = _categoryFilter == 'all' || data['category'] == _categoryFilter;
                  return matchesSearch && matchesCategory;
                }).toList();

                if (products.isEmpty) return const Center(child: Text('No matching products found.', style: TextStyle(color: AppTheme.mutedForeground)));

                return GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final data = products[index].data() as Map<String, dynamic>;
                    return Card(
                      color: AppTheme.secondary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppTheme.gold.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                              ),
                              child: const Icon(LucideIcons.package, color: AppTheme.gold, size: 40),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(12.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data['name'] ?? 'Product', style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                                SizedBox(height: 4.h),
                                Text('£${data['price']}', style: const TextStyle(color: AppTheme.gold, fontWeight: FontWeight.w900)),
                                SizedBox(height: 4.h),
                                Text(data['category'] ?? 'General', style: const TextStyle(color: AppTheme.mutedForeground, fontSize: 10)),
                              ],
                            ),
                          ),
                        ],
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
        onPressed: _addProduct,
        backgroundColor: AppTheme.gold,
        child: const Icon(LucideIcons.plus, color: Colors.black),
      ),
    );
  }

  Widget _buildCategoryChip(String cat) {
    final bool isSelected = _categoryFilter == cat;
    return GestureDetector(
      onTap: () => setState(() => _categoryFilter = cat),
      child: Container(
        margin: EdgeInsets.only(right: 8.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.gold : AppTheme.secondary,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: isSelected ? AppTheme.gold : AppTheme.gold.withValues(alpha: 0.2)),
        ),
        child: Text(
          cat.toUpperCase(),
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
