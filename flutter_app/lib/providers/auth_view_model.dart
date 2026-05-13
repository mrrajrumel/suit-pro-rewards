import 'dart:async';
import 'dart:developer' as developer;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/suit_pro_service.dart';
import '../repository/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({required this._authRepository});

  final AuthRepository _authRepository;

  String? _userId;
  String? _userEmail;
  String? _userPhone;
  String? _userRole;
  String? _userStatus;
  String? _userAvatar;

  bool _isAuthenticated = false;
  bool _isLoading = false;

  AsyncValue<AuthState> _state = AsyncValue.initial();

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      // TODO: Implement the complex login logic from the React Native app.
      // This includes:
      // 1. Trying to log in to the Suit Pro website first.
      // 2. If website login is successful but Firebase fails, auto-registering the user in Firebase.
      // 3. Syncing user roles and data from the website to Firestore.
      try {
        await _suitProService.login(email, password);
      } catch (e) {
        // This is expected if the user is not on the main website.
        // The original app ignored this error and proceeded with Firebase auth.
      }
      await _authRepository.signInWithEmailAndPassword(email, password);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    state = const AsyncValue.loading();
    try {
      await _authRepository.createUserWithEmailAndPassword(email, password);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _authRepository.signOut();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateProfile({
    String? name,
    String? phone,
    String? role,
    String? status,
    String? avatar,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _authRepository.updateProfile(
        name: name,
        phone: phone,
        role: role,
        status: status,
        avatar: avatar,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  String? get userId => _userId;
  String? get userEmail => _userEmail;
  String? get userPhone => _userPhone;
  String? get userRole => _userRole;
  String? get userStatus => _userStatus;
  String? get userAvatar => _userAvatar;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;

  AsyncValue<AuthState> get state => _state;

  void notifyListeners() {
    super.notifyListeners();
  }
}

class AuthState {
  AuthState({
    required this.userId,
    required this.userEmail,
    required this.userPhone,
    required this.userRole,
    required this.userStatus,
    required this.userAvatar,
  });

  String userId;
  String userEmail;
  String userPhone;
  String userRole;
  String userStatus;
  String userAvatar;
}