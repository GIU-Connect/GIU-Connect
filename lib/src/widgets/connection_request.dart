import 'package:flutter/material.dart';

class ConnectionRequestCard extends StatelessWidget {
  final String submitterName;
  final String status; // Add the status field
  final VoidCallback onAccept;
  final VoidCallback onReject;

  ConnectionRequestCard({
    required this.submitterName,
    required this.status, // Status is required now
    required this.onAccept,
    required this.onReject,
  });

  // A function to determine the color based on the status
  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.yellow;
      case 'rejected':
        return Colors.red;
      case 'accepted':
        return Colors.green;
      case 'inactive':
        return Colors.grey;
      default:
        return Colors.grey; // Default to grey if the status is unknown
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: [
                // Circle with dynamic color based on status
                Container(
                  width: 16.0,
                  height: 16.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getStatusColor(), // Circle color from status
                  ),
                ),
                const SizedBox(width: 10.0), // Spacing between circle and text
                Text(
                  submitterName,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: onAccept,
                  child: const Text('Accept'),
                ),
                ElevatedButton(
                  onPressed: onReject,
                  child: const Text('Reject'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
