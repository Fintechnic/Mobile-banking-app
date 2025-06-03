class RoleConstants {
  // User roles
  static const String ADMIN = 'ADMIN';
  static const String USER = 'USER';
  
  // Permission checks
  static bool isAdmin(String? role) => role == ADMIN;
  static bool isUser(String? role) => role == USER;
} 