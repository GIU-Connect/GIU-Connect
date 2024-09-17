import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:group_changing_app/src/services/user_service.dart';
import 'package:group_changing_app/src/widgets/animated_button.dart';

class EditAccountInfoScreen extends StatefulWidget {
  EditAccountInfoScreen({super.key});

  @override
  State<EditAccountInfoScreen> createState() => _EditAccountInfoScreenState();
  User currentUser = FirebaseAuth.instance.currentUser!;
  EditAccountInfoService editor = EditAccountInfoService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
}

class _EditAccountInfoScreenState extends State<EditAccountInfoScreen> {
  void _showDialog({
    required String title,
    required Widget content,
    required VoidCallback onChange,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: content,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onChange();
                Navigator.of(context).pop();
              },
              child: const Text('Change'),
            ),
          ],
        );
      },
    );
  }

  void _changePhoneNumber() {
    _showDialog(
      title: 'Change Phone Number',
      content: const TextField(
        decoration: InputDecoration(hintText: 'Enter new phone number'),
        keyboardType: TextInputType.phone,
      ),
      onChange: () {
        // Implement the logic to change the phone number
      },
    );
  }

  void _changeUniversityId() {
    _showDialog(
      title: 'Change University ID',
      content: const TextField(
        decoration: InputDecoration(hintText: 'Enter new university ID'),
        keyboardType: TextInputType.text,
      ),
      onChange: () {
        // Implement the logic to change the university ID
      },
    );
  }

  void _changeCurrentTutorial() {
    _showDialog(
      title: 'Change Current Tutorial',
      content: const TextField(
        decoration: InputDecoration(hintText: 'Enter new tutorial'),
        keyboardType: TextInputType.text,
      ),
      onChange: () {
        // Implement the logic to change the current tutorial
      },
    );
  }

  void _changeName() {
    _showDialog(
      title: 'Change Name',
      content: const TextField(
        decoration: InputDecoration(hintText: 'Enter new name'),
        keyboardType: TextInputType.text,
      ),
      onChange: () {
        // Implement the logic to change the name
      },
    );
  }

  void _changeSemester() {
    _showDialog(
      title: 'Change Semester',
      content: const TextField(
        decoration: InputDecoration(hintText: 'Enter new semester'),
        keyboardType: TextInputType.text,
      ),
      onChange: () {
        // Implement the logic to change the semester
      },
    );
  }

  void _changeMajor() async {
    String selectedMajor = 'Computer Science';
    List<String> majors = [
      'Computer Science',
      'Electrical Engineering',
      'Mechanical Engineering',
      'Civil Engineering',
      'Business Administration',
      'Economics',
      'Psychology',
      'Biology',
      'Chemistry',
      'Physics'
    ];

    _showDialog(
      title: 'Change Major',
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return DropdownButton<String>(
            value: selectedMajor,
            onChanged: (String? newValue) {
              setState(() {
                selectedMajor = newValue!;
              });
            },
            items: majors.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          );
        },
      ),
      onChange: () {
        widget.editor.changeMajor(
          userId: widget.currentUser.uid,
          major: selectedMajor,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'Edit Account Info',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedHoverButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Change Email'),
                            content: const Text(
                                'Please contact the admin at aly.abdelmoneim@student.giu-uni.de to change your email address.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    text: 'Change email',
                  ),
                  const SizedBox(height: 20),
                  AnimatedHoverButton(
                    onPressed: () {
                      widget._auth.sendPasswordResetEmail(
                        email: widget.currentUser.email!,
                      );
                    },
                    text: 'Send Password Reset Email',
                  ),
                  const SizedBox(height: 20),
                  AnimatedHoverButton(
                    onPressed: _changePhoneNumber,
                    text: 'Change Phone Number',
                  ),
                  const SizedBox(height: 20),
                  AnimatedHoverButton(
                    onPressed: _changeUniversityId,
                    text: 'Change University ID',
                  ),
                  const SizedBox(height: 20),
                  AnimatedHoverButton(
                    onPressed: _changeCurrentTutorial,
                    text: 'Change Current Tutorial',
                  ),
                  const SizedBox(height: 20),
                  AnimatedHoverButton(
                    onPressed: _changeName,
                    text: 'Change Name',
                  ),
                  const SizedBox(height: 20),
                  AnimatedHoverButton(
                    onPressed: _changeSemester,
                    text: 'Change Semester',
                  ),
                  const SizedBox(height: 20),
                  AnimatedHoverButton(
                    onPressed: _changeMajor,
                    text: 'Change Major',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
