import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:suit_pro_rewards_flutter/models/app/user.dart';
import 'dart:async';

enum UserSortOption { name, joinDate }

final userListProvider = StateNotifierProvider.autoDispose<UserListViewModel, AsyncValue<List<AppUser>>>((ref) {
  return UserListViewModel();
});

class UserListViewModel extends StateNotifier<AsyncValue<List<AppUser>>> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<AppUser> _allUsers = [];
  StreamSubscription? _subscription;

  UserListViewModel() : super(const AsyncLoading()) {
    _fetchUsers();
  }

  void _fetchUsers() {
    _subscription?.cancel();
    _subscription = _firestore.collection('members').snapshots().listen((snapshot) {
      _allUsers = snapshot.docs.map((doc) => AppUser.fromFirestore(doc.data(), doc.id)).toList();
      state = AsyncData(_allUsers);
    })..onError((error) {
      state = AsyncError(error, StackTrace.current);
    });
  }

  void filterUsers(String query) {
    if (query.isEmpty) {
      state = AsyncData(_allUsers);
    } else {
      final filteredUsers = _allUsers.where((user) {
        return user.fullName.toLowerCase().contains(query.toLowerCase()) ||
               user.email.toLowerCase().contains(query.toLowerCase());
      }).toList();
      state = AsyncData(filteredUsers);
    }
  }

  void sortUsers(UserSortOption option) {
    final sortedUsers = List<AppUser>.from(state.asData?.value ?? []);
    if (option == UserSortOption.name) {
      sortedUsers.sort((a, b) => a.fullName.compareTo(b.fullName));
    }
    // Add sorting by joinDate if a timestamp is available in your model
    state = AsyncData(sortedUsers);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
