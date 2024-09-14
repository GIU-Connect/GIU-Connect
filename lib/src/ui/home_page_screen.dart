import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_changing_app/src/widgets/post.dart';
import 'package:group_changing_app/src/ui/add_request_screen.dart';
import 'package:group_changing_app/src/ui/search_screen.dart';
import 'package:group_changing_app/src/ui/settings_screen.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
    void _showRequestDialog(BuildContext context,doc) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Request Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${doc['name']}'),
              Text('Current Tutorial No.: ${doc['currentTutNo']}'),
              Text('Desired Tutorial No.: ${doc['desiredTutNo']}'),
              Text('English Level: ${doc['englishLevel']}'),
              Text('German Level: ${doc['germanLevel']}'),
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

  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // This removes the back button
          title: const Text('Home Page'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchScreen()),
          );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingsScreen()),
          );
              },
            ),
          ],
        ),
        body: Center(
          child: ListView(
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('requests')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Column(
                    // show the list of posts from the database
                    children: snapshot.data!.docs.map((doc) {
                      return Post(
                        phoneNumber: doc['phoneNumber'],
                        semester: doc['semester'],
                        submitterName: doc['name'],
                        major: doc['major'],
                        currentTutNo: doc['currentTutNo'],
                        desiredTutNo: doc['desiredTutNo'],
                        englishLevel: doc['englishLevel'],
                        germanLevel: doc['germanLevel'],
                        buttonText: 'Open Request',
                        buttonFunction: () {
                          _showRequestDialog(context, doc);
                        },
                      );
                    }).toList(),
                  );
                },
              )
            ],
          ),
        ),

        // Add button to navigate to the AddRequestPage
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddRequestPage()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}          