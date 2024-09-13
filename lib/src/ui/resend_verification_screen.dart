import 'package:flutter/material.dart';
import 'package:group_changing_app/src/services/auth_service.dart';

class ResendVerificationScreen extends StatelessWidget {
  final AuthService _authService = AuthService(); // Initialize your auth service

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resend Verification Email'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            bool result = await _authService.resendVerificationEmail(email: _authService.currentUser!.email!);  
            if (result) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Verification email sent!')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to send verification email.')),
              );
            }
          },
          child: Text('Resend Verification Email'),
        ),
      ),
    );
  }
}