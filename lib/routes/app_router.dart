import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suit_pro_rewards_flutter/screens/app/member_layout.dart';
import 'package:suit_pro_rewards_flutter/screens/app/profile_screen.dart';
import 'package:suit_pro_rewards_flutter/screens/app/rewards_screen.dart';
import 'package:suit_pro_rewards_flutter/screens/app/wallet_screen.dart';
import 'package:suit_pro_rewards_flutter/screens/app/dashboard_screen.dart';
import 'package:suit_pro_rewards_flutter/screens/app/referral_screen.dart';
import 'package:suit_pro_rewards_flutter/screens/app/placeholder_screens.dart';
import 'package:suit_pro_rewards_flutter/screens/auth_gate.dart';
import 'package:suit_pro_rewards_flutter/screens/landing_screen.dart';
import 'package:suit_pro_rewards_flutter/screens/onboarding_screen.dart';
import 'package:suit_pro_rewards_flutter/screens/app/edit_profile_screen.dart';
import 'package:suit_pro_rewards_flutter/screens/admin/admin_dashboard_screen.dart';
import 'package:suit_pro_rewards_flutter/screens/admin/manage_users_screen.dart';
import 'package:suit_pro_rewards_flutter/screens/admin/admin_edit_user_screen.dart';
import 'package:suit_pro_rewards_flutter/models/app/user.dart';
import 'package:suit_pro_rewards_flutter/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const AuthGate(),
      ),
      GoRoute(
        path: '/landing',
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MemberLayout(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/wallet',
            builder: (context, state) => const WalletScreen(),
          ),
          GoRoute(
            path: '/rewards',
            builder: (context, state) => const RewardsScreen(),
          ),
          GoRoute(
            path: '/shop',
            builder: (context, state) => const ShopScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) => const EditProfileScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/referral',
            builder: (context, state) => const ReferralScreen(),
          ),
          GoRoute(
            path: '/scan-receipt',
            builder: (context, state) => const ScanReceiptScreen(),
          ),
          GoRoute(
            path: '/notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: '/website-link',
            builder: (context, state) => const WebsiteLinkScreen(),
          ),
          GoRoute(
            path: '/support',
            builder: (context, state) => const SupportScreen(),
          ),
          GoRoute(
            path: '/privacy',
            builder: (context, state) => const PrivacyScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboardScreen(),
        redirect: (context, state) {
          final container = ProviderScope.containerOf(context, listen: false);
          final user = container.read(userProvider).asData?.value;
          if (user?.role != 'admin') return '/dashboard';
          return null;
        },
        routes: [
          GoRoute(
            path: 'users',
            builder: (context, state) => const ManageUsersScreen(),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) {
                  final user = state.extra as AppUser;
                  return AdminEditUserScreen(user: user);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
