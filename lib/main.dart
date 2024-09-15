import 'package:flutter/material.dart';
import 'package:group_changing_app/src/ui/sign_up_screen.dart';
import './src/utils/firebase_utils.dart';
import './src/utils/email_sender.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseUtils.initializeFirebase();
  // setPathUrlStrategy();clean URLs
  // setPathUrlStrategy();
  // or
  //
  // setHashUrlStrategy();
  setUrlStrategy(PathUrlStrategy());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SignUpScreen(), // Default route (home page)
        '/sign-up': (context) => SignUpScreen(),
        // You can add other routes like SignInScreen, etc.
      },
      onGenerateRoute: (settings) {
        // This can be used to dynamically manage routes if needed.
        return MaterialPageRoute(
            builder: (context) {
            switch (settings.name) {
              case '/sign-up':
              return SignUpScreen();
              // Add other cases for different routes if needed
              default:
              return SignUpScreen(); // Default page
            }
            
          },
        );
      },
    );
  }
}
