import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_changing_app/src/widgets/my_button.dart';
import 'package:group_changing_app/src/widgets/post.dart';
import 'package:group_changing_app/src/ui/add_request_screen.dart';
import 'package:group_changing_app/src/ui/search_screen.dart';
import 'package:group_changing_app/src/ui/settings_screen.dart';
import 'package:group_changing_app/src/services/connection_service.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  void _showRequestDialog(BuildContext context, DocumentSnapshot doc) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
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
            MyButton(
              onTap: () => Navigator.of(context).pop(),
              buttonName: 'Close',
            ),
            SizedBox(width: 10),
            MyButton(
              onTap: () {
                // Send connection request
                try {
                  ConnectionService().sendConnectionRequest(
                    doc.id,
                    FirebaseAuth.instance.currentUser!.uid,
                  );
                } catch (e) {
                  if (e == 'You cannot connect to a request you made.') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('You cannot connect to a request you made.'),
                        ),
                      );
                  } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error sending connection request.'),
                        ),
                      );
                  }
                 }

                Navigator.of(context).pop();
              },
              buttonName: 'Connect',
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

  late ImageProvider backgroundImage;

  @override
  void initState2() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    backgroundImage = const AssetImage('lib/src/assets/wallpaper.png');
  }

  @override
  Widget build(BuildContextut_swap1) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Removes the back button
          title: Row(
            children: [
              Image.asset(
                'lib/src/assets/tut_swap1.png',
                height: 40,
              ),
              const SizedBox(width: 10),
              const Text(
                'Home Page',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.black, // Dark theme for consistency
          actions: [
            IconButton(
              icon: const Icon(Icons.person, color: Colors.white),
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
          padding: const EdgeInsets.all(10.0),
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
                        children: [],
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
            );
          },
          child: const Icon(Icons.search, color: Colors.white),
        ),
      ),
    );
  }
}
