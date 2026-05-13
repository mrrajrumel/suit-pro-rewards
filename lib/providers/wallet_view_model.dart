import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suit_pro_rewards_flutter/models/app/order.dart';
import 'package:suit_pro_rewards_flutter/services/suitpro_service.dart';

final walletViewModelProvider = FutureProvider<List<Order>>((ref) async {
  final suitProService = ref.watch(suitProServiceProvider);
  final response = await suitProService.getOrders();

  if (response.data != null && response.data['data'] is List) {
    final List<dynamic> orderData = response.data['data'];
    return orderData.map((data) => Order.fromJson(data)).toList();
  } else {
    return [];
  }
});
