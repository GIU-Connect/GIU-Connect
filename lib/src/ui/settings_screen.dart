import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:group_changing_app/src/ui/my_requests_screen.dart';
import 'package:group_changing_app/src/ui/sign_up_screen.dart';
import 'package:group_changing_app/src/widgets/my_button.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
  FirebaseAuth _auth = FirebaseAuth.instance;
  User currentUser = FirebaseAuth.instance.currentUser!;
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black, // Set the AppBar background color to black
          title: const Text(
            'Settings',
            style: TextStyle(
                color: Colors.white, // Set the text color to white
              fontWeight: FontWeight.bold, // Set the font to bold
              fontSize: 20,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0), // Padding for better spacing
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align items to the left
            children: [
              const SizedBox(height: 20),

              // Display the user's email in a modern text style
              Text(
                'Email: ${widget.currentUser.email}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 30),

              // Sign Out Button
              MyButton(
                onTap: () {
                  widget._auth.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const SignUpScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
                buttonName: 'Sign Out',
              ),

              const SizedBox(height: 20),

              // Send Password Reset Email Button
              MyButton(
                onTap: () {
                  widget._auth.sendPasswordResetEmail(
                      email: widget.currentUser.email!);
                },
                buttonName: 'Send Password Reset Email',
              ),

              const SizedBox(height: 20),

              // Resend Email Verification Button
              MyButton(
                onTap: () {
                  widget._auth.currentUser!.sendEmailVerification();
                },
                buttonName: 'Resend Email Verification',
              ),

              const SizedBox(height: 20),

              // Navigate to My Requests screen
              MyButton(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MyRequestsScreen()),
                  );
                },
                buttonName: 'My Requests',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
