import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:group_changing_app/src/services/user_service.dart';
import 'package:group_changing_app/src/widgets/button_widget.dart';

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
      content: TextField(
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
      content: TextField(
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
      content: TextField(
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
      content: TextField(
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
      content: TextField(
        decoration: InputDecoration(hintText: 'Enter new semester'),
        keyboardType: TextInputType.text,
      ),
      onChange: () {
        // Implement the logic to change the semester
      },
    );
  }

  // Implementing the _changeMajor method
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center buttons vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center buttons horizontally
          children: [
            CustomButton(
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
              isActive: true,
            ),
            const SizedBox(height: 20), // Add space between buttons
            CustomButton(
              onPressed: () {
                widget._auth.sendPasswordResetEmail(
                  email: widget.currentUser.email!,
                );
              },
              text: 'Send Password Reset Email',
              isActive: true,
            ),
            const SizedBox(height: 20),
            CustomButton(
              onPressed: _changePhoneNumber,
              text: 'Change Phone Number',
              isActive: true,
            ),
            const SizedBox(height: 20),
            CustomButton(
              onPressed: _changeUniversityId,
              text: 'Change University ID',
              isActive: true,
            ),
            const SizedBox(height: 20),
            CustomButton(
              onPressed: _changeCurrentTutorial,
              text: 'Change Current Tutorial',
              isActive: true,
            ),
            const SizedBox(height: 20),
            CustomButton(
              onPressed: _changeName,
              text: 'Change Name',
              isActive: true,
            ),
            const SizedBox(height: 20),
            CustomButton(
              onPressed: _changeSemester,
              text: 'Change Semester',
              isActive: true,
            ),
            const SizedBox(height: 20),
            CustomButton(
              onPressed: _changeMajor,
              text: 'Change Major',
              isActive: true,
            ),
          ],
        ),
      ),
    ));
  }
}
