import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suit_pro_rewards_flutter/providers/auth_provider.dart';
import 'package:suit_pro_rewards_flutter/models/app/activity.dart';
import 'package:suit_pro_rewards_flutter/models/app/flash_sale.dart';
import 'package:suit_pro_rewards_flutter/models/app/web_stats.dart';
import 'package:suit_pro_rewards_flutter/services/dashboard_repository.dart';

class DashboardState {
  final AsyncValue<List<Activity>> activities;
  final AsyncValue<List<FlashSale>> flashSales;
  final AsyncValue<WebStats> webStats;

  DashboardState({
    this.activities = const AsyncValue.loading(),
    this.flashSales = const AsyncValue.loading(),
    this.webStats = const AsyncValue.loading(),
  });

  DashboardState copyWith({
    AsyncValue<List<Activity>>? activities,
    AsyncValue<List<FlashSale>>? flashSales,
    AsyncValue<WebStats>? webStats,
  }) {
    return DashboardState(
      activities: activities ?? this.activities,
      flashSales: flashSales ?? this.flashSales,
      webStats: webStats ?? this.webStats,
    );
  }
}

class DashboardViewModel extends StateNotifier<DashboardState> {
  final DashboardRepository _dashboardRepository;
  final String _userId;

  DashboardViewModel(this._dashboardRepository, this._userId)
      : super(DashboardState()) {
    _init();
  }

  void _init() {
    _dashboardRepository.getActivities(_userId).listen((activities) {
      state = state.copyWith(activities: AsyncValue.data(activities));
    });
    _dashboardRepository.getLoyaltySummary().then((webStats) {
      state = state.copyWith(webStats: AsyncValue.data(webStats));
    });
    _dashboardRepository.getFlashSales().then((flashSales) {
      state = state.copyWith(flashSales: AsyncValue.data(flashSales));
    });
  }
}

final dashboardViewModelProvider =
    StateNotifierProvider<DashboardViewModel, DashboardState>((ref) {
  final userId = ref.watch(authStateChangesProvider).asData?.value?.uid;
  if (userId == null) {
    throw Exception('User not authenticated');
  }
  return DashboardViewModel(ref.watch(dashboardRepositoryProvider), userId);
});
