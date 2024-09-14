import 'package:flutter/material.dart';

class Post extends StatelessWidget {
  final String submitterName;
  final String major;
  final int currentTutNo;
  final int desiredTutNo;
  final String englishLevel;
  final String germanLevel;
  final String buttonText;
  final VoidCallback buttonFunction;
  final String semester;
  final String phoneNumber;

  const Post({
    super.key,
    required this.submitterName,
    required this.major,
    required this.currentTutNo,
    required this.desiredTutNo,
    required this.englishLevel,
    required this.germanLevel,
    required this.buttonText,
    required this.buttonFunction,
    required this.semester,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
            ),
            child: Text(
              submitterName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Phone number: $phoneNumber'),
                Text('Major: $major'),
                Text('currentSemester: $semester'),
                Text('Current Tutorial No.: $currentTutNo'),
                Text('Desired Tutorial No.: $desiredTutNo'),
                Text('English Level: $englishLevel'),
                Text('German Level: $germanLevel'),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => buttonFunction(),
                  child: Text(buttonText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
