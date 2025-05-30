import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mavtra_ui_test/core/constants/app_colors.dart';
import 'package:mavtra_ui_test/features/onboarding/views/screens/onboarding_screen.dart';
import 'package:mavtra_ui_test/features/login/views/screens/login_screen.dart';
import 'package:mavtra_ui_test/features/bottom_nav_bar/views/screens/main_screen.dart';
import 'package:mavtra_ui_test/features/login/bloc/auth_bloc.dart';
import 'package:mavtra_ui_test/features/login/bloc/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _minimumDisplayTimer;
  bool _minimumTimeElapsed = false;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    // Ensure splash screen shows for minimum 2 seconds for branding
    _minimumDisplayTimer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _minimumTimeElapsed = true;
      });
      _checkNavigationConditions();
    });
  }

  void _checkNavigationConditions() {
    // Only navigate if minimum time has elapsed and we haven't navigated yet
    if (_minimumTimeElapsed && !_hasNavigated) {
      final currentState = context.read<AuthBloc>().state;
      _navigateBasedOnAuthState(currentState);
    }
  }

  void _navigateBasedOnAuthState(AuthState state) {
    if (_hasNavigated) return;

    // Don't navigate if still loading
    if (state is AuthInitial) return;

    _hasNavigated = true;

    if (state is AuthAuthenticated) {
      // User is authenticated, go to main app
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const BottomNavBar()),
      );
    } else if (state is AuthUnauthenticated) {
      // User is not authenticated, go to login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else if (state is AuthError) {
      // Authentication check failed, go to login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          // React to auth state changes
          _checkNavigationConditions();
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/Mavtra Logo Transparent 2.png',
                width: 150,
              ),
              const SizedBox(height: 40),
              // Loading indicator
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  // Show different loading states
                  if (state is AuthInitial) {
                    return Column(
                      children: [
                        const SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Checking authentication...',
                          style: TextStyle(
                            color: AppColors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    );
                  } else if (state is AuthAuthenticated) {
                    return Column(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.primary,
                          size: 30,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Welcome back!',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  } else if (state is AuthUnauthenticated || state is AuthError) {
                    return Column(
                      children: [
                        const SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Preparing login...',
                          style: TextStyle(
                            color: AppColors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    );
                  }

                  // Default loading
                  return const SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _minimumDisplayTimer?.cancel();
    super.dispose();
  }
}