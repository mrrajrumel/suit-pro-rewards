import 'package:flutter/material.dart';

class TierData {
  final String label;
  final int multiplier;
  final int threshold;
  final Color color;

  const TierData({
    required this.label,
    required this.multiplier,
    required this.threshold,
    required this.color,
  });
}

class TierUtils {
  static const Map<String, TierData> tiers = {
    'Silver': TierData(
      label: 'Silver',
      multiplier: 10,
      threshold: 0,
      color: Color(0xFF94A3B8),
    ),
    'Gold': TierData(
      label: 'Gold',
      multiplier: 15,
      threshold: 2500,
      color: Color(0xFFFACC15),
    ),
    'Platinum': TierData(
      label: 'Platinum',
      multiplier: 25,
      threshold: 7500,
      color: Color(0xFF34D399),
    ),
  };

  static String getTier(double totalSpent) {
    if (totalSpent >= 7500) return 'Platinum';
    if (totalSpent >= 2500) return 'Gold';
    return 'Silver';
  }

  static TierData? getNextTier(String tier) {
    const order = ['Silver', 'Gold', 'Platinum'];
    final idx = order.indexOf(tier);
    if (idx == -1 || idx == order.length - 1) return null;
    final next = order[idx + 1];
    return tiers[next];
  }
}
