import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_changing_app/src/services/connection_service.dart';
import 'package:group_changing_app/src/services/request_service.dart';
import 'package:group_changing_app/src/widgets/button_widget.dart';
import 'package:group_changing_app/src/widgets/post.dart';

class SearchScreen extends StatefulWidget {
  final VoidCallback onSearchResults;
  final VoidCallback onSearchClose;

  const SearchScreen({super.key, required this.onSearchResults, required this.onSearchClose});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<DocumentSnapshot> _userData;

  String _desiredTutNo = '';
  String _currentTutNo = '';
  String _germanLevel = 'G1';
  String _englishLevel = 'AE';
  final TextEditingController _desiredTutNoController = TextEditingController();

  bool _isLoading = false;
  List<Object?> _searchResults = [];

  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    _userData = _firestore.collection('users').doc(currentUserId).get();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      color: Theme.of(context).primaryColor, // Set background color to primary color
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: isMobile ? double.infinity : 250, // Adjust width for mobile
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 32),
                      FutureBuilder<DocumentSnapshot>(
                        future: _userData,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData && snapshot.data!.exists) {
                            final data = snapshot.data!.data() as Map<String, dynamic>;
                            _currentTutNo = data['currentTutorial'] ?? '';
                            _germanLevel = data['germanLevel'] ?? 'G1';
                            _englishLevel = data['englishLevel'] ?? 'AE';

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextFormField(
                                  controller: _desiredTutNoController,
                                  decoration: InputDecoration(
                                    labelText: 'To Tutorial No.',
                                    hintText: 'Enter your desired tutorial number',
                                    prefixIcon: const Icon(Icons.swap_vert),
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    hintStyle: TextStyle(color: Colors.grey[400]),
                                    labelStyle: TextStyle(color: Colors.grey[400]),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your desired tutorial number';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      _desiredTutNo = value;
                                    });
                                  },
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const SizedBox(height: 32),
                                CustomButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        _isLoading = true;
                                      });

                                      final desiredTut = int.tryParse(_desiredTutNo);
                                      final currentTut = int.tryParse(_currentTutNo);
                                      widget.onSearchResults();
                                      final results = await RequestService().search(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        currentTut!,
                                        desiredTut!,
                                        _germanLevel,
                                        _englishLevel,
                                      );

                                      setState(() {
                                        _isLoading = false;
                                        _searchResults = results;
                                        _animationController.forward(from: 0.0);
                                      });
                                    }
                                  },
                                  text: 'Search',
                                  isActive: true,
                                  isLoading: _isLoading,
                                ),
                              ],
                            );
                          } else {
                            return const Center(child: Text('User data not found.'));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor, // Set background color to scaffold color
              height: MediaQuery.of(context).size.height,

              child: SizedBox(
                width: isMobile ? screenWidth : null, // Take full width on mobile
                child: _searchResults.isNotEmpty
                    ? FadeTransition(
                        opacity: _fadeAnimation,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final result = _searchResults[index];
                            if (result == null || (result is Map && result.isEmpty)) {
                              return const Center(child: Text('No results found'));
                            }

                            final resultMap = result as Map<String, dynamic>;

                            return Post(
                              phoneNumber: resultMap['phoneNumber'],
                              semester: resultMap['semester'],
                              submitterName: resultMap['name'],
                              major: resultMap['major'],
                              currentTutNo: resultMap['currentTutNo'],
                              desiredTutNo: resultMap['desiredTutNo'],
                              englishLevel: resultMap['englishLevel'],
                              germanLevel: resultMap['germanLevel'],
                              isActive: resultMap['status'] == 'active',
                              buttonText: 'Connect',
                              isLoading: false,
                              onPressed: () {
                                ConnectionService().sendConnectionRequest(
                                  resultMap['id'],
                                  resultMap['userId'],
                                );
                              },
                            );
                          },
                        ),
                      )
                    : Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        padding: const EdgeInsets.all(16.0),
                        height: MediaQuery.of(context).size.height,
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
