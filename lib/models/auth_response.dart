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
  
  @JsonKey(name: 'userId')
  final String? userId;

  AuthResponse({
    this.token,
    this.role,
    this.username,
    this.userId,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => 
    _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);

  AuthResponse copyWith({
    String? token,
    String? role,
    String? username,
    String? userId,
  }) {
    return AuthResponse(
      token: token ?? this.token,
      role: role ?? this.role,
      username: username ?? this.username,
      userId: userId ?? this.userId,
    );
  }
}