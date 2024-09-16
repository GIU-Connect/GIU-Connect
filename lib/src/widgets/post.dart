import 'package:flutter/material.dart';
import 'package:group_changing_app/src/widgets/button_widget.dart';

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
  final bool isLoading; // New parameter for loading state
  final VoidCallback onPressed;

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
    required this.isLoading, // Add isLoading parameter
    required this.onPressed,
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
        child: screenWidth > 1000 ? _buildLargeScreenLayout(theme) : _buildSmallScreenLayout(theme),
      ),
    );
  }

  Widget _buildLargeScreenLayout(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: theme.colorScheme.primary,
          child: Text(
            submitterName.isNotEmpty ? submitterName[0].toUpperCase() : '?',
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
                overflow: TextOverflow.ellipsis,
              ),
              Text('Major: $major', style: theme.textTheme.bodyLarge),
              Text('Semester: $semester', style: theme.textTheme.bodyLarge),
            ],
          ),
        ),
        SizedBox(
          width: 400,
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('English: $englishLevel', style: theme.textTheme.bodyLarge),
            Text('German: $germanLevel', style: theme.textTheme.bodyLarge),
            Center(
              child: CustomButton(
                text: buttonText,
                isActive: isActive,
                isLoading: isLoading, // Pass loading state
                onPressed: onPressed,
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorScheme.primary,
                  child: Text(
                    submitterName.isNotEmpty ? submitterName[0].toUpperCase() : '?',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    submitterName,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
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
          mainAxisAlignment: MainAxisAlignment.center,
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
            isLoading: isLoading, // Pass loading state
            onPressed: onPressed,
          ),
        ),
      ],
    );
  }
}
