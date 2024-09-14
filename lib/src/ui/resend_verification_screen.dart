import 'package:flutter/material.dart';
import 'package:group_changing_app/src/services/auth_service.dart';

class ResendVerificationScreen extends StatelessWidget {

  final AuthService _authService = AuthService();

  ResendVerificationScreen({super.key}); // Initialize your auth service



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
/**

 * routes 
 * email service to send email to the request sender when he get a match
 
 * (((((exception handler)))))
 * 
 * search on hosting on firebase 
 */
