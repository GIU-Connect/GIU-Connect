import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_changing_app/src/services/connection_service.dart';
import 'package:group_changing_app/src/services/request_service.dart';
import 'package:group_changing_app/src/widgets/connection_request.dart';
import 'package:group_changing_app/src/widgets/my_requests_post.dart';
import 'package:group_changing_app/src/ui/add_request_screen.dart';
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
  bool _isDeleting = false;

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

    if (mounted) {
      Navigator.pushReplacement(
        context,
        NoAnimationPageRoute(
          pageBuilder: (context, animation, secondaryAnimation) {
            return const MyRequestsScreen();
          },
        ),
      );
    }
  }

  void showSnackBar(BuildContext context, String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showConnectionRequestsDialog(BuildContext context, String requestId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool isProcessing = false;

            return AlertDialog(
              title: const Text('Connection Requests'),
              content: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: RequestService().showAllConnectionsForRequest(requestId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text('No connection requests found.');
                  } else {
                    return SizedBox(
                      width: double.maxFinite,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final connectionRequest = snapshot.data!.docs[index].data();
                          final connectionSenderId = connectionRequest['connectionSenderId'];

                          return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                            future: FirebaseFirestore.instance.collection('users').doc(connectionSenderId).get(),
                            builder: (context, userSnapshot) {
                              if (userSnapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (userSnapshot.hasError) {
                                return Text('Error: ${userSnapshot.error}');
                              } else if (!userSnapshot.hasData || userSnapshot.data == null) {
                                return const Text('User not found');
                              } else {
                                final userData = userSnapshot.data!.data();
                                final connectionSenderName = userData?['name'] ?? 'Unknown';

                                return ConnectionRequestCard(
                                  submitterName: connectionSenderName,
                                  status: connectionRequest['status'],
                                  onAccept: () async {
                                    setState(() => isProcessing = true);

                                    try {
                                      await ConnectionService()
                                          .acceptConnection(requestId, snapshot.data!.docs[index].id);

                                      if (context.mounted) {
                                        showSnackBar(context, 'Connection accepted', Colors.green);
                                        // Close the dialog after a short delay to allow the snackbar to be visible
                                        Future.delayed(const Duration(seconds: 1), () {
                                          if (context.mounted) {
                                            Navigator.of(context).pop();
                                          }
                                        });
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                        showSnackBar(
                                            context, 'Error accepting connection: ${e.toString()}', Colors.red);
                                      }
                                      // Stop the loading indicator in case of an error
                                      setState(() => isProcessing = false);
                                    }
                                  },
                                  onReject: () async {
                                    // ... (onReject logic remains the same) ...
                                  },
                                );
                              }
                            },
                          );
                        },
                      ),
                    );
                  }
                },
              ),
              actions: <Widget>[
                isProcessing
                    ? const Center(child: CircularProgressIndicator())
                    : TextButton(
                        child: const Text('Close'),
                        onPressed: () {
                          if (!isProcessing) {
                            Navigator.of(context).pop();
                          }
                        },
                      ),
              ],
            );
          },
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
                MaterialPageRoute(builder: (context) => const AddRequestPage()),
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
                    return const Center(child: CircularProgressIndicator()); // Loading state
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
                          buttonText1: 'Delete',
                          onPressed1: () {
                            showDeleteConfirmationDialog(context, requestId);
                          },
                          buttonText2: 'View Connections',
                          onPressed2: () {
                            showConnectionRequestsDialog(context, requestId);
                          },
                          isLoading1: false,
                          isLoading2: false,
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
            MaterialPageRoute(builder: (context) => const AddRequestPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
