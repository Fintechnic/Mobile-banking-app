import 'package:flutter/material.dart';
import 'package:fintechnic/services/api_test_service.dart';

class ApiTestScreen extends StatefulWidget {
  const ApiTestScreen({Key? key}) : super(key: key);

  @override
  State<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  final ApiTestService _apiTestService = ApiTestService();
  bool _isLoading = false;
  String _testResult = '';

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _testResult = '';
    });

    try {
      final isConnected = await _apiTestService.testConnection();
      setState(() {
        _testResult = isConnected 
            ? 'Kết nối thành công với backend!'
            : 'Không thể kết nối với backend. Vui lòng kiểm tra lại.';
      });
    } catch (e) {
      setState(() {
        _testResult = 'Lỗi: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kiểm tra kết nối API'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _testConnection,
                  child: const Text('Kiểm tra kết nối'),
                ),
              const SizedBox(height: 20),
              if (_testResult.isNotEmpty)
                Text(
                  _testResult,
                  style: TextStyle(
                    color: _testResult.contains('thành công') 
                        ? Colors.green 
                        : Colors.red,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
} 