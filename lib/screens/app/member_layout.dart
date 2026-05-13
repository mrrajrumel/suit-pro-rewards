import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:suit_pro_rewards_flutter/screens/app/components/bottom_nav.dart';

class MemberLayout extends StatelessWidget {
  final Widget child;

  const MemberLayout({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final GoRouter route = GoRouter.of(context);
    final String location = route.location;
    if (location.startsWith('/home')) {
      return 0;
    }
    if (location.startsWith('/wallet')) {
      return 1;
    }
    if (location.startsWith('/rewards')) {
      return 2;
    }
    if (location.startsWith('/profile')) {
      return 3;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/home');
        break;
      case 1:
        GoRouter.of(context).go('/wallet');
        break;
      case 2:
        GoRouter.of(context).go('/rewards');
        break;
      case 3:
        GoRouter.of(context).go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNav(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
      ),
    );
  }
}
