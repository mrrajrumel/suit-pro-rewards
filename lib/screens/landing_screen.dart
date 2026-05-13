import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suit_pro_rewards_flutter/providers/auth_view_model.dart';
import 'package:suit_pro_rewards_flutter/screens/auth/auth_form.dart';
import 'package:suit_pro_rewards_flutter/widgets/google_icon.dart';
import 'package:suit_pro_rewards_flutter/widgets/logo.dart';
import 'package:suit_pro_rewards_flutter/themes/app_theme.dart';

enum AuthMode { landing, login, register }

class LandingScreen extends ConsumerStatefulWidget {
  const LandingScreen({super.key});

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends ConsumerState<LandingScreen> {
  var _authMode = AuthMode.landing;

  void _submitAuthForm(
    String email,
    String password,
    String? fullName,
    bool isLogin,
  ) {
    if (isLogin) {
      ref
          .read(authViewModelProvider.notifier)
          .signInWithEmailAndPassword(email, password);
    } else {
      ref
          .read(authViewModelProvider.notifier)
          .createUserWithEmailAndPassword(email, password, fullName!);
    }
  }

  Widget _buildAuthMode() {
    final isLoading = ref.watch(authViewModelProvider).isLoading;
    if (_authMode == AuthMode.login || _authMode == AuthMode.register) {
      return AuthForm(_submitAuthForm, isLoading);
    }

    // This is the main landing view, now matching the original design
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () => setState(() => _authMode = AuthMode.login),
          child: const Text('Join With Email'),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () { /* TODO: Google Sign In */ },
                icon: const GoogleIcon(),
                label: const Text('Google'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.foreground,
                  side: BorderSide(color: AppTheme.border),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () { /* TODO: Apple Sign In */ },
                icon: const Icon(Icons.apple),
                label: const Text('Apple'),
                 style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.foreground,
                  side: BorderSide(color: AppTheme.border),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradients
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: AppTheme.gold.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: AppTheme.gold.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  const Logo(size: 90),
                  const SizedBox(height: 48),
                  Text(
                    'Join the',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                   Text(
                    'London Club.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: AppTheme.gold,
                    ),
                  ),
                  const Spacer(flex: 2),
                  _buildAuthMode(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
