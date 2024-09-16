import 'package:flutter/material.dart';
import 'package:group_changing_app/src/widgets/my_button.dart';

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
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Request Owner: $requestOwner',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'From Tut: $fromTut',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              'To Tut: $toTut',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: MyButton(
                onTap: onDelete,
                buttonName: 'Delete Connection on this Request',
              ),
            ),
          ],
        ),
      ),
    );
  }
}