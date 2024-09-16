import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:group_changing_app/src/services/connection_service.dart';
import 'package:group_changing_app/src/widgets/my_button.dart';
import 'package:group_changing_app/src/widgets/my_connection_request.dart';

class MyConnectionsScreen extends StatefulWidget {
   MyConnectionsScreen({super.key});

  @override
  State<MyConnectionsScreen> createState() => _MyConnectionsScreenState();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  ConnectionService _connectionService = ConnectionService();
}
class _MyConnectionsScreenState extends State<MyConnectionsScreen> {
  late Future<Stream<QuerySnapshot<Map<String, dynamic>>>> _connectionsFuture;

Future<MyConnectionRequest> _buildConnectionRequest(DocumentSnapshot<Map<String, dynamic>> snapshot) async {
  final data = snapshot.data();
  
  if (data == null) {
    throw Exception("Snapshot data is null");
  }
  
  final requestId = data['requestId'];
  if (requestId == null) {
    throw Exception("Request ID is missing");
  }

  final requestSnapshot = await widget._firestore.collection('requests').doc(requestId).get();

  if (!requestSnapshot.exists || requestSnapshot.data() == null) {
    throw Exception("Request does not exist or has no data");
  }

  final requestData = requestSnapshot.data();
  final userId = data?['connectionSenderId'];

  if (userId == null) {
    throw Exception("User ID is missing");
  }

  

  final userSnapshot = await widget._firestore.collection('users').doc(userId).get();

  if (!userSnapshot.exists) {
    throw Exception("User does not exist or has no data1");
  }
  if(userSnapshot.data() == null){
    throw Exception("User does not exist or has no data2 ");
  }

  final userData = userSnapshot.data();
  final requestOwnerName = userData?['name'] ?? 'Unknown';
  final oldTut = requestData?['currentTutNo'] ?? -1;
  final newTut = requestData?['desiredTutNo'] ?? -1;

  return MyConnectionRequest(
    requestOwner: requestOwnerName,
    fromTut: oldTut,
    toTut: newTut,
    onDelete: () => _showDeleteConfirmationDialog(snapshot.id),
  );
}

Future<void> _showDeleteConfirmationDialog(String connectionId) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Connection'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure you want to delete this connection?'),
            ],
          ),
        ),
        actions: <Widget>[
          MyButton(
            buttonName: 'Cancel',
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          MyButton(
            buttonName: 'Delete',
            onTap: () async {
              await widget._connectionService.deleteConnection(connectionId);
              Navigator.of(context).pop();
              setState(() {
                _connectionsFuture = widget._connectionService.showAllConnectionsForUser(widget._auth.currentUser!.uid);
              });
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
    _connectionsFuture = widget._connectionService.showAllConnectionsForUser(widget._auth.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Connections'),
      ),
      body: FutureBuilder<Stream<QuerySnapshot<Map<String, dynamic>>>>(
        future: _connectionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No connections found.'));
          } else {
            return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: snapshot.data,
              builder: (context, streamSnapshot) {
                if (streamSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (streamSnapshot.hasError) {
                  return Center(child: Text('Error: ${streamSnapshot.error}'));
                } else if (!streamSnapshot.hasData || streamSnapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No connections found.'));
                } else {
                  
                  return ListView.builder(
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final docSnapshot = streamSnapshot.data!.docs[index];
                      
                      return FutureBuilder<MyConnectionRequest>(
                        future: _buildConnectionRequest(docSnapshot),
                        builder: (context, requestSnapshot) {
                          if (requestSnapshot.connectionState == ConnectionState.waiting) {
                            return ListTile(
                              title: Text('Loading...'),
                            );
                          } else if (requestSnapshot.hasError) {
                            return ListTile(
                              title: Text('Error: ${requestSnapshot.error}'),
                            );
                          } else {
                            return requestSnapshot.data!;
                          }
                        },
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }

 
}








