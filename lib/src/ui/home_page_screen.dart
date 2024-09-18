import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  bool _isFABExpanded = false;
  final TextEditingController _tutorialNumberController = TextEditingController();
  final RequestService _requestService = RequestService();
  bool _isLoading = false;
  String _userEnglishLevel = '';
  String _userGermanLevel = '';

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    activeRequestsFuture = RequestService().getActiveRequests();

    _fetchUserLevels();
  }

  Future<void> _fetchUserLevels() async {
    if (currentUser != null) {
      try {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();
        if (userDoc.exists) {
          setState(() {
            _userEnglishLevel = userDoc['englishLevel'] ?? 'No English';
            _userGermanLevel = userDoc['germanLevel'] ?? 'No German';
          });
        }
      } catch (e) {
        // Handle error
        print('Error fetching user levels: $e');
      }
    }
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

  Future<void> _addRequest() async {
    if (currentUser == null) {
      _showSnackBar('User not logged in', isError: true);
      return;
    }

    if (_tutorialNumberController.text.isEmpty) {
      _showSnackBar('Please fill all fields', isError: true);
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      final userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();
      if (!userDoc.exists) {
        _showSnackBar('User data not found', isError: true);
        return;
      }
      final name = userDoc['name'] as String;
      final currentTutNo = userDoc['currentTutorial'] as String;
      final major = userDoc['major'] as String;
      final semester = userDoc['semester'] as String;
      final phoneNumber = userDoc['phoneNumber'] as String;

      if (currentTutNo.toString() == _tutorialNumberController.text) {
        _showSnackBar('Current and Desired Tutorial Numbers cannot be the same', isError: true);
        return;
      }

      await _requestService.addRequest(
        phoneNumber: phoneNumber,
        userId: currentUser!.uid,
        name: name,
        major: major,
        currentTutNo: int.parse(currentTutNo),
        desiredTutNo: int.parse(_tutorialNumberController.text),
        englishLevel: _userEnglishLevel,
        germanLevel: _userGermanLevel,
        semester: semester,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePageScreen()),
        );
      }
    } catch (e) {
      _showSnackBar(e.toString(), isError: true);
    } finally {
      setState(() {
        _isLoading = false;
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
        color: Colors.transparent,
        key: drawerKey,
        duration: const Duration(milliseconds: 250),
        width: isSettingsExpanded ? (isMobile ? screenWidth : screenWidth * 0.75) : 250,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(16.0),
            bottomRight: Radius.circular(16.0),
          ),
          child: Drawer(
            child: SettingsScreen(
              onSettingsToggle: _toggleSettingsExpanded,
              onSettingsClose: _toggleSettingsExpanded,
            ),
          ),
        ),
      ),
      onDrawerChanged: (isOpened) {
        if (!isOpened) {
          _clearSettingContent();
        }
      },
      endDrawer: AnimatedContainer(
        color: Colors.transparent,
        key: endDrawerKey,
        duration: const Duration(milliseconds: 250),
        width: _isSearchExpanded ? screenWidth * 0.75 : (isMobile ? 200 : 250),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0),
            bottomLeft: Radius.circular(16.0),
          ),
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
      floatingActionButton: _isLoading
          ? const CircularProgressIndicator()
          : AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: _isFABExpanded ? 350 : 150,
              height: 50,
              decoration: BoxDecoration(
                color: _isFABExpanded
                    ? theme.inputDecorationTheme.fillColor
                    : theme.floatingActionButtonTheme.backgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: _isFABExpanded
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: TextField(
                                controller: _tutorialNumberController,
                                decoration: InputDecoration(
                                  hintText: 'Enter Desired Tutorial Number',
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                ),
                                keyboardType: TextInputType.number,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.white),
                          onPressed: _addRequest,
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              _isFABExpanded = false;
                              _tutorialNumberController.clear();
                            });
                          },
                        ),
                      ],
                    )
                  : FloatingActionButton.extended(
                      onPressed: () {
                        setState(() {
                          _isFABExpanded = !_isFABExpanded;
                          if (!_isFABExpanded) {
                            _tutorialNumberController.clear();
                          }
                        });
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add Request'),
                    ),
            ),
    );
  }
}
