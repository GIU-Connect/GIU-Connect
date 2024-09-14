import 'package:flutter/material.dart';
import 'package:group_changing_app/src/services/auth_service.dart';
import 'package:group_changing_app/src/ui/sign_in_screen.dart';
import 'package:group_changing_app/src/widgets/my_button.dart';
import 'package:group_changing_app/src/widgets/my_textfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _universityIdController = TextEditingController();
  final _currentTutorialController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  String semester = '1';

  String major = 'CS';

  final _authService = AuthService();

  void _signUp() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final phoneNumber = _phoneNumberController.text;
    final universityId = _universityIdController.text;
    final currentTutorial = _currentTutorialController.text;
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    final semester = this.semester;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    try {
      await _authService.signUp(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
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
    } catch (e) {
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
            MyTextField(
              controller: _firstNameController,
              hintText: 'First Name',
              obscureText: false,
            ),
            MyTextField(
              controller: _lastNameController,
              hintText: 'Last Name',
              obscureText: false,
            ),
            MyTextField(
              controller: _emailController,
              hintText: 'Email',
              obscureText: false,
            ),
            MyTextField(
              controller: _passwordController,
              hintText: 'Password',
              obscureText: true,
            ),
            MyTextField(
              controller: _confirmPasswordController,
              hintText: 'Confirm Password',
              obscureText: true,
            ),
            MyTextField(
              controller: _phoneNumberController,
              hintText: 'Phone Number',
              obscureText: false,
            ),
            MyTextField(
              controller: _universityIdController,
              hintText: 'University ID',
              obscureText: false,
            ),
            MyTextField(
              controller: _currentTutorialController,
              hintText: 'Current Tutorial',
              obscureText: false,
            ),
            // Dropdown for Major
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(hintText: 'Major'),
              value: major,
              items: [
                'CS',
                'BA',
                'Engineering',
                'Pharmaceutical Engineering',
                'BI',
                'Architecture'
              ]
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
              decoration: const InputDecoration(hintText: 'Semester'),
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
            MyButton(onTap: _signUp, buttonName: 'Sign Up'),
            const SizedBox(height: 20),
            // Already have an account
            MyButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                );
              },
              buttonName: 'Already have an account? Sign In',
            ),
          ],
        ),
      ),
    );
  }
  
}
