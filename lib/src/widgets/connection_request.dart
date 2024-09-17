import 'package:flutter/material.dart';

class ConnectionRequestCard extends StatefulWidget {
  final String submitterName;
  final String status;
  final Future<void> Function() onAccept;
  final Future<void> Function() onReject;

  const ConnectionRequestCard({
    super.key,
    required this.submitterName,
    required this.status,
    required this.onAccept,
    required this.onReject,
  });

  @override
  ConnectionRequestCardState createState() => ConnectionRequestCardState();
}

class ConnectionRequestCardState extends State<ConnectionRequestCard> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3, // Add slight elevation for visual depth
      margin: const EdgeInsets.symmetric(vertical: 8), // Add spacing between cards
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Submitter Name
            Text(
              'Submitter: ${widget.submitterName}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Status
            const SizedBox(height: 8),
            Text(
              'Status: ${widget.status}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 16),

            // Action Buttons (conditional rendering)
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Accept Button
                      ElevatedButton(
                        onPressed: () async {
                          setState(() => _isLoading = true);
                          try {
                            await widget.onAccept();
                          } finally {
                            if (mounted) {
                              setState(() => _isLoading = false);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Accept'),
                      ),

                      const SizedBox(width: 12), // Add spacing between buttons

                      // Reject Button
                      OutlinedButton(
                        onPressed: () async {
                          setState(() => _isLoading = true);
                          try {
                            await widget.onReject();
                          } finally {
                            if (mounted) {
                              setState(() => _isLoading = false);
                            }
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                        child: const Text('Reject'),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
