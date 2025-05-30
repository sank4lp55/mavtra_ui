import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mavtra_ui_test/core/constants/app_colors.dart';
import 'package:mavtra_ui_test/features/onboarding/views/screens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay before navigating to onboarding
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // or your theme color
      body: Center(
        child: Image.asset(
          'assets/Mavtra Logo Transparent 2.png',
          width: 150, // adjust as needed
        ),
      ),
    );
  }
}
