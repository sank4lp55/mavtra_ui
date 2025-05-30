// auth_state.dart
import 'package:equatable/equatable.dart';
import 'package:mavtra_ui_test/features/login/models/auth_response_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();

  @override
  String toString() => 'AuthInitial';
}

class AuthLoading extends AuthState {
  const AuthLoading();

  @override
  String toString() => 'AuthLoading';
}

class AuthAuthenticated extends AuthState {
  final AuthResultModel user;
  final String token;

  const AuthAuthenticated({
    required this.user,
    required this.token,
  });

  @override
  List<Object?> get props => [user, token];

  @override
  String toString() => 'AuthAuthenticated(user: ${user.name}, token: ${token.isNotEmpty ? '***' : 'empty'})';

  AuthAuthenticated copyWith({
    AuthResultModel? user,
    String? token,
  }) {
    return AuthAuthenticated(
      user: user ?? this.user,
      token: token ?? this.token,
    );
  }
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();

  @override
  String toString() => 'AuthUnauthenticated';
}

class AuthError extends AuthState {
  final String message;
  final String? errorCode;

  const AuthError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];

  @override
  String toString() => 'AuthError(message: $message, code: $errorCode)';
}

class AuthLogoutLoading extends AuthState {
  const AuthLogoutLoading();

  @override
  String toString() => 'AuthLogoutLoading';
}

class AuthTokenRefreshing extends AuthState {
  const AuthTokenRefreshing();

  @override
  String toString() => 'AuthTokenRefreshing';
}