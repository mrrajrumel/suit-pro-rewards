import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suit_pro_rewards_flutter/models/app/voucher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:suit_pro_rewards_flutter/providers/auth_provider.dart';

final vouchersProvider = StreamProvider<List<Voucher>>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  final user = authState.asData?.value;

  if (user == null) {
    return Stream.value([]);
  }

  // Assumes you have a 'vouchers' collection where each document
  // has a 'member_id' field linking it to a user.
  return FirebaseFirestore.instance
      .collection('vouchers')
      .where('member_id', isEqualTo: user.uid)
      .where('expires_at', isGreaterThan: Timestamp.now())
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Voucher.fromFirestore(doc)).toList());
});
