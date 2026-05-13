import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suit_pro_rewards_flutter/services/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final userEditViewModelProvider = StateNotifierProvider.autoDispose.family<UserEditViewModel, AsyncValue<void>, String>((ref, userId) {
  return UserEditViewModel(ref.watch(authRepositoryProvider), userId);
});

class UserEditViewModel extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _authRepository;
  final String _userId;

  UserEditViewModel(this._authRepository, this._userId) : super(const AsyncData(null));

  Future<void> updateUserRole(String newRole) async {
    state = const AsyncLoading();
    try {
      await _authRepository.updateUserFirestore(
        uid: _userId,
        data: {'role': newRole},
      );
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> addPoints(int amount) async {
    state = const AsyncLoading();
    try {
      await _authRepository.updateUserFirestore(
        uid: _userId,
        data: {'points': FieldValue.increment(amount)},
      );
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
