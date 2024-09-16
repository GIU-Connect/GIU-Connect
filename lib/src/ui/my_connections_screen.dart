import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_changing_app/src/services/connection_service.dart';
import 'package:group_changing_app/src/widgets/my_connection_request.dart';
import 'package:group_changing_app/src/widgets/button_widget.dart';

class MyConnectionsScreen extends StatefulWidget {
  const MyConnectionsScreen({super.key});

  @override
  State<MyConnectionsScreen> createState() => _MyConnectionsScreenState();
}

class _MyConnectionsScreenState extends State<MyConnectionsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ConnectionService _connectionService = ConnectionService();
  late Future<Stream<QuerySnapshot<Map<String, dynamic>>>> _connectionsFuture;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _connectionsFuture = _connectionService.showAllConnectionsForUser(_auth.currentUser!.uid);
  }

  Future<MyConnectionRequest> _buildConnectionRequest(DocumentSnapshot<Map<String, dynamic>> snapshot) async {
    final data = snapshot.data();
    final requestId = data?['requestId'];
    final userId = data?['connectionSenderId'];

    if (requestId == null || userId == null) {
      throw Exception("Invalid data in snapshot.");
    }

    final requestSnapshot = await _firestore.collection('requests').doc(requestId).get();
    final requestData = requestSnapshot.data();
    final userSnapshot = await _firestore.collection('users').doc(userId).get();
    final userData = userSnapshot.data();

    if (requestData == null || userData == null) {
      throw Exception("Failed to fetch request or user data.");
    }

    return MyConnectionRequest(
      requestOwner: userData['name'] ?? 'Unknown',
      fromTut: requestData['currentTutNo'] ?? -1,
      toTut: requestData['desiredTutNo'] ?? -1,
      onDelete: () => _showDeleteConfirmationDialog(snapshot.id),
    );
  }

  Future<void> _showDeleteConfirmationDialog(String connectionId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Connection'),
          content: const Text('Are you sure you want to delete this connection?'),
          actions: <Widget>[
            CustomButton(
              text: 'Cancel',
              onPressed: () => Navigator.of(context).pop(),
              isActive: true,
            ),
            CustomButton(
              text: 'Delete',
              onPressed: () async {
                setState(() => _isLoading = true);
                try {
                  await _connectionService.deleteConnection(connectionId);
                  _showSnackBar('Connection deleted successfully.');
                  setState(() {
                    _connectionsFuture = _connectionService.showAllConnectionsForUser(_auth.currentUser!.uid);
                  });
                } catch (e) {
                  _showSnackBar('Failed to delete connection.', isError: true);
                } finally {
                  setState(() => _isLoading = false);
                  Navigator.of(context).pop();
                }
              },
              isActive: true,
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldMessengerKey,
      appBar: AppBar(
        title: const Text('My Connections'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<Stream<QuerySnapshot<Map<String, dynamic>>>>(
              future: _connectionsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text('No connections found.'));
                }

                return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: snapshot.data,
                  builder: (context, streamSnapshot) {
                    if (streamSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (streamSnapshot.hasError) {
                      return Center(child: Text('Error: ${streamSnapshot.error}'));
                    } else if (!streamSnapshot.hasData || streamSnapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No connections found.'));
                    }

                    return ListView.builder(
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final docSnapshot = streamSnapshot.data!.docs[index];
                        return FutureBuilder<MyConnectionRequest>(
                          future: _buildConnectionRequest(docSnapshot),
                          builder: (context, requestSnapshot) {
                            if (requestSnapshot.connectionState == ConnectionState.waiting) {
                              return const ListTile(title: Text('Loading...'));
                            } else if (requestSnapshot.hasError) {
                              return ListTile(title: Text('Error: ${requestSnapshot.error}'));
                            } else {
                              return requestSnapshot.data!;
                            }
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
