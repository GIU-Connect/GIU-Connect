import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/connection_service.dart';

class MyConnectionScreen extends StatefulWidget {
  final String userId;

  const MyConnectionScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _MyConnectionScreenState createState() => _MyConnectionScreenState();
}

class _MyConnectionScreenState extends State<MyConnectionScreen> {
  final ConnectionService _connectionService = ConnectionService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Connections'),
      ),
      body: FutureBuilder<Stream<QuerySnapshot<Map<String, dynamic>>>>(
        future: _connectionService.showAllConnectionsForUser(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Getting the stream
          Stream<QuerySnapshot<Map<String, dynamic>>>? connectionStream = snapshot.data;

          if (connectionStream == null) {
            return const Center(child: Text('No connections found.'));
          }

          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: connectionStream,
            builder: (context, connectionSnapshot) {
              if (connectionSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (connectionSnapshot.hasError) {
                return Center(child: Text('Error: ${connectionSnapshot.error}'));
              }

              if (!connectionSnapshot.hasData || connectionSnapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No connections found.'));
              }

              // Getting the list of connections
              List<DocumentSnapshot<Map<String, dynamic>>> connectionDocs = connectionSnapshot.data!.docs;

              return ListView.builder(
                itemCount: connectionDocs.length,
                itemBuilder: (context, index) {
                  var connectionData = connectionDocs[index].data();
                  String connectionStatus = connectionData?['status'] ?? 'Unknown';
                  String connectionSenderId = connectionData?['connectionSenderId'] ?? '';
                  String connectionReceiverId = connectionData?['connectionReceiverId'] ?? '';

                  // Display either sent or received connection details
                  bool isSent = connectionSenderId == widget.userId;
                  String otherUserId = isSent ? connectionReceiverId : connectionSenderId;

                  return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    future: FirebaseFirestore.instance.collection('users').doc(otherUserId).get(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState == ConnectionState.waiting) {
                        return ListTile(
                          title: Text('Loading...'),
                          subtitle: Text('Connection Status: $connectionStatus'),
                        );
                      } else if (userSnapshot.hasError || !userSnapshot.hasData || !userSnapshot.data!.exists) {
                        return ListTile(
                          title: Text('Unknown User'),
                          subtitle: Text('Connection Status: $connectionStatus'),
                        );
                      }

                      var userData = userSnapshot.data!.data();
                      String userName = userData?['name'] ?? 'Unknown Name';
                      String userEmail = userData?['email'] ?? 'Unknown Email';

                      return ListTile(
                        title: Text(userName),
                        subtitle: Text('Email: $userEmail\nConnection Status: $connectionStatus'),
                        trailing: isSent ? const Icon(Icons.arrow_forward) : const Icon(Icons.arrow_back),
                      );
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
