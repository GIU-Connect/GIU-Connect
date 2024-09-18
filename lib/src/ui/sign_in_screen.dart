import 'package:flutter/material.dart';
import 'package:group_changing_app/src/services/auth_service.dart';
import 'package:group_changing_app/src/ui/forget_password_screen.dart';
import 'package:group_changing_app/src/ui/home_page_screen.dart';
import 'package:group_changing_app/src/ui/sign_up_screen.dart';
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
    if (_isLoggedIn && _isEmailVerified) {
      return const HomePageScreen();
    }
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Check if the device is a mobile or a larger screen (tablet/desktop)
          bool isMobile = constraints.maxWidth < 600;

          return Center(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 32, // Adjust padding based on screen size
                  vertical: 12,
                ),
                constraints: BoxConstraints(maxWidth: isMobile ? 400 : 500), // Adjust width for larger screens
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: isMobile ? 20 : 24, // Larger font for bigger screens
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Enter your credentials to access your account',
                        style: TextStyle(
                          fontSize: isMobile ? 14 : 16, // Slightly larger for bigger screens
                          color: Colors.white.withAlpha((255 * .6).toInt()),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      InputField(
                        labelText: 'Email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 12),
                      InputField(
                        labelText: 'Password',
                        controller: _passwordController,
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          onPressed: _signIn,
                          text: 'Sign In',
                          isActive: true,
                          isLoading: _isLoading,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Conditional rendering based on isMobile
                      if (isMobile)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ForgetPasswordScreen()),
                                );
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(color: Colors.orange),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                                );
                              },
                              child: const Text(
                                "Don't have an account? Sign Up",
                                style: TextStyle(color: Colors.orange),
                              ),
                            ),
                          ],
                        )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ForgetPasswordScreen()),
                                );
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(color: Colors.orange),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                                );
                              },
                              child: const Text(
                                "Don't have an account? Sign Up",
                                style: TextStyle(color: Colors.orange),
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 16),
                      if (_isLoggedIn && !_isEmailVerified)
                        CustomButton(
                          onPressed: _resendEmailVerification,
                          text: 'Resend Verification Email',
                          isActive: true,
                          isLoading: _isLoading,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
