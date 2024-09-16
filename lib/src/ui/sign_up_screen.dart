import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'sign_in_screen.dart';
import '../widgets/input_field.dart';
import '../widgets/dropdown_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  late String email, password, confirmPassword, phoneNumber, universityId, currentTutorial, fullName;
  String? emailError, passwordError, phoneError, universityIdError, tutorialError, fullNameError;
  String? semester, major;
  bool isLoading = false;
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    email = '';
    password = '';
    confirmPassword = '';
    phoneNumber = '';
    universityId = '';
    currentTutorial = '';
    fullName = '';

    resetErrorText();
  }

  void resetErrorText() {
    setState(() {
      emailError = passwordError = phoneError = universityIdError = tutorialError = fullNameError = null;
    });
  }

  bool validate() {
    resetErrorText();

    bool isValid = true;
    if (email.isEmpty || !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      setState(() {
        emailError = 'Invalid email';
      });
      isValid = false;
    }
    if (password.isEmpty || password != confirmPassword) {
      setState(() {
        passwordError = password != confirmPassword ? 'Passwords do not match' : 'Please enter a password';
      });
      isValid = false;
    }
    if (phoneNumber.isEmpty) {
      setState(() {
        phoneError = 'Please enter a phone number';
      });
      isValid = false;
    }
    if (universityId.isEmpty) {
      setState(() {
        universityIdError = 'Please enter your university ID';
      });
      isValid = false;
    }
    if (currentTutorial.isEmpty) {
      setState(() {
        tutorialError = 'Please enter your current tutorial';
      });
      isValid = false;
    }
    if (fullName.isEmpty) {
      setState(() {
        fullNameError = 'Please enter your full name';
      });
      isValid = false;
    }

    return isValid;
  }

  Future<void> submit() async {
    if (validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        await authService.signUp(
          email: email,
          password: password,
          confirmPassword: confirmPassword,
          phoneNumber: phoneNumber,
          universityId: universityId,
          major: major ?? '',
          currentTutorial: currentTutorial,
          name: fullName,
          semester: semester ?? '',
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
              content: Text(e.toString(), style: const TextStyle(color: Colors.white)),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Create Account',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign up to get started!',
                      style: TextStyle(fontSize: 16, color: Colors.white.withAlpha((255 * .6).toInt())),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    InputField(
                      labelText: 'Full Name',
                      onChanged: (value) => setState(() => fullName = value),
                      errorText: fullNameError,
                      keyboardType: TextInputType.text,
                      autoFocus: true,
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      labelText: 'Email',
                      onChanged: (value) => setState(() => email = value),
                      errorText: emailError,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      labelText: 'Password',
                      onChanged: (value) => setState(() => password = value),
                      errorText: passwordError,
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      labelText: 'Confirm Password',
                      onChanged: (value) => setState(() => confirmPassword = value),
                      errorText: passwordError,
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      labelText: 'Phone Number',
                      onChanged: (value) => setState(() => phoneNumber = value),
                      errorText: phoneError,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      labelText: 'University ID',
                      onChanged: (value) => setState(() => universityId = value),
                      errorText: universityIdError,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      labelText: 'Current Tutorial',
                      onChanged: (value) => setState(() => currentTutorial = value),
                      errorText: tutorialError,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),
                    DropdownWidget(
                        hint: 'Choose Major',
                        value: major,
                        items: const [
                          'Informatics and Computer Science',
                          'Business Administration',
                          'Engineering',
                          'Pharmaceutical Engineering',
                          'Business Informatics',
                          'Architecture',
                        ],
                        onChanged: (value) => setState(() => major = value)),
                    const SizedBox(height: 16),
                    DropdownWidget(
                        hint: 'Choose Semester',
                        value: semester,
                        items: List.generate(8, (index) => (index + 1).toString()),
                        onChanged: (value) => setState(() => semester = value)),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 200, // Set the desired width
                      child: ElevatedButton(
                        onPressed: submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          textStyle: const TextStyle(fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Sign Up'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignInScreen()),
                        );
                      },
                      child: const Text(
                        'Already have an account? Sign In',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
