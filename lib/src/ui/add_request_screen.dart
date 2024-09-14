import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:group_changing_app/src/services/add_request_service.dart';
import 'home_page_screen.dart';

class AddRequestPage extends StatefulWidget {
  const AddRequestPage({super.key});

  @override
  _AddRequestPageState createState() => _AddRequestPageState();
}

class _AddRequestPageState extends State<AddRequestPage> {
  //class variables
  // final TextEditingController currentTutController = TextEditingController();
  final TextEditingController desiredTutController = TextEditingController();
  // String selectedMajor = 'CS';
  String selectedEnglish = 'AE';
  String selectedGerman = 'G1';
  final AddRequestService _addRequestService = AddRequestService();
  // addRequest method that uses the AddRequestService to add a request
  void addRequest() async {
    // Ensure the user is logged in
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    // Check if the current and desired tutorial numbers are not empty
    if (desiredTutController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    // Fetch the user's name from Firestore
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    if (!userDoc.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User data not found')),
      );
      return;
    }
    final firstName = userDoc['firstName'] as String;
    final lastName = userDoc['lastName'] as String;
    final currentTutNo = userDoc['currentTutorial'] as String;
    final major = userDoc['major'] as String;
    final semester = userDoc['semester'] as String;
    final phoneNumber = userDoc['phoneNumber'] as String;
    final name = '$firstName $lastName';
    

    // Check if the current and desired tutorial numbers are not the same
    if (currentTutNo.toString() == desiredTutController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Current and Desired Tutorial Numbers cannot be the same')),
      );
      return;
    }

    await _addRequestService.addRequest(
        phoneNumber: phoneNumber,
        userId: user.uid,
        name: name,
        major: major,
        currentTutNo: int.parse(currentTutNo),
        desiredTutNo: int.parse(desiredTutController.text),
        englishLevel: selectedEnglish,
        germanLevel: selectedGerman,
        semester: semester);

    // Navigate to the home page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePageScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Request Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Add a TextField for the desired tutorial number
            TextField(
              controller: desiredTutController,
              decoration:
                  const InputDecoration(labelText: 'Desired Tutorial No.'),
            ),

            // Add a DropdownButton for the user's English level
            DropdownButton<String>(
              value: selectedEnglish,
              onChanged: (String? newValue) {
                setState(() {
                  selectedEnglish = newValue!;
                });
              },
              items: <String>['AE', 'AS', 'SM', 'CPS', 'RPW', 'No English']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),

            // Add a DropdownButton for the user's German level
            DropdownButton<String>(
              value: selectedGerman,
              onChanged: (String? newValue) {
                setState(() {
                  selectedGerman = newValue!;
                });
              },
              items: <String>['G1', 'G2', 'G3', 'G4', 'No German']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),

            // Add a button to submit the request
            ElevatedButton(
              onPressed: addRequest,
              child: const Text('Submit Request'),
            ),
          ],
        ),
      ),
    );
  }
}
