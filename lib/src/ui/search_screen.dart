import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_changing_app/src/services/request_service.dart';
import 'package:group_changing_app/src/ui/search_result_screen.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();

  final RequestService requestService = RequestService();
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
}

class _SearchScreenState extends State<SearchScreen> {
  String major = '';
  String currentTutNo = '';
  String desiredTutNo = '';
  String germanLevel = 'G1';
  String englishLevel = 'AE';
  String semester = '1';

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search in Available Requests'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            
            TextField(
              decoration:
                  const InputDecoration(labelText: 'From Tutorial No.', hintText: 'The tutorial you want to switch to'),
              onChanged: (value) {
                setState(() {
                  currentTutNo = value;
                });
              },
            ),
            TextField(
              decoration:
                  const InputDecoration(labelText: 'To Tutorial No.', hintText: 'The tutorial you are currently in'),
              onChanged: (value) {
                setState(() {
                  desiredTutNo = value;
                });
              },
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'German Level'),
              value: germanLevel,
              items: ['G1', 'G2', 'G3', 'G4', 'No German']
                  .map((level) => DropdownMenuItem(
                        value: level,
                        child: Text(level),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  germanLevel = value!;
                });
              },
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'English Level'),
              value: englishLevel,
              items: ['AE', 'AS', 'SM', 'CPS', 'RPW', 'No English']
                  .map((level) => DropdownMenuItem(
                        value: level,
                        child: Text(level),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  englishLevel = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                int? currentTut = int.tryParse(currentTutNo);
                int? desiredTut = int.tryParse(desiredTutNo);

                // Handle the case where parsing fails (null means invalid input)
                if (currentTut == null || desiredTut == null) {
                  // Show a message if input is invalid
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter valid tutorial numbers.')),
                  );
                  return;
                }

                final results = await widget.requestService.search(
                  widget.currentUserId,
                  currentTut,
                  desiredTut,
                  germanLevel,
                  englishLevel,
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchResultScreen(results: results),
                  ),
                );
              },
              child: const Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}
