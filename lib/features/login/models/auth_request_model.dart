// auth_request_model.dart
class AuthRequestModel {
  final String login;
  final String password;
  final String appType;
  final String firebaseToken;

  AuthRequestModel({
    required this.login,
    required this.password,
    required this.appType,
    required this.firebaseToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'login': login,
      'password': password,
      'app_type': appType,
      'firebase_token': firebaseToken,
    };
  }

  factory AuthRequestModel.fromJson(Map<String, dynamic> json) {
    return AuthRequestModel(
      login: json['login'] ?? '',
      password: json['password'] ?? '',
      appType: json['app_type'] ?? '',
      firebaseToken: json['firebase_token'] ?? '',
    );
  }

  @override
  String toString() {
    return 'AuthRequestModel(login: $login, appType: $appType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthRequestModel &&
        other.login == login &&
        other.password == password &&
        other.appType == appType &&
        other.firebaseToken == firebaseToken;
  }

  @override
  int get hashCode {
    return login.hashCode ^
    password.hashCode ^
    appType.hashCode ^
    firebaseToken.hashCode;
  }

  AuthRequestModel copyWith({
    String? login,
    String? password,
    String? appType,
    String? firebaseToken,
  }) {
    return AuthRequestModel(
      login: login ?? this.login,
      password: password ?? this.password,
      appType: appType ?? this.appType,
      firebaseToken: firebaseToken ?? this.firebaseToken,
    );
  }
}