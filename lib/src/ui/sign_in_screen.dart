import 'package:flutter/material.dart';
import 'package:group_changing_app/src/services/auth_service.dart';
import 'package:group_changing_app/src/ui/forget_password_screen.dart';
import 'package:group_changing_app/src/ui/home_page_screen.dart';
import 'package:group_changing_app/src/ui/sign_up_screen.dart'; // Import the SignUpScreen
import 'package:group_changing_app/src/widgets/button_widget.dart';
import 'package:group_changing_app/src/widgets/input_field.dart';
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
    // if logged in redirect to HomePageScreen
    if (_isLoggedIn && _isEmailVerified) {
      return const HomePageScreen();
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                constraints: const BoxConstraints(maxWidth: 500),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Sign In',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enter your credentials to access your account',
                        style: TextStyle(fontSize: 16, color: Colors.white.withAlpha((255 * .6).toInt())),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      InputField(
                        labelText: 'Email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        // Remove errorText from InputField
                      ),
                      const SizedBox(height: 16),
                      InputField(
                        labelText: 'Password',
                        controller: _passwordController,
                        obscureText: true,
                        // Remove errorText from InputField
                      ),
                      const SizedBox(height: 24),
                      MyButton(
                        onPressed: _signIn,
                        buttonText: 'Sign In',
                      ),
                      const SizedBox(height: 24),
                      MyButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ForgetPasswordScreen()),
                          );
                        },
                        buttonText: 'Forgot Password?',
                      ),
                      const SizedBox(height: 24),
                      if (_isLoggedIn && !_isEmailVerified)
                        MyButton(
                          onPressed: _resendEmailVerification,
                          buttonText: 'Resend Verification Email',
                        ),
                      const SizedBox(height: 24),
                      // New Link Text
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignUpScreen()), // Navigate to SignUpScreen
                          );
                        },
                        child: const Text(
                          "Don't have an account? Sign Up",
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
