import 'package:flutter/material.dart';
import 'package:group_changing_app/src/services/auth_service.dart';
import 'package:group_changing_app/src/ui/home_page_screen.dart';
import 'package:group_changing_app/src/ui/sign_in_screen.dart';
import 'package:group_changing_app/src/widgets/my_button.dart';
import 'package:group_changing_app/src/widgets/my_textfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _universityIdController = TextEditingController();
  final TextEditingController _currentTutorialController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();

  String? _semester;
  String? _major;
  bool _isLoading = true;

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfLoggedIn();
    });
  }

  Future<void> _checkIfLoggedIn() async {
    if (_authService.currentUser != null && _authService.currentUser!.emailVerified) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePageScreen()),
        );
      }
    } else if (_authService.currentUser != null && !_authService.currentUser!.emailVerified) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please verify your email')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        );
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final confirmPassword = _confirmPasswordController.text.trim();
      final phoneNumber = _phoneNumberController.text.trim();
      final universityId = _universityIdController.text.trim();
      final currentTutorial = _currentTutorialController.text.trim();
      final fullName = _fullNameController.text.trim();

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
          major: _major ?? '',
          currentTutorial: currentTutorial,
          name: fullName,
          semester: _semester ?? '',
        );
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignInScreen()),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                // Display the message without exception type
                e.toString(),
                style: const TextStyle(color: Colors.white), // Set text color to white for contrast
              ),
              backgroundColor: Colors.red, // Set snackbar background color to red
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
            appBar: AppBar(title: const Text('Sign Up')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      MyTextField(
                        controller: _fullNameController,
                        hintText: 'Full Name',
                        obscureText: false,
                        validator: (value) => value == null || value.isEmpty ? 'Please enter your full name' : null,
                      ),
                      MyTextField(
                        controller: _emailController,
                        hintText: 'Email',
                        obscureText: false,
                        validator: (value) => value == null || value.isEmpty ? 'Please enter your email' : null,
                      ),
                      MyTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        obscureText: true,
                        validator: (value) => value == null || value.isEmpty ? 'Please enter your password' : null,
                      ),
                      MyTextField(
                        controller: _confirmPasswordController,
                        hintText: 'Confirm Password',
                        obscureText: true,
                        validator: (value) => value == null || value.isEmpty ? 'Please confirm your password' : null,
                      ),
                      MyTextField(
                        controller: _phoneNumberController,
                        hintText: 'Phone Number',
                        obscureText: false,
                        validator: (value) => value == null || value.isEmpty ? 'Please enter your phone number' : null,
                      ),
                      MyTextField(
                        controller: _universityIdController,
                        hintText: 'University ID',
                        obscureText: false,
                        validator: (value) => value == null || value.isEmpty ? 'Please enter your university ID' : null,
                      ),
                      MyTextField(
                        controller: _currentTutorialController,
                        hintText: 'Current Tutorial',
                        obscureText: false,
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Please enter your current tutorial' : null,
                      ),
                      _buildDropdown(
                        'Choose Major',
                        _major,
                        [
                          'Informatics and Computer Science',
                          'Business Administration',
                          'Engineering',
                          'Pharmaceutical Engineering',
                          'Business Informatics',
                          'Architecture',
                        ],
                        (value) {
                          setState(() {
                            _major = value;
                          });
                        },
                      ),
                      _buildDropdown(
                        'Choose Semester',
                        _semester,
                        List.generate(8, (index) => (index + 1).toString()),
                        (value) {
                          setState(() {
                            _semester = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      MyButton(onTap: _signUp, buttonName: 'Sign Up'),
                      const SizedBox(height: 20),
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
              ),
            ),
          );
  }

  Widget _buildDropdown(
    String hint,
    String? value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
        value: value,
        items: items
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                ))
            .toList(),
        onChanged: onChanged,
        validator: (value) => value == null ? 'Please select $hint' : null,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneNumberController.dispose();
    _universityIdController.dispose();
    _currentTutorialController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }
}
