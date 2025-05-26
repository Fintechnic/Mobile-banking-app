class User {
  String username;
  String email;
  String role;

  User({required this.username, required this.email, required this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      role: json['role'],
    );
  }
}
