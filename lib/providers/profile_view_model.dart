import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suit_pro_rewards_flutter/providers/auth_provider.dart';
import 'package:suit_pro_rewards_flutter/services/auth_repository.dart';
import 'package:suit_pro_rewards_flutter/services/suitpro_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:suit_pro_rewards_flutter/providers/user_provider.dart';

final profileViewModelProvider =
    StateNotifierProvider<ProfileViewModel, AsyncValue<void>>((ref) {
  return ProfileViewModel(
    ref.watch(authRepositoryProvider),
    ref.watch(suitProServiceProvider),
    ref.watch(userProvider).asData?.value?.uid,
    ref.watch(userProvider).asData?.value?.suitproId,
  );
});

class ProfileViewModel extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _authRepository;
  final SuitProService _suitProService;
  final String? _uid;
  final String? _suitproId;

  ProfileViewModel(this._authRepository, this._suitProService, this._uid, this._suitproId)
      : super(const AsyncData(null));

  Future<void> updateProfile({required String fullName}) async {
    if (_uid == null) return;
    state = const AsyncLoading();
    try {
      // Update Firebase Auth
      await FirebaseAuth.instance.currentUser?.updateDisplayName(fullName);

      // Update Firestore
      await _authRepository.updateUserFirestore(
        uid: _uid!,
        data: {'full_name': fullName},
      );

      // Update Web API if user is linked
      if (_suitproId != null) {
        // NOTE: The API documentation does not specify an endpoint for updating user profiles.
        // I am using a placeholder PUT request to '/api/v1/profile'.
        // Please update this with the correct endpoint.
        await _suitProService.updateProfile(_suitproId!, {'name': fullName});
      }

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
