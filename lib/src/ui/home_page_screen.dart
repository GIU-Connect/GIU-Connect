import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:group_changing_app/src/ui/add_request_screen.dart';
import 'package:group_changing_app/src/ui/settings_screen.dart';
import 'package:group_changing_app/src/widgets/post.dart';
import 'package:group_changing_app/src/services/connection_service.dart';
import 'package:group_changing_app/src/services/request_service.dart';
import 'search_screen.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  HomePageScreenState createState() => HomePageScreenState();
}

class HomePageScreenState extends State<HomePageScreen> with SingleTickerProviderStateMixin {
  User? currentUser;
  late Future<List<Map<String, dynamic>>> activeRequestsFuture;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();
  final Map<String, bool> _loadingStates = {};
  bool _isSearchExpanded = false;
  bool isSettingsExpanded = false;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    activeRequestsFuture = RequestService().getActiveRequests();
  }

  Future<void> _handleConnectionRequest(String requestId) async {
    setState(() {
      _loadingStates[requestId] = true;
    });

    try {
      await ConnectionService().sendConnectionRequest(requestId, currentUser!.uid);
      _showSnackBar('Connection request sent successfully.');
    } catch (e) {
      _showSnackBar(e.toString(), isError: true);
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

  void _clearSearchContent() {
    setState(() {
      _isSearchExpanded = false;
    });

    if (endDrawerKey.currentState != null && endDrawerKey.currentState!.isEndDrawerOpen) {
      endDrawerKey.currentState!.closeEndDrawer();
      Future.delayed(const Duration(milliseconds: 300), () {
        ((endDrawerKey.currentWidget as Drawer?)?.child as SearchScreen?)?.onSearchClose();
      });
    }
  }

  void _clearSettingContent() {
    setState(() {
      isSettingsExpanded = false;
    });

    if (drawerKey.currentState != null && drawerKey.currentState!.isDrawerOpen) {
      drawerKey.currentState!.openEndDrawer();
      Future.delayed(const Duration(milliseconds: 300), () {
        ((drawerKey.currentWidget as Drawer?)?.child as SettingsScreen?)?.onSettingsClose();
      });
    }
  }

  void _toggleSettingsExpanded() {
    setState(() {
      isSettingsExpanded = !isSettingsExpanded;
    });
  }

  final GlobalKey<ScaffoldState> endDrawerKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Home Page',
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: isMobile ? 20 : 24,
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.search, color: theme.iconTheme.color),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      drawer: AnimatedContainer(
        color: theme.primaryColor,
        key: drawerKey,
        duration: const Duration(milliseconds: 250),
        width: isSettingsExpanded ? (isMobile ? screenWidth : screenWidth * 0.75) : 250,
        child: Drawer(
          child: SettingsScreen(
            onSettingsToggle: _toggleSettingsExpanded,
            onSettingsClose: _toggleSettingsExpanded,
          ),
        ),
      ),
      onDrawerChanged: (isOpened) => {
        if (!isOpened) {_clearSettingContent()}
      },
      endDrawer: AnimatedContainer(
        color: theme.primaryColor,
        key: endDrawerKey,
        duration: const Duration(milliseconds: 250),
        width: _isSearchExpanded ? screenWidth * 0.75 : (isMobile ? 200 : 250),
        child: Drawer(
          child: SingleChildScrollView(
            child: SearchScreen(
              onSearchResults: () {
                setState(() {
                  _isSearchExpanded = true;
                });
              },
              onSearchClose: _clearSearchContent,
            ),
          ),
        ),
      ),
      onEndDrawerChanged: (isOpened) {
        if (!isOpened) {
          _clearSearchContent();
        }
      },
      body: Container(
        color: theme.scaffoldBackgroundColor,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32),
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
                    padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 16),
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
