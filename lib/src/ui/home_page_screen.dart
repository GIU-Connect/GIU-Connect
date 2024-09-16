import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:group_changing_app/src/ui/add_request_screen.dart'; // Import the AddRequestPage
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
  final Map<String, bool> _loadingStates = {};

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    activeRequestsFuture = RequestService().getActiveRequests();
  }

  void _handleConnectionRequest(String requestId) async {
    setState(() {
      _loadingStates[requestId] = true;
    });

    try {
      await ConnectionService().sendConnectionRequest(requestId, currentUser!.uid);
      _showSnackBar('Connection request sent successfully.');
    } catch (e) {
      _showSnackBar('Failed to send connection request.', isError: true);
    } finally {
      setState(() {
        _loadingStates[requestId] = false;
      });
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldMessengerKey,
      appBar: AppBar(
        title: Text('Home Page', style: theme.textTheme.titleLarge),
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
                    isLoading: isLoading,
                    onPressed: () => _handleConnectionRequest(requestId),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRequestPage()),
          );
        },
        backgroundColor: Colors.blue,
        tooltip: 'Add Request',
        child: const Icon(Icons.add),
      ),
    );
  }
}
