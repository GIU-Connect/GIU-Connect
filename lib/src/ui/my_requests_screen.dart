import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_changing_app/src/services/delete_request_service.dart';
import 'package:group_changing_app/src/widgets/my_requests_post.dart';
import 'package:group_changing_app/src/widgets/post.dart';

class MyRequestsScreen extends StatefulWidget {
  MyRequestsScreen({super.key});

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
  DeleteRequestService _deleteRequestService = DeleteRequestService();
  String requestID = '';
}

class _MyRequestsScreenState extends State<MyRequestsScreen> {
  Future<QuerySnapshot<Map<String, dynamic>>> fetchUserRequests() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final requestCollection = FirebaseFirestore.instance.collection('requests');
    String userId = FirebaseAuth.instance.currentUser!.uid;

    final snapshot =
        await requestCollection.where('userId', isEqualTo: userId).get();
    return snapshot;
  }

  void voidy() {}

  void showDeleteConfirmationDialog(BuildContext context, String requestId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Request'),
          content: const Text('Are you sure you want to delete this request?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                deleteRequest(requestId);
                Navigator.of(context).pop();
                setState(() {
                  _userRequestsFuture = fetchUserRequests();
                });
              },
            ),
          ],
        );
      },
    );
  }

  void deleteRequest(String id) async {
    widget._deleteRequestService.deleteRequest(id);
  }

  late Future<QuerySnapshot<Map<String, dynamic>>> _userRequestsFuture;
  void showConnectionsDialog(BuildContext context, String requestId) async {
    final connectionsCollection = FirebaseFirestore.instance.collection('connections');
    final snapshot = await connectionsCollection.where('requestId', isEqualTo: requestId).get();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('My Connections'),
          content: snapshot.docs.isEmpty
              ? const Text('No connections found.')
              : SizedBox(
                  width: double.maxFinite,
                  child: ListView(
                    children: snapshot.docs.map((doc) {
                      final data = doc.data();
                      final name = data['name'];
                      final email = data['email'];
                      final phoneNumber = data['phoneNumber'];

                      return ListTile(
                        title: Text(name),
                        subtitle: Text('Email: $email\nPhone: $phoneNumber'),
                      );
                    }).toList(),
                  ),
                ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  @override
  void initState() {
    super.initState();
    _userRequestsFuture = fetchUserRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Requests'),
        ),
        body: Center(
            child: ListView(
          children: [
            FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: _userRequestsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No requests found.'));
                } else {
                  final requests = snapshot.data!.docs;
                  return Column(
                    children: requests.map((request) {
                      final name = request['name'];
                      final currentTutNo = request['currentTutNo'];
                      final desiredTutNo = request['desiredTutNo'];
                      final germanLevel = request['germanLevel'];
                      final englishLevel = request['englishLevel'];
                      final major = request['major'];
                      final semester = request['semester'];
                      final phoneNumber = request['phoneNumber'];

                      return MyRequestsPost(
                          phoneNumber: phoneNumber,
                          semester: semester,
                          submitterName: name,
                          major: major,
                          currentTutNo: currentTutNo,
                          desiredTutNo: desiredTutNo,
                          englishLevel: englishLevel,
                          germanLevel: germanLevel,
                          buttonText: 'delete request',
                          buttonFunction: () {
                            showDeleteConfirmationDialog(context, request.id);
                          });
                    }).toList(),
                  );
                }
              },
            ),
          ],
        )));
  }
}
