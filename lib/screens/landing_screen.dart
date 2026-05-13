import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suit_pro_rewards_flutter/providers/auth_view_model.dart';
import 'package:suit_pro_rewards_flutter/screens/auth/auth_form.dart';
import 'package:suit_pro_rewards_flutter/widgets/google_icon.dart';
import 'package:suit_pro_rewards_flutter/widgets/logo.dart';

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

    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () => setState(() => _authMode = AuthMode.login),
          icon: const Icon(Icons.email),
          label: const Text('Continue with Email'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const GoogleIcon(),
                label: const Text('Google'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.apple),
                label: const Text('Apple'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color(0xFF1A1A1A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: LayoutBuilder( // Use LayoutBuilder for responsive sizing
              builder: (context, constraints) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    const Logo(size: 80),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: constraints.maxWidth > 400 ? 400 : constraints.maxWidth, // Limit width on larger screens
                      child: const Text(
                        'Exclusive Rewards, Unparalleled Service',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const Spacer(flex: 3),
                    _buildAuthMode(),
                    const Spacer(flex: 1),
                  ],
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}
