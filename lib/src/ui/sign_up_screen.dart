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
  final _currentTutorialController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  String semester = '1';


  String major = 'CS';
  // String englishLevel = 'AE';
  // String germanLevel = 'G1';

  final _authService = AuthService();

  void _signUp() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final phoneNumber = _phoneNumberController.text;
    final universityId = _universityIdController.text;
    final currentTutorial = _currentTutorialController.text;
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    final semester = this.semester;

    try {
      await _authService.signUp(
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        universityId: universityId,
        major: major,
        currentTutorial: currentTutorial,
        firstName: firstName,
        lastName: lastName,
        semester: semester,
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
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name')),
            TextField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name')),
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
                controller: _currentTutorialController,
                decoration: const InputDecoration(labelText: 'Current Tutorial')),

            // Dropdown for Major
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Major'),
              value: major,
              items: ['CS', 'BA', 'Engineering', 'Pharmaceutical Engineering', 'BI', 'Architecture']
                  .map((major) => DropdownMenuItem(
                        value: major,
                        child: Text(major),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  major = value!;
                });
              },
            ),
            // Dropdown for Semester
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Semester'),
              value: semester,
              items: List.generate(8, (index) => (index + 1).toString())
                  .map((semester) => DropdownMenuItem(
                        value: semester,
                        child: Text(semester),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  semester = value!;
                });
              },
            ),
            

            const SizedBox(height: 20),
            ElevatedButton(onPressed: _signUp, child: const Text('Sign Up')),

            // Already have an account
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
