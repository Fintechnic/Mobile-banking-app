import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    final emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Đăng ký")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: usernameController, decoration: const InputDecoration(labelText: "Username")),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                bool success = await authProvider.register(
                  usernameController.text,
                  passwordController.text,
                  emailController.text,
                );

                if (!context.mounted) return;

                if (success) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Đăng ký thất bại")),
                  );
                }
              },
              child: const Text("Đăng ký"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
              child: const Text("Đã có tài khoản? Đăng nhập ngay!"),
            ),
          ],
        ),
      ),
    );
  }
}
