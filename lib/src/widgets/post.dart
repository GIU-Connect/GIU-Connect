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
  final bool isLoading;
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
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;

    return Card(
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 8.0,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorScheme.primary,
                  radius: isLargeScreen ? 40.0 : 24.0,
                  child: Text(
                    submitterName.isNotEmpty ? submitterName[0].toUpperCase() : '?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isLargeScreen ? 24.0 : 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        submitterName,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: isLargeScreen ? 24.0 : 18.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Major: $major',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: isLargeScreen ? 16.0 : 14.0,
                        ),
                      ),
                      Text(
                        'Semester: $semester',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: isLargeScreen ? 16.0 : 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            Center(child: _buildTutorialInfo(theme)),
            const SizedBox(height: 24.0),
            Center(child: _buildLanguageAndButton(context, theme)),
          ],
        ),
      ),
    );
  }

  /// Builds the tutorial number information
  Widget _buildTutorialInfo(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildTutorialBadge('Current Tutorial: $currentTutNo', Colors.green, theme),
        _buildTutorialBadge('Desired Tutorial: $desiredTutNo', Colors.orange, theme),
      ],
    );
  }

  /// Creates a badge for tutorial information
  Widget _buildTutorialBadge(String text, Color color, ThemeData theme) {
    return Container(
      width: 200.0, // Fixed width for any text
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 6.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
        textAlign: TextAlign.center, // Center the text within the fixed width
      ),
    );
  }

  /// Builds the language proficiency and action button
  Widget _buildLanguageAndButton(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'English: $englishLevel',
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: MediaQuery.of(context).size.width > 600 ? 16.0 : 14.0,
          ),
        ),
        Text(
          'German: $germanLevel',
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: MediaQuery.of(context).size.width > 600 ? 16.0 : 14.0,
          ),
        ),
        const SizedBox(height: 16.0),
        CustomButton(
          text: buttonText,
          isActive: isActive,
          isLoading: isLoading,
          onPressed: onPressed,
        ),
      ],
    );
  }
}
