import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:suit_pro_rewards_flutter/widgets/logo.dart';
import 'package:suit_pro_rewards_flutter/themes/app_theme.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Logo(size: 60)
                .animate()
                .scale(
                  duration: 1200.ms,
                  curve: const Cubic(0.22, 1, 0.36, 1),
                  begin: const Offset(0.95, 0.95),
                  end: const Offset(1, 1),
                )
                .fadeIn(duration: 1200.ms),
            const SizedBox(height: 48),
            Container(
              width: 96,
              height: 1,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(0.5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0.5),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container()
                          .animate(onPlay: (controller) => controller.repeat())
                          .custom(
                            duration: 2.seconds,
                            builder: (context, value, child) {
                              return FractionalTranslation(
                                translation: Offset(-1 + (value * 2), 0),
                                child: Container(
                                  width: 96,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        AppTheme.gold,
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
