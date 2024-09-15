import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_changing_app/src/services/add_request_service.dart';
import 'package:group_changing_app/src/widgets/my_button.dart';
import 'home_page_screen.dart';
import 'package:group_changing_app/src/widgets/my_textfield.dart';

class AddRequestPage extends StatefulWidget {
  const AddRequestPage({super.key});

  @override
  _AddRequestPageState createState() => _AddRequestPageState();
}

class _AddRequestPageState extends State<AddRequestPage> {
  final TextEditingController desiredTutController = TextEditingController();
  String selectedEnglish = 'AE';
  String selectedGerman = 'G1';
  final AddRequestService _addRequestService = AddRequestService();

  void addRequest() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    if (desiredTutController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

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
    final name = userDoc['name'] as String;
    final currentTutNo = userDoc['currentTutorial'] as String;
    final major = userDoc['major'] as String;
    final semester = userDoc['semester'] as String;
    final phoneNumber = userDoc['phoneNumber'] as String;

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
      semester: semester,
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePageScreen()),
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
            MyTextField(
              controller: desiredTutController,
              hintText: 'Desired Tutorial No.',
              obscureText: false,
            ),

            const SizedBox(height: 20),

            // Dropdown for English Level with consistent width
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
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
              ),
            ),

            const SizedBox(height: 20),

            // Dropdown for German Level with consistent width
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
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
              ),
            ),

            const SizedBox(height: 20),

            // Submit button
            MyButton(
              onTap: addRequest,
              buttonName: 'Submit Request',
            ),
          ],
        ),
      ),
    );
  }
}
