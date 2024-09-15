import 'package:flutter/material.dart';
import 'package:group_changing_app/src/widgets/my_button.dart';

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
  final bool isActive; // New field for status (active/inactive)

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
    required this.isActive, // Required status
  });

  // Helper to get the status color
  Color _getStatusColor() {
    return isActive ? Colors.green : Colors.red; // Green for active, Red for inactive
  }

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
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User info and status circle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Status circle
                      Container(
                        width: 16.0,
                        height: 16.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getStatusColor(), // Circle color based on active/inactive
                        ),
                      ),
                      const SizedBox(width: 10.0), // Spacing between circle and name
                      Text(
                        submitterName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
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

              // Phone and Major info with icons
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

              // Tutorial Information
              Row(
                children: [
                  _buildInfoChip('Current: $currentTutNo', Colors.blue),
                  const SizedBox(width: 10),
                  _buildInfoChip('Desired: $desiredTutNo', Colors.green),
                ],
              ),
              const SizedBox(height: 10),

              // Language Levels
              Row(
                children: [
                  _buildInfoChip('English: $englishLevel', Colors.orange),
                  const SizedBox(width: 10),
                  _buildInfoChip('German: $germanLevel', Colors.purple),
                ],
              ),
              const SizedBox(height: 20),

              // Action Button
              Align(
                alignment: Alignment.centerRight,
                child: MyButton(
                  onTap: buttonFunction,
                  buttonName: buttonText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create a modern info chip
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
