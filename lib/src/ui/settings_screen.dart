import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:group_changing_app/src/ui/edit_account_info_screen.dart';
import 'package:group_changing_app/src/ui/my_connections_screen.dart';
import 'package:group_changing_app/src/ui/my_requests_screen.dart';
import 'package:group_changing_app/src/ui/sign_up_screen.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback onSettingsToggle;

  const SettingsScreen({super.key, required this.onSettingsToggle});

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
    String initials = displayName != null && displayName.length >= 2 ? displayName.substring(0, 2).toUpperCase() : 'Us';
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: _showContent
              ? const Text(
                  'Back',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
                )
              : const Text(
                  'Settings',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
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
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
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
                    flex: 3,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
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
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align to the top-left
        children: [
          const SizedBox(height: 20),
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
                  const SizedBox(height: 8),
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
            onTap: () {
              _navigateToScreen(const MyRequestsScreen());
            },
          ),
          _buildListTile(
            icon: Icons.people,
            title: 'My Connections',
            onTap: () {
              FirebaseAuth auth = FirebaseAuth.instance;
              String userId = auth.currentUser!.uid;
              _navigateToScreen(MyConnectionScreen(userId: userId));
            },
          ),
          _buildListTile(
            icon: Icons.edit,
            title: 'Change account info',
            onTap: () {
              _navigateToScreen(EditAccountInfoScreen());
            },
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
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  void _navigateToScreen(Widget newScreen) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    if (isMobile) {
      setState(() {
        _currentContent = newScreen;
        _showContent = true;
      });
      widget.onSettingsToggle();
    } else {
      if (_currentContent.runtimeType == newScreen.runtimeType) {
        setState(() {
          _currentContent = const SizedBox();
        });

        Future.delayed(const Duration(milliseconds: 300), () {
          setState(() {
            _currentContent = const SizedBox();
          });

          widget.onSettingsToggle();
        });
      } else if (_currentContent.runtimeType != newScreen.runtimeType &&
          _currentContent.runtimeType != const SizedBox().runtimeType) {
        setState(() {
          _currentContent = const SizedBox();
        });

        Future.delayed(const Duration(milliseconds: 300), () {
          setState(() {
            _currentContent = const SizedBox();
          });

          Future.delayed(Duration.zero, () {
            setState(() {
              _currentContent = newScreen;
            });
          });
        });
      } else {
        setState(() {
          _currentContent = newScreen;
        });
        widget.onSettingsToggle();
      }
    }
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
