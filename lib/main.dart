import 'package:flutter/material.dart';
import 'package:group_changing_app/src/ui/sign_up_screen.dart';
import './src/utils/firebase_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseUtils.initializeFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpScreen(),
      // routes: {
      //   '/sign-in': (context) => SignInScreen(),
      //   '/sign-up': (context) => SignUpScreen(),
      // },
    );
  }
}
