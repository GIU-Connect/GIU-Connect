import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_changing_app/src/ui/add_request_screen.dart';
import 'package:group_changing_app/src/widgets/my_button.dart';
import 'package:group_changing_app/src/widgets/post.dart';

class SearchResultScreen extends StatefulWidget {
  final List<Object?> results;
  const SearchResultScreen({super.key, required this.results});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  void _showRequestDialog(BuildContext context, snapshot) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Request Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${snapshot.data!.docs[0]['name']}'),
              Text('Current Tutorial No.: ${snapshot.data!.docs[0]['currentTutNo']}'),
              Text('Desired Tutorial No.: ${snapshot.data!.docs[0]['desiredTutNo']}'),
              Text('English Level: ${snapshot.data!.docs[0]['englishLevel']}'),
              Text('German Level: ${snapshot.data!.docs[0]['germanLevel']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle connect action
                Navigator.of(context).pop();
              },
              child: const Text('Connect'),
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
        title: const Text('Search Results'),
      ),
      body: widget.results.isEmpty
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'No results found',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                  ),
                ),
                Text(FirebaseAuth.instance.currentUser == null ? 'Please log in to add a request' : ''),
                MyButton(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AddRequestPage()));
                  },
                  buttonName: 'Add Request',
                ),
              ],
            ))
          : ListView(
              children: widget.results.map((result) {
                if (result == null || (result is Map && result.isEmpty)) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('No results found'),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddRequestPage()));
                        },
                        child: const Text('Add Request'),
                      ),
                    ],
                  );
                }
                final resultMap = result as Map<String, dynamic>;
                return Post(
                  semester: resultMap['semester'],
                  submitterName: resultMap['name'],
                  major: resultMap['major'],
                  phoneNumber: resultMap['phoneNumber'],
                  currentTutNo: resultMap['currentTutNo'],
                  desiredTutNo: resultMap['desiredTutNo'],
                  englishLevel: resultMap['englishLevel'],
                  germanLevel: resultMap['germanLevel'],
                  isActive: (resultMap['status'] == 'active'),
                  buttonText: 'Connect',
                  // children: [],
                );
              }).toList(),
            ),
    ));
  }
}
