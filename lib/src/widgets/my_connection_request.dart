import 'package:flutter/material.dart';
import 'package:group_changing_app/src/widgets/button_widget.dart';

class MyConnectionRequest extends StatefulWidget {
  final String requestOwner;
  final String fromTut;
  final String toTut;
  final VoidCallback onDelete;

  const MyConnectionRequest({
    Key? key,
    required this.requestOwner,
    required this.fromTut,
    required this.toTut,
    required this.onDelete,
  }) : super(key: key);

  @override
  _MyConnectionRequestState createState() => _MyConnectionRequestState();
}

class _MyConnectionRequestState extends State<MyConnectionRequest> {
  bool _isLoading = false; // Track loading state

  void _handleDelete() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    await Future.delayed(const Duration(seconds: 2)); // Simulate delete operation

    widget.onDelete(); // Call the delete callback

    setState(() {
      _isLoading = false; // End loading after the operation
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Request Owner: ${widget.requestOwner}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              'From Tut: ${widget.fromTut}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'To Tut: ${widget.toTut}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: CustomButton(
                onPressed: _isLoading ? () {} : _handleDelete, // Disable button while loading
                text: 'Delete Connection',
                isActive: !_isLoading, // Button active when not loading
                isLoading: _isLoading, // Pass the loading state
              ),
            ),
          ],
        ),
      ),
    );
  }
}
