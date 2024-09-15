import 'package:flutter/material.dart';
import 'package:group_changing_app/src/services/auth_service.dart';
import 'package:group_changing_app/src/ui/forget_password_screen.dart';
import 'package:group_changing_app/src/ui/home_page_screen.dart';
import 'package:group_changing_app/src/widgets/my_button.dart';
import 'package:group_changing_app/src/widgets/my_textfield.dart';
import 'package:group_changing_app/src/utils/no_animation_page_route.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _isEmailVerified = false;
  bool _isLoggedIn = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkUserStatus() async {
    final user = _authService.currentUser;
    if (user != null) {
      setState(() {
        _isLoggedIn = true;
        _isEmailVerified = user.emailVerified;
      });
    } else {
      setState(() {
        _isLoggedIn = false;
      });
    }
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      try {
        await _authService.signIn(email: email, password: password);
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePageScreen()),
          );
        }
      } catch (e) {
        _checkUserStatus();
        if (mounted) {
          Navigator.pushReplacement(
            context,
            NoAnimationPageRoute(pageBuilder: (context, animation, secondaryAnimation) => const SignInScreen()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Sign in failed: ${e.toString()}',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _resendEmailVerification() async {
    final email = _emailController.text.trim();
    try {
      await _authService.resendVerificationEmail(email: email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Verification email resent. Please check your inbox.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to resend verification email: ${e.toString()}',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkUserStatus();
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      MyTextField(
                        controller: _emailController,
                        hintText: 'Email',
                        obscureText: false,
                        validator: (value) => value == null || value.isEmpty ? 'Please enter your email' : null,
                      ),
                      const SizedBox(height: 20),
                      MyTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        obscureText: true,
                        validator: (value) => value == null || value.isEmpty ? 'Please enter your password' : null,
                      ),
                      const SizedBox(height: 20),
                      MyButton(
                        onTap: _signIn,
                        buttonName: 'Sign In',
                      ),
                      const SizedBox(height: 20),
                      MyButton(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ForgetPasswordScreen()),
                          );
                        },
                        buttonName: 'Forgot Password?',
                      ),
                      const SizedBox(height: 20),
                      // Show resend email verification button if logged in but email not verified
                      if (_isLoggedIn && !_isEmailVerified)
                        MyButton(
                          onTap: _resendEmailVerification,
                          buttonName: 'Resend Verification Email',
                        ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
