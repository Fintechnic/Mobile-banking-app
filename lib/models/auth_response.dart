import 'package:json_annotation/json_annotation.dart';

part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse {
  @JsonKey(name: 'token')
  final String? token;
  
  @JsonKey(name: 'role')
  final String? role;
  
  @JsonKey(name: 'username')
  final String? username;
  
  @JsonKey(name: 'userId', defaultValue: '')
  final String? userId;
  
  @JsonKey(name: 'email', defaultValue: '')
  final String? email;
  
  @JsonKey(name: 'phoneNumber', defaultValue: '')
  final String? phoneNumber;
  
  @JsonKey(name: 'error')
  final String? error;

  AuthResponse({
    this.token,
    this.role,
    this.username,
    this.userId,
    this.email,
    this.phoneNumber,
    this.error,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    try {
      return _$AuthResponseFromJson(json);
    } catch (e) {
      // Try to handle variable field names
      return AuthResponse(
        token: json['token'] ?? json['accessToken'] ?? json['access_token'],
        role: json['role'] ?? json['userRole'] ?? json['user_role'],
        username: json['username'] ?? json['userName'] ?? json['user_name'],
        userId: json['userId'] ?? json['id'] ?? json['user_id'] ?? '',
        email: json['email'] ?? json['userEmail'] ?? json['user_email'] ?? '',
        phoneNumber: json['phoneNumber'] ?? json['phone'] ?? json['user_phone'] ?? '',
        error: json['error'] ?? json['message'] ?? '',
      );
    }
  }

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);

  AuthResponse copyWith({
    String? token,
    String? role,
    String? username,
    String? userId,
    String? email,
    String? phoneNumber,
    String? error,
  }) {
    return AuthResponse(
      token: token ?? this.token,
      role: role ?? this.role,
      username: username ?? this.username,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      error: error ?? this.error,
    );
  }
  
  bool get hasError => error != null && error!.isNotEmpty;
}