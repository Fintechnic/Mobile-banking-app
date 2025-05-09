class AuthResponse {
  String token;
  String role;
  bool accountLocked;

  AuthResponse({required this.token, required this.role, required this.accountLocked});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
      role: json['role'],
      accountLocked: json['accountLocked'],
    );
  }
}