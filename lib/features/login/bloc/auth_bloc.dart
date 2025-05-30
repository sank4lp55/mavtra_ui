// auth_bloc.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mavtra_ui_test/core/services/api_service.dart';
import 'package:mavtra_ui_test/core/services/auth_service.dart';
import 'package:mavtra_ui_test/features/login/models/auth_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  static const String _tokenKey = 'auth_token';
  static const String _userDataKey = 'user_data';

  AuthBloc({
    required AuthService authService,
  })  : _authService = authService,
        super(const AuthInitial()) {

    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckStatus>(_onCheckStatus);
    on<AuthTokenRefreshRequested>(_onTokenRefreshRequested);
    on<AuthClearError>(_onClearError);

    // Delay initial auth check to ensure platform is ready
    _scheduleInitialAuthCheck();
  }

  void _scheduleInitialAuthCheck() {
    // Schedule auth check after a short delay to ensure platform channels are ready
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!isClosed) {
        add(const AuthCheckStatus());
      }
    });
  }

  Future<void> _onLoginRequested(
      AuthLoginRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());

    try {
      final response = await _authService.login(
        url: event.url,
        login: event.login,
        password: event.password,
        appType: event.appType,
        firebaseToken: event.firebaseToken,
      );

      final authResponse = AuthResponseModel.fromJson(response);

      if (authResponse.result.isSuccess && authResponse.result.hasValidToken) {
        // Save token and user data locally
        await _saveAuthData(
          token: authResponse.result.token,
          userData: authResponse.result,
        );

        emit(AuthAuthenticated(
          user: authResponse.result,
          token: authResponse.result.token,
        ));
      } else {
        emit(AuthError(
          message: authResponse.result.result.isNotEmpty
              ? authResponse.result.result
              : 'Login failed',
        ));
      }
    } on APIException catch (e) {
      emit(AuthError(
        message: e.message,
        errorCode: e.statusCode?.toString(),
      ));
    } catch (e) {
      emit(AuthError(
        message: 'An unexpected error occurred: ${e.toString()}',
      ));
    }
  }

  Future<void> _onLogoutRequested(
      AuthLogoutRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLogoutLoading());

    try {
      await _authService.logout();
    } catch (e) {
      // Continue with logout even if API call fails
      print('Logout API call failed: $e');
    } finally {
      // Always clear local data
      await _clearAuthData();
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onCheckStatus(
      AuthCheckStatus event,
      Emitter<AuthState> emit,
      ) async {
    try {
      // Add a small delay to ensure platform channels are ready
      await Future.delayed(const Duration(milliseconds: 100));

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      final userDataJson = prefs.getString(_userDataKey);

      if (token != null && userDataJson != null) {
        try {
          // Parse stored user data from JSON string
          final Map<String, dynamic> userDataMap = json.decode(userDataJson);
          final userData = AuthResultModel.fromJson(userDataMap);

          // Verify token is still valid (optional: you could add expiry check here)
          emit(AuthAuthenticated(
            user: userData,
            token: token,
          ));
        } catch (parseError) {
          print('Error parsing stored user data: $parseError');
          // Clear corrupted data
          await _clearAuthData();
          emit(const AuthUnauthenticated());
        }
      } else {
        emit(const AuthUnauthenticated());
      }
    } on PlatformException catch (e) {
      print('Platform error accessing SharedPreferences: ${e.message}');
      // Retry after a longer delay
      try {
        await Future.delayed(const Duration(milliseconds: 500));
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString(_tokenKey);

        if (token != null) {
          final userDataJson = prefs.getString(_userDataKey);
          if (userDataJson != null) {
            final Map<String, dynamic> userDataMap = json.decode(userDataJson);
            final userData = AuthResultModel.fromJson(userDataMap);
            emit(AuthAuthenticated(user: userData, token: token));
          } else {
            emit(const AuthUnauthenticated());
          }
        } else {
          emit(const AuthUnauthenticated());
        }
      } catch (retryError) {
        print('Retry failed: $retryError');
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      print('Error checking auth status: $e');
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onTokenRefreshRequested(
      AuthTokenRefreshRequested event,
      Emitter<AuthState> emit,
      ) async {
    if (state is! AuthAuthenticated) return;

    emit(const AuthTokenRefreshing());
    final currentState = state as AuthAuthenticated;

    try {
      // Implement token refresh logic here
      // This depends on your API having a refresh token endpoint

      // For now, just maintain the current state
      emit(currentState);
    } on APIException catch (e) {
      // If refresh fails, logout user
      await _clearAuthData();
      emit(AuthError(
        message: 'Session expired. Please login again.',
        errorCode: e.statusCode?.toString(),
      ));
    } catch (e) {
      emit(AuthError(
        message: 'Failed to refresh session. Please login again.',
      ));
    }
  }

  void _onClearError(
      AuthClearError event,
      Emitter<AuthState> emit,
      ) {
    if (state is AuthError) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _saveAuthData({
    required String token,
    required AuthResultModel userData,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
      // Convert to proper JSON string
      await prefs.setString(_userDataKey, json.encode(userData.toJson()));
    } on PlatformException catch (e) {
      print('Platform error saving auth data: ${e.message}');
      // Retry once
      try {
        await Future.delayed(const Duration(milliseconds: 200));
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, token);
        await prefs.setString(_userDataKey, json.encode(userData.toJson()));
      } catch (retryError) {
        print('Failed to save auth data after retry: $retryError');
      }
    } catch (e) {
      print('Error saving auth data: $e');
    }
  }

  Future<void> _clearAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userDataKey);
    } on PlatformException catch (e) {
      print('Platform error clearing auth data: ${e.message}');
      // Retry once
      try {
        await Future.delayed(const Duration(milliseconds: 200));
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_tokenKey);
        await prefs.remove(_userDataKey);
      } catch (retryError) {
        print('Failed to clear auth data after retry: $retryError');
      }
    } catch (e) {
      print('Error clearing auth data: $e');
    }
  }

  // Helper methods for UI
  bool get isAuthenticated => state is AuthAuthenticated;
  bool get isLoading => state is AuthLoading || state is AuthLogoutLoading;
  bool get hasError => state is AuthError;

  String? get currentToken {
    if (state is AuthAuthenticated) {
      return (state as AuthAuthenticated).token;
    }
    return null;
  }

  AuthResultModel? get currentUser {
    if (state is AuthAuthenticated) {
      return (state as AuthAuthenticated).user;
    }
    return null;
  }

  String? get errorMessage {
    if (state is AuthError) {
      return (state as AuthError).message;
    }
    return null;
  }
}