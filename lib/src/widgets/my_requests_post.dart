import 'package:flutter/material.dart';
import 'package:group_changing_app/src/widgets/my_button.dart';

class MyRequestsPost extends StatelessWidget {
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

  const MyRequestsPost({
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    submitterName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    semester,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.phone, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Text(
                    phoneNumber,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.school, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Text(
                    major,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  _buildInfoChip('Current: $currentTutNo', Colors.blue),
                  const SizedBox(width: 10),
                  _buildInfoChip('Desired: $desiredTutNo', Colors.green),
                ],
              ),
              const SizedBox(height: 10),
              
              Row(
                children: [
                  _buildInfoChip('English: $englishLevel', Colors.orange),
                  const SizedBox(width: 10),
                  _buildInfoChip('German: $germanLevel', Colors.purple),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyButton(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("My Connections"),
                            content: const Text("This is my connections."),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Close"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    buttonName: "Connection Requests",
                  ),
                  
                  MyButton(
                    onTap: buttonFunction,
                    buttonName: buttonText,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, Color color) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    );
  }
}
