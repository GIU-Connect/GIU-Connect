import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_changing_app/src/services/connection_service.dart';
import 'package:group_changing_app/src/services/request_service.dart';
import 'package:group_changing_app/src/widgets/connection_request.dart';
import 'package:group_changing_app/src/widgets/my_requests_post.dart';
import 'package:group_changing_app/src/ui/add_request_screen.dart'; // Import the AddRequestPage
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_changing_app/src/utils/no_animation_page_route.dart';

class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen> {
  late Future<List<Map<String, dynamic>>> _userRequestsFuture;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isDeleting = false; // Add loading state for deleting request

  @override
  void initState() {
    super.initState();
    _userRequestsFuture = RequestService().getActiveRequestsForUser(_auth.currentUser!.uid);
  }

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
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteRequest(String id) async {
    setState(() {
      _isDeleting = true; // Show loading while deleting
    });
    await RequestService().deleteRequest(id);

    // Refresh the list after deletion
    setState(() {
      _userRequestsFuture = RequestService().getActiveRequestsForUser(_auth.currentUser!.uid);
      _isDeleting = false; // Stop loading after deleting
    });

    Navigator.pushReplacement(
      context,
      NoAnimationPageRoute(pageBuilder: (context, animation, secondaryAnimation) {
        return const MyRequestsScreen();
      }),
    );
  }

  void showConnectionRequestsDialog(BuildContext context, String requestId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Connection Requests'),
          content: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: RequestService().showAllConnectionsForRequest(requestId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator()); // Loading while fetching connection requests
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text('No connection requests found.');
              } else {
                return SizedBox(
                  width: double.maxFinite,
                  child: ListView(
                    children: snapshot.data!.docs.map((doc) {
                      final data = doc.data();
                      final senderId = data['connectionSenderId'];
                      final status = data['status'];

                      return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        future: FirebaseFirestore.instance
                            .collection('users') // Assuming 'users' collection contains user data
                            .doc(senderId)
                            .get(),
                        builder: (context, nameSnapshot) {
                          if (nameSnapshot.connectionState == ConnectionState.waiting) {
                            return const ListTile(
                              title: CircularProgressIndicator(), // Loading while fetching user data
                            );
                          } else if (nameSnapshot.hasError) {
                            return ListTile(
                              title: Text('Error: ${nameSnapshot.error}'),
                            );
                          } else if (!nameSnapshot.hasData || !nameSnapshot.data!.exists) {
                            return const ListTile(
                              title: Text('Unknown user'),
                            );
                          } else {
                            final name = nameSnapshot.data!.data()!['name'] ?? 'Unknown';
                            return ConnectionRequestCard(
                              submitterName: name,
                              status: status,
                              onAccept: () {
                                ConnectionService().acceptConnection(requestId, doc.id);
                                Navigator.of(context).pop();
                              },
                              onReject: () {
                                ConnectionService().rejectConnection(requestId, doc.id);
                                Navigator.of(context).pop();
                              },
                            );
                          }
                        },
                      );
                    }).toList(),
                  ),
                );
              }
            },
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Requests', style: theme.textTheme.titleLarge),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: theme.iconTheme.color),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddRequestPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: _isDeleting // Loading state while deleting a request
            ? const Center(child: CircularProgressIndicator())
            : FutureBuilder<List<Map<String, dynamic>>>(
                future: _userRequestsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator()); // Loading while fetching requests
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}', style: theme.textTheme.bodyLarge));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No requests found.', style: theme.textTheme.bodyLarge));
                  }

                  final requests = snapshot.data!;

                  return ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final request = requests[index];
                      final requestId = request['id'];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: MyRequestsPost(
                          phoneNumber: request['phoneNumber'],
                          semester: request['semester'],
                          submitterName: request['name'],
                          major: request['major'],
                          currentTutNo: request['currentTutNo'],
                          desiredTutNo: request['desiredTutNo'],
                          englishLevel: request['englishLevel'],
                          germanLevel: request['germanLevel'],
                          isActive: request['status'] == 'active',
                          buttonText: 'Delete Request',
                          deleteButtonFunction: () {
                            showDeleteConfirmationDialog(context, requestId);
                          },
                          connectionRequestButtonFunction: () {
                            showConnectionRequestsDialog(context, requestId);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddRequestPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
