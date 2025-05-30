// auth_response_model.dart
class AuthResponseModel {
  final String jsonrpc;
  final dynamic id;
  final AuthResultModel result;

  AuthResponseModel({
    required this.jsonrpc,
    this.id,
    required this.result,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      jsonrpc: json['jsonrpc'] ?? '2.0',
      id: json['id'],
      result: AuthResultModel.fromJson(json['result'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jsonrpc': jsonrpc,
      'id': id,
      'result': result.toJson(),
    };
  }

  @override
  String toString() {
    return 'AuthResponseModel(jsonrpc: $jsonrpc, id: $id, result: $result)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthResponseModel &&
        other.jsonrpc == jsonrpc &&
        other.id == id &&
        other.result == result;
  }

  @override
  int get hashCode {
    return jsonrpc.hashCode ^ id.hashCode ^ result.hashCode;
  }
}

class AuthResultModel {
  final String token;
  final int uid;
  final String image;
  final String name;
  final int companyId;
  final String companyName;
  final String street1;
  final String street2;
  final String tel;
  final String email;
  final bool premium;
  final String result;
  final String url;

  AuthResultModel({
    required this.token,
    required this.uid,
    required this.image,
    required this.name,
    required this.companyId,
    required this.companyName,
    required this.street1,
    required this.street2,
    required this.tel,
    required this.email,
    required this.premium,
    required this.result,
    required this.url,
  });

  factory AuthResultModel.fromJson(Map<String, dynamic> json) {
    return AuthResultModel(
      token: json['token'] ?? '',
      uid: json['uid'] ?? 0,
      image: json['image'] ?? '',
      name: json['name'] ?? '',
      companyId: json['company_id'] ?? 0,
      companyName: json['company_name'] ?? '',
      street1: json['street1'] ?? '',
      street2: json['street2'] ?? '',
      tel: json['tel'] ?? '',
      email: json['email'] ?? '',
      premium: json['premium'] ?? false,
      result: json['result'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'uid': uid,
      'image': image,
      'name': name,
      'company_id': companyId,
      'company_name': companyName,
      'street1': street1,
      'street2': street2,
      'tel': tel,
      'email': email,
      'premium': premium,
      'result': result,
      'url': url,
    };
  }

  @override
  String toString() {
    return 'AuthResultModel(token: ${token.isNotEmpty ? '***' : 'empty'}, uid: $uid, name: $name, result: $result)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthResultModel &&
        other.token == token &&
        other.uid == uid &&
        other.image == image &&
        other.name == name &&
        other.companyId == companyId &&
        other.companyName == companyName &&
        other.street1 == street1 &&
        other.street2 == street2 &&
        other.tel == tel &&
        other.email == email &&
        other.premium == premium &&
        other.result == result &&
        other.url == url;
  }

  @override
  int get hashCode {
    return token.hashCode ^
    uid.hashCode ^
    image.hashCode ^
    name.hashCode ^
    companyId.hashCode ^
    companyName.hashCode ^
    street1.hashCode ^
    street2.hashCode ^
    tel.hashCode ^
    email.hashCode ^
    premium.hashCode ^
    result.hashCode ^
    url.hashCode;
  }

  AuthResultModel copyWith({
    String? token,
    int? uid,
    String? image,
    String? name,
    int? companyId,
    String? companyName,
    String? street1,
    String? street2,
    String? tel,
    String? email,
    bool? premium,
    String? result,
    String? url,
  }) {
    return AuthResultModel(
      token: token ?? this.token,
      uid: uid ?? this.uid,
      image: image ?? this.image,
      name: name ?? this.name,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      street1: street1 ?? this.street1,
      street2: street2 ?? this.street2,
      tel: tel ?? this.tel,
      email: email ?? this.email,
      premium: premium ?? this.premium,
      result: result ?? this.result,
      url: url ?? this.url,
    );
  }

  // Helper methods
  bool get isSuccess => result.toLowerCase() == 'success';
  bool get hasValidToken => token.isNotEmpty;
  String get displayName => name.isNotEmpty ? name : 'User';
  String get fullAddress => [street1, street2].where((s) => s.isNotEmpty).join(', ');
}