import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suit_pro_rewards_flutter/models/app/activity.dart';
import 'package:suit_pro_rewards_flutter/services/suitpro_service.dart';

class DashboardRepository {
  final FirebaseFirestore _firestore;
  final SuitProService _suitProService;

  DashboardRepository(this._firestore, this._suitProService);

  Stream<List<Activity>> getActivities(String userId) {
    return _firestore
        .collection('transactions')
        .where('member_id', isEqualTo: userId)
        .orderBy('created_at', descending: true)
        .limit(5)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Activity.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  Future<dynamic> getLoyaltySummary() async {
    return await _suitProService.getLoyaltySummary();
  }

  Future<dynamic> getFlashSales() async {
    return await _suitProService.getFlashSales();
  }
}

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(
    FirebaseFirestore.instance,
    ref.watch(suitProServiceProvider),
  );
});
