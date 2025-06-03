class User {
  final int? id;
  final String username;
  final String email;
  final String? phoneNumber;
  final String role;
  final bool accountLocked;
  final int failedLoginAttempts;
  final String? createdAt;
  final String? password; // Only available in detailed response
  final String? lastFailedLogin;
  final List<dynamic>? activeTokens;

  User({
    this.id,
    required this.username,
    required this.email,
    this.phoneNumber,
    required this.role,
    this.accountLocked = false,
    this.failedLoginAttempts = 0,
    this.createdAt,
    this.password,
    this.lastFailedLogin,
    this.activeTokens,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'],
      role: json['role'] ?? '',
      accountLocked: json['accountLocked'] ?? false,
      failedLoginAttempts: json['failedLoginAttempts'] ?? 0,
      createdAt: json['createdAt'],
      password: json['password'],
      lastFailedLogin: json['lastFailedLogin'],
      activeTokens: json['activeTokens'],
    );
  }
  
  bool get isAdmin => role.toUpperCase() == 'ADMIN';
  
  String get accountStatus => accountLocked ? 'Locked' : 'Active';
  
  String get formattedCreatedAt {
    if (createdAt == null) return 'N/A';
    try {
      final dateTime = DateTime.parse(createdAt!);
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return createdAt!;
    }
  }
}
