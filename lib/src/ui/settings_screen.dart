import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:group_changing_app/src/ui/edit_account_info_screen.dart';
import 'package:group_changing_app/src/ui/my_connections_screen.dart';
import 'package:group_changing_app/src/ui/my_requests_screen.dart';
import 'package:group_changing_app/src/ui/sign_up_screen.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback onSettingsToggle;
  final VoidCallback onSettingsClose;

  const SettingsScreen({
    Key? key,
    required this.onSettingsToggle,
    required this.onSettingsClose,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User get currentUser => _auth.currentUser!;
  Widget _currentContent = const SizedBox();
  bool _showContent = false;

  @override
  Widget build(BuildContext context) {
    String? displayName = currentUser.displayName;
    String initials =
        (displayName != null && displayName.isNotEmpty) ? displayName.substring(0, 2).toUpperCase() : 'Us';
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            _showContent ? 'Back' : 'Settings',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          leading: _showContent
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _showContent = false;
                      _currentContent = const SizedBox();
                    });
                    widget.onSettingsToggle();
                  },
                )
              : null,
        ),
        body: isMobile
            ? Stack(
                children: [
                  _buildSettingsContent(context, initials, displayName),
                  if (_showContent)
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: _currentContent,
                    ),
                ],
              )
            : Row(
                children: [
                  SizedBox(
                    width: 250,
                    child: _buildSettingsContent(context, initials, displayName),
                  ),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: _currentContent,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSettingsContent(BuildContext context, String initials, String? displayName) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).hintColor,
                child: Text(
                  initials,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName ?? 'User',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Divider(color: Colors.grey),
          const SizedBox(height: 20),
          _buildListTile(
            icon: Icons.list,
            title: 'My Requests',
            onTap: () => _navigateToScreen(const MyRequestsScreen()),
          ),
          _buildListTile(
            icon: Icons.people,
            title: 'My Connections',
            onTap: () => _navigateToScreen(
              MyConnectionScreen(userId: currentUser.uid),
            ),
          ),
          _buildListTile(
            icon: Icons.edit,
            title: 'Change account info',
            onTap: () => _navigateToScreen(EditAccountInfoScreen()),
          ),
          _buildListTile(
            icon: Icons.logout,
            title: 'Sign Out',
            iconColor: Colors.red,
            titleColor: Colors.red,
            onTap: () {
              _auth.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const SignUpScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  void _navigateToScreen(Widget newScreen) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    setState(() {
      _currentContent = newScreen;
      _showContent = isMobile;
    });

    if (!isMobile) widget.onSettingsToggle();
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    Color iconColor = Colors.white,
    Color titleColor = Colors.white,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: titleColor)),
      onTap: onTap,
    );
  }
}
