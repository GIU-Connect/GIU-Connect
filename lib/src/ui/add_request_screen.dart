import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_changing_app/src/services/request_service.dart';
import 'package:group_changing_app/src/widgets/button_widget.dart';
import 'package:group_changing_app/src/widgets/input_field.dart'; // Ensure this widget is available
import 'package:group_changing_app/src/widgets/dropdown_widget.dart'; // Ensure this widget is available
import 'home_page_screen.dart';

class AddRequestPage extends StatefulWidget {
  const AddRequestPage({super.key});

  @override
  AddRequestPageState createState() => AddRequestPageState();
}

class AddRequestPageState extends State<AddRequestPage> {
  final TextEditingController desiredTutController = TextEditingController();
  String selectedEnglish = 'AE';
  String selectedGerman = 'G1';
  final RequestService _addRequestService = RequestService();
  bool isLoading = false;

  void addRequest() async {
    try {
      setState(() {
        isLoading = true;
      });

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        showError('User not logged in');
        return;
      }

      if (desiredTutController.text.isEmpty) {
        showError('Please fill all fields');
        return;
      }

      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        showError('User data not found');
        return;
      }
      final name = userDoc['name'] as String;
      final currentTutNo = userDoc['currentTutorial'] as String;
      final major = userDoc['major'] as String;
      final semester = userDoc['semester'] as String;
      final phoneNumber = userDoc['phoneNumber'] as String;

      if (currentTutNo.toString() == desiredTutController.text) {
        showError('Current and Desired Tutorial Numbers cannot be the same');
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

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePageScreen()),
        );
      }
    } catch (e) {
      showError(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
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
                      'Add Request',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    InputField(
                      controller: desiredTutController,
                      labelText: 'Desired Tutorial No.',
                      errorText: null,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    DropdownWidget(
                      hint: 'Choose English Level',
                      value: selectedEnglish,
                      items: const ['AE', 'AS', 'SM', 'CPS', 'RPW', 'No English'],
                      onChanged: (value) => setState(() => selectedEnglish = value as String),
                    ),
                    const SizedBox(height: 16),
                    DropdownWidget(
                      hint: 'Choose German Level',
                      value: selectedGerman,
                      items: const ['G1', 'G2', 'G3', 'G4', 'No German'],
                      onChanged: (value) => setState(() => selectedGerman = value as String),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 200,
                      child: CustomButton(
                        onPressed: addRequest,
                        text: 'Submit Request',
                        isActive: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
