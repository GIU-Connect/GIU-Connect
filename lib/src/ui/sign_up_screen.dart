import 'package:flutter/material.dart';
import 'package:group_changing_app/src/services/auth_service.dart';


class SignUpScreen extends StatefulWidget {
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
      // Show success message or navigate to another screen
    } catch (e) {
      // Show error message
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: _passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            TextField(controller: _phoneNumberController, decoration: InputDecoration(labelText: 'Phone Number')),
            TextField(controller: _universityIdController, decoration: InputDecoration(labelText: 'University ID')),
            TextField(controller: _majorController, decoration: InputDecoration(labelText: 'Major')),
            TextField(controller: _currentTutorialController, decoration: InputDecoration(labelText: 'Current Tutorial')),
            TextField(controller: _englishLevelController, decoration: InputDecoration(labelText: 'English Level')),
            TextField(controller: _germanLevelController, decoration: InputDecoration(labelText: 'German Level')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _signUp, child: Text('Sign Up')),
          ],
        ),
      ),
    );
  }
}