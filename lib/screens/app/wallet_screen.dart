import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suit_pro_rewards_flutter/providers/wallet_view_model.dart';
import 'package:suit_pro_rewards_flutter/providers/vouchers_provider.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Wallet'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Order History'),
              Tab(text: 'My Vouchers'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            OrderHistoryView(),
            VouchersView(),
          ],
        ),
      ),
    );
  }
}

class OrderHistoryView extends ConsumerWidget {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(walletViewModelProvider);
    return ordersAsync.when(
      data: (orders) {
        if (orders.isEmpty) {
          return const Center(child: Text('You have no past orders.'));
        }
        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: const Icon(LucideIcons.receipt),
                title: Text('Order #${order.id}'),
                subtitle: Text('Placed on: ${order.placedAt}'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(order.total, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(order.status, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error fetching orders: $err')),
    );
  }
}

class VouchersView extends ConsumerWidget {
  const VouchersView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vouchersAsync = ref.watch(vouchersProvider);
    return vouchersAsync.when(
      data: (vouchers) {
        if (vouchers.isEmpty) {
          return const Center(child: Text('You have no active vouchers.'));
        }
        return ListView.builder(
          itemCount: vouchers.length,
          itemBuilder: (context, index) {
            final voucher = vouchers[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: const Icon(LucideIcons.ticket),
                title: Text(voucher.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Expires: ${DateFormat.yMMMd().format(voucher.expiresAt)}'),
                trailing: const Icon(LucideIcons.chevronRight),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => VoucherDetailDialog(voucher: voucher),
                  );
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error fetching vouchers: $err')),
    );
  }
}

class VoucherDetailDialog extends StatelessWidget {
  final dynamic voucher;

  const VoucherDetailDialog({super.key, required this.voucher});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(voucher.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            QrImageView(
              data: voucher.qrData,
              version: QrVersions.auto,
              size: 200.0,
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 16),
            Text('Coupon Code: ${voucher.code}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(voucher.description),
            const SizedBox(height: 24),
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }
}
