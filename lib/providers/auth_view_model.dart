import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suit_pro_rewards_flutter/services/auth_repository.dart';
import 'package:suit_pro_rewards_flutter/services/suitpro_service.dart';
import 'package:suit_pro_rewards_flutter/providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';

class AuthViewModel extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _authRepository;
  final SuitProService _suitProService;

  AuthViewModel(this._authRepository, this._suitProService)
      : super(const AsyncValue.data(null));

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      // 1. PRIMARY AUTH: TRY SUITPRO WEBSITE FIRST
      Response? spRes;
      try {
        spRes = await _suitProService.login(email, password);
        
        if (spRes.statusCode == 200) {
          final token = spRes.data?['token'];
          if (token != null) {
            setSuitProToken(token);
          }
        } else if (spRes.statusCode == 422) {
           final message = spRes.data?['message'] ?? 'Validation failed on website';
           // We don't throw here to allow Firebase fallback, 
           // but we could log it or handle it.
           debugPrint('SuitPro Login 422: $message');
        }
      } catch (e) {
        debugPrint('SuitPro Login Error: $e');
      }

      // 2. FIREBASE SIGN IN
      final userCredential = await _authRepository.signInWithEmailAndPassword(email, password);
      final user = userCredential.user;

      if (user == null) {
        throw Exception("Firebase login failed.");
      }

      // 3. ROLE & DATA SYNC
      if (spRes?.data != null) {
        final meRes = await _suitProService.getMe();
        final websiteData = meRes.data?['data'];
        if (websiteData != null) {
          // Sync website data to firestore
          await _authRepository.updateUserFirestore(
            uid: user.uid,
            data: {
              'full_name': websiteData['name'] ?? user.displayName ?? 'Distinguished Member',
              'email': user.email,
              'suitpro_id': websiteData['id'],
              'role': (websiteData['is_admin'] == true) ? 'admin' : 'user', // Simplified role logic
              'synced_at': FieldValue.serverTimestamp(),
            }
          );
        }
      }

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password, String fullName) async {
    state = const AsyncValue.loading();
    try {
      // Attempt to register on the external website first
      try {
        await _suitProService.register(fullName, email, password);
      } catch (e) {
        // As in the original app, we ignore this error and proceed
      }
      
      // Create the user in Firebase Auth
      final userCredential = await _authRepository.createUserWithEmailAndPassword(email, password);
      final user = userCredential.user;

      if (user == null) {
        throw Exception("Firebase registration failed.");
      }

      // Update the Firebase user's display name
      await user.updateDisplayName(fullName);
      
      // Create the user's document in Firestore with their full details
      await _authRepository.updateUserFirestore(
        uid: user.uid,
        data: {
          'full_name': fullName,
          'email': email,
          'role': 'user',
          'tier': 'Silver',
          'points': 0,
          'created_at': FieldValue.serverTimestamp(),
        }
      );

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AsyncValue<void>>((ref) {
  return AuthViewModel(
    ref.watch(authRepositoryProvider),
    ref.watch(suitProServiceProvider),
  );
});
