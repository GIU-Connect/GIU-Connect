import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_changing_app/src/ui/add_request_screen.dart';
import 'package:group_changing_app/src/widgets/post.dart';

class SearchResultScreen extends StatefulWidget {
  final List<Object?> results;
  const SearchResultScreen({super.key, required this.results});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: widget.results.isEmpty
          ? Center(child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No results found'),
              Text(FirebaseAuth.instance.currentUser == null ? 'Please log in to add a request' : 'Add a request'),
              ElevatedButton(
                onPressed: () {
                  Navigator.push
                  (context, MaterialPageRoute(builder: (context) => const AddRequestPage()));
                },
                child: const Text('Add Request'),
              ),
            ],
          )
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
                        Navigator.push
                        (context, MaterialPageRoute(builder: (context) => const AddRequestPage()));
                      },
                      child: const Text('Add Request'),
                      ),
                    ],
                    );
                }
                final resultMap = result as Map<String, dynamic>;
                return Post(
                  submitterName: resultMap['name'],
                  major: resultMap['major'],
                  currentTutNo: resultMap['currentTutNo'],
                  desiredTutNo: resultMap['desiredTutNo'],
                  englishLevel: resultMap['englishLevel'],
                  germanLevel: resultMap['germanLevel'],
                  onOpenRequest: () {},
                );
              }).toList(),
            ),
    ));
  }
}
