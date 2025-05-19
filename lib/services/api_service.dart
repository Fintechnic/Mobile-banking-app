import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transaction.dart';

class ApiService {
  final String baseUrl = "http://localhost:8080"; // Change if using emulator or different port

  Future<List<Transaction>> fetchTransactions(String token) async {
    final url = Uri.parse('$baseUrl/api/transactions');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Transaction.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load transactions. Status: ${response.statusCode}');
    }
  }
}
