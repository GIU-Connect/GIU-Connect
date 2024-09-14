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
  void voidy() {}

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
                        submitterName: doc['name'],
                        major: doc['major'],
                        currentTutNo: doc['currentTutNo'],
                        desiredTutNo: doc['desiredTutNo'],
                        englishLevel: doc['englishLevel'],
                        germanLevel: doc['germanLevel'],
                        onOpenRequest: voidy,
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
              MaterialPageRoute(builder: (context) => AddRequestPage()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}          