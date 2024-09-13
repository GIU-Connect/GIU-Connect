
import 'package:flutter/material.dart';
import 'package:group_changing_app/src/services/auth_service.dart';
import 'package:group_changing_app/src/ui/sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _universityIdController = TextEditingController();
  final _majorController = TextEditingController();
  final _currentTutorialController = TextEditingController();
  final _englishLevelController = TextEditingController();
  final _germanLevelController = TextEditingController();

  final _authService = AuthService();

  void _signUp() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final phoneNumber = _phoneNumberController.text;
    final universityId = _universityIdController.text;
    final major = _majorController.text;
    final currentTutorial = _currentTutorialController.text;
    final englishLevel = _englishLevelController.text;
    final germanLevel = _germanLevelController.text;

    try {
      await _authService.signUp(
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        universityId: universityId,
        major: major,
        currentTutorial: currentTutorial,
        englishLevel: englishLevel,
        germanLevel: germanLevel,
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      );
      // Show success message or navigate to another screen
    } catch (e) {
      // Show error message
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email')),
            TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true),
            TextField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(labelText: 'Phone Number')),
            TextField(
                controller: _universityIdController,
                decoration: const InputDecoration(labelText: 'University ID')),
            TextField(
                controller: _majorController,
                decoration: const InputDecoration(labelText: 'Major')),
            TextField(
                controller: _currentTutorialController,
                decoration: const InputDecoration(labelText: 'Current Tutorial')),
            TextField(
                controller: _englishLevelController,
                decoration: const InputDecoration(labelText: 'English Level')),
            TextField(
                controller: _germanLevelController,
                decoration: const InputDecoration(labelText: 'German Level')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _signUp, child: const Text('Sign Up')),

            //already have an account
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                );
              },
              child: const Text('Already have an account? Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}

