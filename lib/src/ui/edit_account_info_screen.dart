import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  void _changePhoneNumber() async {
    TextEditingController newPhoneNumberController = TextEditingController();

    _showDialog(
      title: 'Change Phone Number',
      content: TextField(
        controller: newPhoneNumberController,
        decoration: const InputDecoration(labelText: 'New Phone Number'),
      ),
      onChange: () {
        String newPhoneNumber = newPhoneNumberController.text;
        widget.editor.changePhoneNumber(
          userId: widget.currentUser.uid,
          oldPhoneNumber: '', // Placeholder since oldPhoneNumber is not used
          newPhoneNumber: newPhoneNumber,
        );
      },
    );
  }

  void _changeUniversityId() async {
    TextEditingController universityIdController = TextEditingController();

    _showDialog(
      title: 'Change University ID',
      content: TextField(
        controller: universityIdController,
        decoration: const InputDecoration(labelText: 'New University ID'),
      ),
      onChange: () {
        String newUniversityId = universityIdController.text;
        widget.editor.changeUniversityId(
          userId: widget.currentUser.uid,
          universityId: newUniversityId,
        );
      },
    );
  }

  void _changeCurrentTutorial() async {
    TextEditingController currentTutorialController = TextEditingController();

    _showDialog(
      title: 'Change Current Tutorial',
      content: TextField(
        controller: currentTutorialController,
        decoration: const InputDecoration(labelText: 'New Tutorial Number'),
      ),
      onChange: () {
        String newTutorial = currentTutorialController.text;
        widget.editor.changeCurrentTutorial(
          userId: widget.currentUser.uid,
          currentTutorial: newTutorial,
        );
      },
    );
  }

  void _changeName() async {
    TextEditingController nameController = TextEditingController();

    _showDialog(
      title: 'Change Name',
      content: TextField(
        controller: nameController,
        decoration: const InputDecoration(labelText: 'New Name'),
      ),
      onChange: () {
        String newName = nameController.text;
        widget.editor.changeName(
          userId: widget.currentUser.uid,
          name: newName,
        );
      },
    );
  }

  void _changeSemester() async {
    TextEditingController semesterController = TextEditingController();

    _showDialog(
      title: 'Change Semester',
      content: TextField(
        controller: semesterController,
        decoration: const InputDecoration(labelText: 'New Semester No.'),
      ),
      onChange: () {
        String newSemester = semesterController.text;
        widget.editor.changeSemester(
          userId: widget.currentUser.uid,
          semester: newSemester,
        );
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
      content: DropdownButton<String>(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
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
            const SizedBox(height: 10),
            CustomButton(
              onPressed: () {
                widget._auth.sendPasswordResetEmail(
                  email: widget.currentUser.email!,
                );
              },
              text: 'Send Password Reset userId',
              isActive: true,
            ),
            const SizedBox(height: 10),
            CustomButton(
              onPressed: _changePhoneNumber,
              text: 'Change Phone Number',
              isActive: true,
            ),
            const SizedBox(height: 10),
            CustomButton(
              onPressed: _changeUniversityId,
              text: 'Change University ID',
              isActive: true,
            ),
            const SizedBox(height: 10),
            CustomButton(
              onPressed: _changeCurrentTutorial,
              text: 'Change Current Tutorial',
              isActive: true,
            ),
            const SizedBox(height: 10),
            CustomButton(
              onPressed: _changeName,
              text: 'Change Name',
              isActive: true,
            ),
            const SizedBox(height: 10),
            CustomButton(
              onPressed: _changeSemester,
              text: 'Change Semester',
              isActive: true,
            ),
            const SizedBox(height: 10),
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
