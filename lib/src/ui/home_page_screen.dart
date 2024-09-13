import 'package:flutter/material.dart';
import 'package:group_changing_app/src/widgets/post.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  void voidy() {}
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: Center(
        child: ListView(
          children: [
            Post(
                submitterName: 'Aly',
                major: 'CS',
                currentTutNo: 9,
                desiredTutNo: 15,
                englishLevel: 'CPS',
                germanLevel: '3',
                onOpenRequest: voidy),
            Post(
                submitterName: 'Aly',
                major: 'CS',
                currentTutNo: 9,
                desiredTutNo: 15,
                englishLevel: 'CPS',
                germanLevel: '3',
                onOpenRequest: voidy),
            Post(
                submitterName: 'Aly',
                major: 'CS',
                currentTutNo: 9,
                desiredTutNo: 15,
                englishLevel: 'CPS',
                germanLevel: '3',
                onOpenRequest: voidy),
            Post(
                submitterName: 'Aly',
                major: 'CS',
                currentTutNo: 9,
                desiredTutNo: 15,
                englishLevel: 'CPS',
                germanLevel: '3',
                onOpenRequest: voidy),
            Post(
                submitterName: 'Aly',
                major: 'CS',
                currentTutNo: 9,
                desiredTutNo: 15,
                englishLevel: 'CPS',
                germanLevel: '3',
                onOpenRequest: voidy),
          ],
        ),
      ),
    ));
  }
}
