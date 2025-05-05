class Wallet {
  final int id;
  final String username;
  final String phoneNumber;
  final double balance;

  Wallet({
    required this.id,
    required this.username,
    required this.phoneNumber,
    required this.balance,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'],
      username: json['username'],
      phoneNumber: json['phoneNumber'],
      balance: double.parse(json['balance'].toString()),
    );
  }
}
