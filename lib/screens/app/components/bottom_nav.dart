import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(LucideIcons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(LucideIcons.wallet),
          label: 'Wallet',
        ),
        BottomNavigationBarItem(
          icon: Icon(LucideIcons.gift),
          label: 'Rewards',
        ),
        BottomNavigationBarItem(
          icon: Icon(LucideIcons.user),
          label: 'Profile',
        ),
      ],
    );
  }
}
