import 'package:flutter/material.dart';
class AddRequestPage extends StatefulWidget {
  const AddRequestPage({super.key});

  @override
  _AddRequestPageState createState() => _AddRequestPageState();
}

class _AddRequestPageState extends State<AddRequestPage> {
  final TextEditingController currentTutController = TextEditingController();
  final TextEditingController desiredTutController = TextEditingController();
  String selectedMajor = 'CS';
  String selectedEnglish = 'AE';
  String selectedGerman = 'G1';

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
            TextField(
              controller: currentTutController,
              decoration: const InputDecoration(labelText: 'Current Tutorial No.'),
            ),
            TextField(
              controller: desiredTutController,
              decoration: const InputDecoration(labelText: 'Desired Tutorial No.'),
            ),
            DropdownButton<String>(
              value: selectedMajor,
              onChanged: (String? newValue) {
                setState(() {
                  selectedMajor = newValue!;
                });
              },
              items: <String>[
                'CS',
                'BA',
                'Engineering',
                'Pharmaceutical Engineering',
                'BI',
                'Archeticture'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            DropdownButton<String>(
              value: selectedEnglish,
              onChanged: (String? newValue) {
                setState(() {
                  selectedEnglish = newValue!;
                });
              },
              items: <String>['AE', 'AS', 'SM', 'CPS', 'RPW']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            DropdownButton<String>(
              value: selectedGerman,
              onChanged: (String? newValue) {
                setState(() {
                  selectedGerman = newValue!;
                });
              },
              items: <String>['G1', 'G2', 'G3', 'G4']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
