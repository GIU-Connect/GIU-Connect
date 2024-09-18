import 'package:flutter/material.dart';

class PendingConnectionsPost extends StatelessWidget {
  final String phoneNumber;
  final String semester;
  final String submitterName;
  final String major;
  final String currentTutNo;
  final String desiredTutNo;
  final String englishLevel;
  final String germanLevel;
  final bool isActive;
  final bool isLoading1;
  final VoidCallback onDeletePressed;

  const PendingConnectionsPost({
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
    required this.isLoading1,
    required this.onDeletePressed,
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
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(right: 16.0),
                        child: CircleAvatar(
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
                      ),
                    ),
                    Flexible(
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
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Semester: $semester',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: isLargeScreen ? 16.0 : 14.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),
                Center(child: _buildTutorialInfo(theme)),
                const SizedBox(height: 24.0),
                Center(child: _buildLanguageAndButtons(context, theme)),
              ],
            ),
          ),
          Positioned(
            top: 8.0,
            right: 8.0,
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDeletePressed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialInfo(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildTutorialBadge('Current Tutorial: $currentTutNo', Colors.green, theme),
        _buildTutorialBadge('Desired Tutorial: $desiredTutNo', Colors.orange, theme),
      ],
    );
  }

  Widget _buildTutorialBadge(String text, Color color, ThemeData theme) {
    return Container(
      width: 200.0,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 6.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildLanguageAndButtons(BuildContext context, ThemeData theme) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'English: $englishLevel',
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: isLargeScreen ? 16.0 : 14.0,
          ),
        ),
        Text(
          'German: $germanLevel',
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: isLargeScreen ? 16.0 : 14.0,
          ),
        ),
      ],
    );
  }
}
