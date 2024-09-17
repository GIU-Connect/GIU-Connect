import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:group_changing_app/src/ui/edit_account_info_screen.dart';
import 'package:group_changing_app/src/ui/my_connections_screen.dart';
import 'package:group_changing_app/src/ui/my_requests_screen.dart';
import 'package:group_changing_app/src/ui/sign_up_screen.dart';
import 'package:group_changing_app/src/widgets/button_widget.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User currentUser = FirebaseAuth.instance.currentUser!;
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black, // Set the AppBar background color to black
          title: const Text(
            'Settings',
            style: TextStyle(
              color: Colors.white, // Set the text color to white
              fontWeight: FontWeight.bold, // Set the font to bold
              fontSize: 20,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0), // Padding for better spacing
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align items to the left
            children: [
              const SizedBox(height: 20),

              // Display the user's email in a modern text style
              Text(
                'Email: ${widget.currentUser.email}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 30),

              // Sign Out Button
              AnimatedHoverButton(
                onPressed: () {
                  widget._auth.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const SignUpScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
                text: 'Sign Out',
              ),

              const SizedBox(height: 20),

              // Navigate to My Requests screen
              AnimatedHoverButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MyRequestsScreen()),
                  );
                },
                text: 'My Requests',
              ),

              const SizedBox(height: 20),

              AnimatedHoverButton(
                onPressed: () async {
                  await widget._auth.currentUser!.reload();
                  if (widget._auth.currentUser!.emailVerified) {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => EditAccountInfoScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please verify your email first.'),
                      ),
                    );
                  }
                },
                text: 'Change account info',
              ),

              const SizedBox(height: 20),

              AnimatedHoverButton(
                onPressed: () {
                  // get the current user id
                  FirebaseAuth auth = FirebaseAuth.instance;
                  String userId = auth.currentUser!.uid;
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MyConnectionScreen(userId: userId)),
                  );
                },
                text: 'My Connections',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Button with hover effect and animation
class AnimatedHoverButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;

  const AnimatedHoverButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  State<AnimatedHoverButton> createState() => _AnimatedHoverButtonState();
}

class _AnimatedHoverButtonState extends State<AnimatedHoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: _isHovered ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(0, 6),
                    blurRadius: 12,
                  )
                ]
              : [],
        ),
        child: InkWell(
          onTap: widget.onPressed,
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _isHovered ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
