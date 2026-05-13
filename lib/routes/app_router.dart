import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suit_pro_rewards_flutter/screens/app/member_layout.dart';
import 'package:suit_pro_rewards_flutter/screens/app/profile_screen.dart';
import 'package:suit_pro_rewards_flutter/screens/app/rewards_screen.dart';
import 'package:suit_pro_rewards_flutter/screens/app/wallet_screen.dart';
import 'package:suit_pro_rewards_flutter/screens/app/user_dashboard_screen.dart';
import 'package:suit_pro_rewards_flutter/screens/auth_gate.dart';
import 'package:suit_pro_rewards_flutter/screens/landing_screen.dart';
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
        builder: (BuildContext context, GoRouterState state) =>
            const AuthGate(),
      ),
      GoRoute(
        path: '/landing',
        builder: (BuildContext context, GoRouterState state) =>
            const LandingScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return MemberLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (BuildContext context, GoRouterState state) =>
                const UserDashboardScreen(),
          ),
          GoRoute(
            path: '/wallet',
            builder: (BuildContext context, GoRouterState state) =>
                const WalletScreen(),
          ),
          GoRoute(
            path: '/rewards',
            builder: (BuildContext context, GoRouterState state) =>
                const RewardsScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (BuildContext context, GoRouterState state) =>
                const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (BuildContext context, GoRouterState state) =>
                    const EditProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/admin',
        builder: (BuildContext context, GoRouterState state) => const AdminDashboardScreen(),
        redirect: (BuildContext context, GoRouterState state) {
          final container = ProviderScope.containerOf(context, listen: false);
          final user = container.read(userProvider).asData?.value;

          if (user?.role != 'admin') {
            return '/home'; // Redirect non-admins
          }
          return null; // Allow admins
        },
        routes: [
          GoRoute(
            path: 'users',
            builder: (BuildContext context, GoRouterState state) => const ManageUsersScreen(),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (BuildContext context, GoRouterState state) {
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
