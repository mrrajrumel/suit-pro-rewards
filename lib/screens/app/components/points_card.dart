import 'package:flutter/material.dart';
import 'package:suit_pro_rewards_flutter/models/app/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suit_pro_rewards_flutter/themes/app_theme.dart';
import 'package:suit_pro_rewards_flutter/providers/user_provider.dart';

class PointsCard extends ConsumerWidget {
  const PointsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final points = userAsync.asData?.value?.points ?? 0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(32), // rounded-[2rem]
        border: Border.all(color: AppTheme.gold.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.gold.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: -10,
            offset: const Offset(0, 10),
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'YOUR JOURNEY',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.gold,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                ),
              ),
              Text(
                'View Status',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.mutedForeground,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '${points.toString()} pts',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: AppTheme.gold,
            ),
          ),
        ],
      ),
    );
  }
}
