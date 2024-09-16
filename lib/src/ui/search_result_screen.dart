import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_changing_app/src/ui/add_request_screen.dart';
import 'package:group_changing_app/src/widgets/button_widget.dart';
import 'package:group_changing_app/src/widgets/post.dart';
import 'package:group_changing_app/src/services/connection_service.dart';

class SearchResultScreen extends StatefulWidget {
  final List<Object?> results;
  const SearchResultScreen({super.key, required this.results});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  final Map<String, bool> _loadingStates = {}; // Track loading state for each request
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  void _handleConnectionRequest(String requestId) async {
    setState(() {
      _loadingStates[requestId] = true; // Set loading state to true
    });

    try {
      await ConnectionService().sendConnectionRequest(requestId, FirebaseAuth.instance.currentUser!.uid);
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
        duration: const Duration(seconds: 2),
        backgroundColor: isError ? Colors.red : Colors.green, // Set color based on error state
        behavior: SnackBarBehavior.floating, // Ensure it's floating above other elements
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldMessengerKey, // Set the scaffold messenger key
        appBar: AppBar(
          title: const Text('Search Results'),
        ),
        body: widget.results.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'No results found',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                      ),
                    ),
                    FirebaseAuth.instance.currentUser == null
                        ? const Text('Please log in to add a request')
                        : const SizedBox.shrink(),
                    CustomButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AddRequestPage()),
                        );
                      },
                      text: 'Add Request',
                      isActive: true,
                    ),
                  ],
                ),
              )
            : ListView(
                children: widget.results.map((result) {
                  if (result == null || (result is Map && result.isEmpty)) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('No results found'),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AddRequestPage()),
                            );
                          },
                          child: const Text('Add Request'),
                        ),
                      ],
                    );
                  }

                  final resultMap = result as Map<String, dynamic>;
                  final requestId = resultMap['id'];
                  final isLoading = _loadingStates[requestId] ?? false;

                  return Post(
                    semester: resultMap['semester'],
                    submitterName: resultMap['name'],
                    major: resultMap['major'],
                    phoneNumber: resultMap['phoneNumber'],
                    currentTutNo: resultMap['currentTutNo'],
                    desiredTutNo: resultMap['desiredTutNo'],
                    englishLevel: resultMap['englishLevel'],
                    germanLevel: resultMap['germanLevel'],
                    isActive: (resultMap['status'] == 'active'),
                    buttonText: 'Connect',
                    isLoading: isLoading, // Pass loading state
                    onPressed: () {
                      _handleConnectionRequest(requestId);
                    },
                  );
                }).toList(),
              ),
      ),
    );
  }
}
