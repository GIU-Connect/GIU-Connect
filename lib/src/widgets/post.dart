import 'package:flutter/material.dart';

class Post extends StatelessWidget {
  final String phoneNumber;
  final String semester;
  final String submitterName;
  final String major;
  final int currentTutNo;
  final int desiredTutNo;
  final String englishLevel;
  final String germanLevel;
  final bool isActive;
  final String buttonText;

  const Post({
    super.key,
    required this.phoneNumber,
    required this.semester,
    required this.submitterName,
    required this.major,
    required this.currentTutNo,
    required this.desiredTutNo,
    required this.englishLevel,
    required this.germanLevel,
    required this.isActive,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: screenWidth > 1000 // Adjust breakpoint as needed
            ? _buildLargeScreenLayout(theme)
            : _buildSmallScreenLayout(theme),
      ),
    );
  }

  Widget _buildLargeScreenLayout(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // User details section
        CircleAvatar(
          backgroundColor: theme.colorScheme.primary,
          child: Text(
            submitterName[0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                submitterName,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis, // Add ellipsis for long names
              ),
              Text('Major: $major', style: theme.textTheme.bodyLarge),
              Text('Semester: $semester', style: theme.textTheme.bodyLarge),
            ],
          ),
        ),

        // Center section with rectangles and button
        SizedBox(
          width: 400,
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center horizontally
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
                    child: Text(
                      'Current Tutorial: $currentTutNo',
                      style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                    child: Text(
                      'Desired Tutorial: $desiredTutNo',
                      style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),

        // Right section with English and German levels
        const Spacer(), // Fill remaining space
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('English: $englishLevel', style: theme.textTheme.bodyLarge),
            Text('German: $germanLevel', style: theme.textTheme.bodyLarge),
            Center(
              child: CustomButton(
                text: buttonText,
                isActive: isActive,
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildSmallScreenLayout(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // User details section (now in a Column)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorScheme.primary,
                  child: Text(
                    submitterName[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    submitterName,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis, // Add ellipsis for long names
                  ),
                ),
              ],
            ),
            Text('Major: $major', style: theme.textTheme.bodyLarge),
            Text('Semester: $semester', style: theme.textTheme.bodyLarge),
          ],
        ),
        const SizedBox(height: 12.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the rectangles
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                'Current: $currentTutNo',
                style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(width: 8.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                'Desired: $desiredTutNo',
                style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        Text('English: $englishLevel', style: theme.textTheme.bodyLarge),
        Text('German: $germanLevel', style: theme.textTheme.bodyLarge),
        Center(
          child: CustomButton(
            text: buttonText,
            isActive: isActive,
          ),
        ),
      ],
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final bool isActive;

  const CustomButton({
    super.key,
    required this.text,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isActive ? () {} : null,
      child: Text(text),
    );
  }
}
