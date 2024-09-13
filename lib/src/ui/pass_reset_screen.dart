import 'package:flutter/material.dart';
import 'package:group_changing_app/src/services/auth_service.dart';

class PassResetScreen extends StatefulWidget {
  const PassResetScreen({super.key});

  @override
  _PassResetScreenState createState() => _PassResetScreenState();
}

class _PassResetScreenState extends State<PassResetScreen> {
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService =
      AuthService(); // Initialize your auth service

  void _resetPassword() async {
    String email = _emailController.text;
    if (email.isNotEmpty) {
      bool result = await _authService.passwordReset(email: email);
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset email sent')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send password reset email')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an email')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Reset'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetPassword,
              child: const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
