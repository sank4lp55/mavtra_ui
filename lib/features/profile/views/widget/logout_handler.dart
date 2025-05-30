// Add these imports to your file
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mavtra_ui_test/features/login/bloc/auth_bloc.dart';
import 'package:mavtra_ui_test/features/login/bloc/auth_event.dart';
import 'package:mavtra_ui_test/features/login/bloc/auth_state.dart';
import 'package:mavtra_ui_test/features/login/views/screens/login_screen.dart';
import 'package:mavtra_ui_test/core/constants/app_colors.dart';

class LogoutHandler {
  /// Show logout confirmation dialog
  static Future<void> showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: AppColors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          title: const Text(
            'Logout Confirmation',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to logout? You will be redirected to the login screen.',
            style: TextStyle(
              color: AppColors.grey,
              fontSize: 16,
            ),
          ),
          actions: <Widget>[
            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.grey,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Logout Button
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthUnauthenticated) {
                  // Close dialog and navigate to login
                  Navigator.of(context).pop();
                  _navigateToLogin(context);
                } else if (state is AuthError) {
                  // Close dialog and show error, but still navigate to login as fallback
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Logout completed with warning: ${state.message}'),
                      backgroundColor: Colors.orange,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  _navigateToLogin(context);
                }
              },
              builder: (context, state) {
                final isLoading = state is AuthLogoutLoading;

                return ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          // Dispatch logout event
                          context
                              .read<AuthBloc>()
                              .add(const AuthLogoutRequested());
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.red.withOpacity(0.6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  /// Navigate to login screen and clear navigation stack
  static void _navigateToLogin(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false, // Remove all previous routes
    );
  }
}
