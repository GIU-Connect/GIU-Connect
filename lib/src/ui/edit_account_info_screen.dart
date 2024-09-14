import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_changing_app/src/services/edit_account_info_service.dart';
import 'package:group_changing_app/src/widgets/my_button.dart';

class EditAccountInfoScreen extends StatefulWidget {
  EditAccountInfoScreen({super.key});

  @override
  State<EditAccountInfoScreen> createState() => _EditAccountInfoScreenState();
  User currentUser = FirebaseAuth.instance.currentUser!;
  EditAccountInfoService editor = EditAccountInfoService();
  FirebaseAuth _auth = FirebaseAuth.instance;
}

class _EditAccountInfoScreenState extends State<EditAccountInfoScreen> {
  // void _changePassword() async {
  //   widget._auth.sendPasswordResetuserId(user.userId!);
  // }
  void _changePhoneNumber() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController oldPhoneNumberController =
            TextEditingController();
        TextEditingController newPhoneNumberController =
            TextEditingController();

        return AlertDialog(
          title: const Text('Change Phone Number'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPhoneNumberController,
                decoration: const InputDecoration(labelText: 'Old Phone Number'),
              ),
              TextField(
                controller: newPhoneNumberController,
                decoration: const InputDecoration(labelText: 'New Phone Number'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String oldPhoneNumber = oldPhoneNumberController.text;
                String newPhoneNumber = newPhoneNumberController.text;
                widget.editor.changePhoneNumber(
                  userId: widget.currentUser.uid,
                  oldPhoneNumber: oldPhoneNumber,
                  newPhoneNumber: newPhoneNumber,
                );
                Navigator.of(context).pop();
              },
              child: const Text('Change'),
            ),
          ],
        );
      },
    );
  }

  void _changeUniversityId() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController universityIdController = TextEditingController();

        return AlertDialog(
          title: const Text('Change University ID'),
          content: TextField(
            controller: universityIdController,
            decoration: const InputDecoration(labelText: 'New University ID'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String newUniversityId = universityIdController.text;
                widget.editor.changeUniversityId(
                  userId: widget.currentUser.uid,
                  universityId: newUniversityId,
                );
                Navigator.of(context).pop();
              },
              child: const Text('Change'),
            ),
          ],
        );
      },
    );
  }

  void _changeCurrentTutorial() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController currentTutorialController =
            TextEditingController();

        return AlertDialog(
          title: const Text('Change Current Tutorial'),
          content: TextField(
            controller: currentTutorialController,
            decoration: const InputDecoration(labelText: 'New Tutorial Number'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String newTutorial = currentTutorialController.text;
                widget.editor.changeCurrentTutorial(
                  userId: widget.currentUser.uid,
                  currentTutorial: newTutorial,
                );
                Navigator.of(context).pop();
              },
              child: const Text('Change'),
            ),
          ],
        );
      },
    );
  }

  void _changeFirstName() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController semesterController = TextEditingController();

        return AlertDialog(
          title: const Text('Change First Name'),
          content: TextField(
            controller: semesterController,
            decoration: const InputDecoration(labelText: 'New First Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String newFirstName = semesterController.text;
                widget.editor.changeFirstName(
                  userId: widget.currentUser.uid,
                  firstName: newFirstName,
                );
                Navigator.of(context).pop();
              },
              child: const Text('Change'),
            ),
          ],
        );
      },
    );
  }

  void _changeLastName() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController lastNameController = TextEditingController();

        return AlertDialog(
          title: const Text('Change Last Name'),
          content: TextField(
            controller: lastNameController,
            decoration: const InputDecoration(labelText: 'New Last Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String newFirstName = lastNameController.text;
                widget.editor.changeLastName(
                  userId: widget.currentUser.uid,
                  lastName: newFirstName,
                );
                Navigator.of(context).pop();
              },
              child: const Text('Change'),
            ),
          ],
        );
      },
    );
  }

  void _changeSemester() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController semesterController = TextEditingController();

        return AlertDialog(
          title: const Text('Change Semester'),
          content: TextField(
            controller: semesterController,
            decoration: const InputDecoration(labelText: 'New Semester No.'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String newSemester = semesterController.text;
                widget.editor.changeSemester(
                  userId: widget.currentUser.uid,
                  semester: newSemester,
                );
                Navigator.of(context).pop();
              },
              child: const Text('Change'),
            ),
          ],
        );
      },
    );
  }

  void _changeMajor() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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

        return AlertDialog(
          title: const Text('Change Major'),
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
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                widget.editor.changeMajor(
                  userId: widget.currentUser.uid,
                  major: selectedMajor,
                );
                Navigator.of(context).pop();
              },
              child: const Text('Change'),
            ),
          ],
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
            MyButton(
              onTap: () {
                widget._auth
                    .sendPasswordResetEmail(email: widget.currentUser.email!);
              },
              buttonName: 'Send Password Reset userId',
            ),
            const SizedBox(height: 10),
            MyButton(
              onTap: _changePhoneNumber,
              buttonName: 'Change Phone Number',
            ),
            const SizedBox(height: 10),
            MyButton(
              onTap: _changeUniversityId,
              buttonName: 'Change University ID',
            ),
            const SizedBox(height: 10),
            MyButton(
              onTap: _changeCurrentTutorial,
              buttonName: 'Change Current Tutorial',
            ),
            const SizedBox(height: 10),
            MyButton(
              onTap: _changeFirstName,
              buttonName: 'Change First Name',
            ),
            const SizedBox(height: 10),
            MyButton(
              onTap: _changeLastName,
              buttonName: 'Change Last Name',
            ),
            const SizedBox(height: 10),
            MyButton(
              onTap: _changeSemester,
              buttonName: 'Change Semester',
            ),
            const SizedBox(height: 10),
            MyButton(
              onTap: _changeMajor,
              buttonName: 'Change Major',
            ),
          ],
        ),
      ),
    ));
  }
}
