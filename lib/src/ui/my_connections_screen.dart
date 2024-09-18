import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../services/connection_service.dart'; // Adjust the path as needed
import '../widgets/my_connection_request.dart'; // Adjust the path as needed

class MyConnectionScreen extends StatelessWidget {
  final String userId;

  const MyConnectionScreen({super.key, required this.userId});

  Future<List<Map<String, dynamic>>> _fetchConnections() async {
    ConnectionService connectionService = ConnectionService();
    return await connectionService.getAllConnections(userId);
  }

  void _handleDeleteConnection(String connectionId) async {
    ConnectionService connectionService = ConnectionService();
    try {
      await connectionService.deleteConnection(connectionId);
      // Handle successful deletion (e.g., show a snackbar or update the UI)
    } catch (e) {
      // Handle errors
      print('Error deleting connection: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Connections'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchConnections(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No connections found.'));
          } else {
            List<Map<String, dynamic>> connections = snapshot.data!;

            return ListView.builder(
              itemCount: connections.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> connection = connections[index];
                String connectionId = connection['connectionId'];
                Map<String, dynamic> userDetails = connection['userDetails'];
                Logger().i('User details: $userDetails');

                return MyConnectionRequest(
                  requestOwner: userDetails['name'] ?? 'Unknown',
                  fromTut: userDetails['fromTut'].toString(), // Convert int to String
                  toTut: userDetails['toTut'].toString(), // Convert int to String
                  onDelete: () => _handleDeleteConnection(connectionId),
                );
              },
            );
          }
        },
      ),
    );
  }
}
