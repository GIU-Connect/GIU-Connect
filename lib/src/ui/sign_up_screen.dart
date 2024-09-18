import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'sign_in_screen.dart';
import '../widgets/input_field.dart';
import '../widgets/dropdown_widget.dart';
import '../widgets/button_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  late String email, password, confirmPassword, phoneNumber, universityId, currentTutorial, firstName, lastName;
  String? emailError, passwordError, phoneError, universityIdError, tutorialError, firstNameError, lastNameError;
  String? semester, major, germanLevel, englishLevel;
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
    firstName = '';
    lastName = '';

    resetErrorText();
  }

  void resetErrorText() {
    setState(() {
      emailError =
          passwordError = phoneError = universityIdError = tutorialError = firstNameError = lastNameError = null;
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
    if (firstName.isEmpty) {
      setState(() {
        firstNameError = 'Please enter your first name';
      });
      isValid = false;
    }
    if (lastName.isEmpty) {
      setState(() {
        lastNameError = 'Please enter your last name';
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
          name: '$firstName $lastName',
          semester: semester ?? '',
          germanLevel: germanLevel ?? '',
          englishLevel: englishLevel ?? '',
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
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 600;

          return Center(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 32,
                  vertical: 12,
                ),
                constraints: BoxConstraints(maxWidth: isMobile ? 400 : 500),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Create Account',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Sign up to get started!',
                      style: TextStyle(fontSize: 14, color: Colors.white.withAlpha((255 * .6).toInt())),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // First Name and Last Name in a Row
                    Row(
                      children: [
                        Expanded(
                          child: InputField(
                            labelText: 'First Name',
                            onChanged: (value) => setState(() => firstName = value),
                            errorText: firstNameError,
                            keyboardType: TextInputType.text,
                            autoFocus: true,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: InputField(
                            labelText: 'Last Name',
                            onChanged: (value) => setState(() => lastName = value),
                            errorText: lastNameError,
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    InputField(
                      labelText: 'Email',
                      onChanged: (value) => setState(() => email = value),
                      errorText: emailError,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),

                    // Password and Confirm Password in a Row
                    Row(
                      children: [
                        Expanded(
                          child: InputField(
                            labelText: 'Password',
                            onChanged: (value) => setState(() => password = value),
                            errorText: passwordError,
                            obscureText: true,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: InputField(
                            labelText: 'Confirm Password',
                            onChanged: (value) => setState(() => confirmPassword = value),
                            errorText: passwordError,
                            obscureText: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    InputField(
                      labelText: 'Phone Number',
                      onChanged: (value) => setState(() => phoneNumber = value),
                      errorText: phoneError,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),

                    InputField(
                      labelText: 'University ID',
                      onChanged: (value) => setState(() => universityId = value),
                      errorText: universityIdError,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 12),

                    InputField(
                      labelText: 'Current Tutorial',
                      onChanged: (value) => setState(() => currentTutorial = value),
                      errorText: tutorialError,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),

                    DropdownWidget(
                      hint: 'Major',
                      value: major,
                      items: const [
                        'Informatics and Computer Science',
                        'Engineering',
                        'Business Informatics',
                        'Business Administration',
                        'Pharmaceutical Engineering'
                      ],
                      onChanged: (value) => setState(() => major = value as String),
                    ),
                    const SizedBox(height: 12),

                    DropdownWidget(
                      hint: 'Semester',
                      value: semester,
                      items: const ['1', '2', '3', '4', '5', '6', '7', '8'],
                      onChanged: (value) => setState(() => semester = value as String),
                    ),
                    const SizedBox(height: 12),

                    DropdownWidget(
                      hint: 'German Level',
                      value: germanLevel,
                      items: const ['G1', 'G2', 'G3', 'G4', 'No German'],
                      onChanged: (value) => setState(() => germanLevel = value as String),
                    ),
                    const SizedBox(height: 12),

                    DropdownWidget(
                      hint: 'English Level',
                      value: englishLevel,
                      items: const ['AE', 'AS', 'SM', 'CPS', 'RPW', 'No English'],
                      onChanged: (value) => setState(() => englishLevel = value as String),
                    ),
                    const SizedBox(height: 16),

                    // Custom button
                    CustomButton(
                      onPressed: submit,
                      text: 'Sign Up',
                      isActive: true,
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 8),

                    if (isMobile)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SignInScreen()),
                              );
                            },
                            child: const Text(
                              'Already have an account? Sign In',
                              style: TextStyle(color: Colors.orange, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
