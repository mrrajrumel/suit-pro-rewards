import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suit_pro_rewards_flutter/providers/auth_provider.dart';
import 'package:suit_pro_rewards_flutter/providers/user_provider.dart';
import 'package:suit_pro_rewards_flutter/screens/landing_screen.dart';
import 'package:suit_pro_rewards_flutter/screens/onboarding_screen.dart';
import 'package:suit_pro_rewards_flutter/screens/loading_screen.dart';
import 'package:suit_pro_rewards_flutter/screens/app/member_layout.dart';
import 'package:suit_pro_rewards_flutter/screens/app/dashboard_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return const LandingScreen();
        }

        // If logged in, check if member exists in Firestore
        final memberAsync = ref.watch(userProvider);
        return memberAsync.when(
          data: (member) {
            if (member == null) {
              return const OnboardingScreen();
            }
            // User is logged in and is a member, show the app
            return const MemberLayout(child: DashboardScreen());
          },
          loading: () => const LoadingScreen(),
          error: (e, st) => Scaffold(body: Center(child: Text('Error: $e'))),
        );
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
