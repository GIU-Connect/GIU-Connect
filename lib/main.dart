import 'package:flutter/material.dart';
import 'package:group_changing_app/src/ui/pass_reset_screen.dart';
import 'package:group_changing_app/src/ui/resend_verification_screen.dart';
import 'package:group_changing_app/src/ui/sign_in_screen.dart';
import 'package:group_changing_app/src/ui/sign_up_screen.dart';
import './src/utils/firebase_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseUtils.initializeFirebase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,

      home: SignUpScreen(),
      // routes: {
      //   '/sign-in': (context) => SignInScreen(),
      //   '/sign-up': (context) => SignUpScreen(),
      // },
    );
  }
}
