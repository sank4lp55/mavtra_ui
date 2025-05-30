// auth_event.dart
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String url;
  final String login;
  final String password;
  final String appType;
  final String firebaseToken;

  const AuthLoginRequested({
    required this.url,
    required this.login,
    required this.password,
    required this.appType,
    required this.firebaseToken,
  });

  @override
  List<Object?> get props => [url, login, password, appType, firebaseToken];

  @override
  String toString() {
    return 'AuthLoginRequested(login: $login, appType: $appType)';
  }
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();

  @override
  String toString() => 'AuthLogoutRequested';
}

class AuthCheckStatus extends AuthEvent {
  const AuthCheckStatus();

  @override
  String toString() => 'AuthCheckStatus';
}

class AuthTokenRefreshRequested extends AuthEvent {
  final String refreshToken;

  const AuthTokenRefreshRequested({
    required this.refreshToken,
  });

  @override
  List<Object?> get props => [refreshToken];

  @override
  String toString() => 'AuthTokenRefreshRequested';
}

class AuthClearError extends AuthEvent {
  const AuthClearError();

  @override
  String toString() => 'AuthClearError';
}
