import 'package:flutter/material.dart';
import 'package:group_changing_app/src/services/auth_service.dart';

class ResendVerificationScreen extends StatelessWidget {
<<<<<<< HEAD
  final AuthService _authService = AuthService();

  ResendVerificationScreen({super.key}); // Initialize your auth service
=======
  final AuthService _authService =
      AuthService(); // Initialize your auth service
>>>>>>> c3c685a308e66da8e025960658f6e6a4d4a92d32

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resend Verification Email'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            bool result = await _authService.resendVerificationEmail(
                email: _authService.currentUser!.email!);
            if (result) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Verification email sent!')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to send verification email.')),
              );
            }
          },
          child: const Text('Resend Verification Email'),
        ),
      ),
    );
  }
}
