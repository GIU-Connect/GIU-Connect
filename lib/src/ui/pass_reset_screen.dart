import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PassResetScreen extends StatefulWidget {
  const PassResetScreen({super.key});

  @override
  _PassResetScreenState createState() => _PassResetScreenState();
}

class _PassResetScreenState extends State<PassResetScreen> {
  final TextEditingController _emailController = TextEditingController();
// Initialize your auth service

  void _resetPassword() async {
    FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
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
