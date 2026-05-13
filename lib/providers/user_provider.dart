import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suit_pro_rewards_flutter/models/app/user.dart';
import 'package:suit_pro_rewards_flutter/providers/auth_provider.dart';

final userProvider = StreamProvider<AppUser?>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  final user = authState.asData?.value;

  if (user == null) {
    return Stream.value(null);
  }

  final docRef = FirebaseFirestore.instance.collection('members').doc(user.uid);
  return docRef.snapshots().map((snapshot) {
    if (snapshot.exists) {
      return AppUser.fromFirestore(snapshot.data()!, snapshot.id);
    }
    return null;
  });
});
