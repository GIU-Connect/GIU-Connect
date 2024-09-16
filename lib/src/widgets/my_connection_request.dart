import 'package:flutter/material.dart';
import 'package:group_changing_app/src/widgets/button_widget.dart';

class MyConnectionRequest extends StatelessWidget {
  final String requestOwner;
  final int fromTut;
  final int toTut;
  final VoidCallback onDelete;

  const MyConnectionRequest({
    Key? key,
    required this.requestOwner,
    required this.fromTut,
    required this.toTut,
    required this.onDelete,
  }) : super(key: key);

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
              'Request Owner: $requestOwner',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              'From Tut: $fromTut',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'To Tut: $toTut',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: CustomButton(
                onPressed: onDelete,
                text: 'Delete Connection',
                isActive: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
