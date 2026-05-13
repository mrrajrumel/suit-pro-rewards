import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suit_pro_rewards_flutter/providers/auth_provider.dart';
import 'package:suit_pro_rewards_flutter/screens/app/dashboard_screen.dart';
import 'package:suit_pro_rewards_flutter/screens/landing_screen.dart';
import 'package:suit_pro_rewards_flutter/screens/loading_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          return const DashboardScreen();
        }
        return const LandingScreen();
      },
      loading: () => const LoadingScreen(),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
