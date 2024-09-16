// Main Home Page Screen
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:group_changing_app/src/ui/search_screen.dart';
import 'package:group_changing_app/src/ui/settings_screen.dart';
import 'package:group_changing_app/src/widgets/post.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Page',
          style: theme.textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: theme.iconTheme.color),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings, color: theme.iconTheme.color),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('requests').where('status',isEqualTo:'active').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final docs = snapshot.data!.docs;
            if (docs.isEmpty) {
              return Center(child: Text('No requests available.', style: theme.textTheme.bodyLarge));
            }

            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Post(
                    phoneNumber: doc['phoneNumber'],
                    semester: doc['semester'],
                    submitterName: doc['name'],
                    major: doc['major'],
                    currentTutNo: doc['currentTutNo'],
                    desiredTutNo: doc['desiredTutNo'],
                    englishLevel: doc['englishLevel'],
                    germanLevel: doc['germanLevel'],
                    isActive: doc['status'] == 'active',
                    buttonText: 'Connect',
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
