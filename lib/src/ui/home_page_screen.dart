import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:group_changing_app/src/ui/search_screen.dart';
import 'package:group_changing_app/src/ui/settings_screen.dart';
import 'package:group_changing_app/src/widgets/post.dart';
import 'package:group_changing_app/src/services/connection_service.dart';
import 'package:group_changing_app/src/services/request_service.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  User? currentUser;
  late Future<List<Map<String, dynamic>>> activeRequestsFuture;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final Map<String, bool> _loadingStates = {}; // Map to track loading states

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    activeRequestsFuture = RequestService().getActiveRequests();
  }

  void _handleConnectionRequest(String requestId) async {
    setState(() {
      _loadingStates[requestId] = true; // Set loading state to true
    });

    try {
      await ConnectionService().sendConnectionRequest(requestId, currentUser!.uid);
      _showSnackBar('Connection request sent successfully.');
    } catch (e) {
      _showSnackBar('Failed to send connection request.', isError: true);
    } finally {
      setState(() {
        _loadingStates[requestId] = false; // Set loading state to false
      });
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    // Use the scaffold messenger key to show the snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2), // Increase duration if needed
        behavior: SnackBarBehavior.floating, // Ensure it's floating above other elements
        backgroundColor: isError ? Colors.red : Colors.green, // Set color based on error state
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldMessengerKey,
      appBar: AppBar(
        title: Text(
          'Home Page',
          style: theme.textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: theme.iconTheme.color),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings, color: theme.iconTheme.color),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: activeRequestsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}', style: theme.textTheme.bodyLarge));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No requests available.', style: theme.textTheme.bodyLarge));
            }

            final requests = snapshot.data!;

            return ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                final requestId = request['id'];
                final isLoading = _loadingStates[requestId] ?? false;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Post(
                    phoneNumber: request['phoneNumber'],
                    semester: request['semester'],
                    submitterName: request['name'],
                    major: request['major'],
                    currentTutNo: request['currentTutNo'],
                    desiredTutNo: request['desiredTutNo'],
                    englishLevel: request['englishLevel'],
                    germanLevel: request['germanLevel'],
                    isActive: request['status'] == 'active',
                    buttonText: 'Connect',
                    isLoading: isLoading, // Pass loading state
                    onPressed: () {
                      _handleConnectionRequest(requestId);
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
