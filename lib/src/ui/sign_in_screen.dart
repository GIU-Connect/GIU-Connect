import 'package:flutter/material.dart';
import 'package:group_changing_app/src/services/auth_service.dart';
import 'package:group_changing_app/src/ui/forget_password_screen.dart';
import 'package:group_changing_app/src/ui/home_page_screen.dart';
import 'package:group_changing_app/src/widgets/my_button.dart';
import 'package:group_changing_app/src/widgets/my_textfield.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
  
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      try {
        await _authService.signIn(email: email, password: password);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePageScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign in failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  MyTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    obscureText: false,
                    
                  ),
                  const SizedBox(height: 20),
                  MyTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    
                  ),
                  const SizedBox(height: 20),
                  MyButton(
                    onTap: _signIn,
                    buttonName: 'Sign In',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Handle forgot password logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Forgot Password tapped')),
                );
              },
              child: MyButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ForgetPasswordScreen()),
                  );
                },
                buttonName: 'Forgot Password?',
              ),
              
            ),
          ],
        ),
      ),
    );
  }
}
