import 'package:flutter/material.dart';
import 'package:group_changing_app/src/ui/sign_up_screen.dart';
import './src/utils/firebase_utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await FirebaseUtils.initializeFirebase();

  // Configure the URL strategy for clean URLs
  // setUrlStrategy(PathUrlStrategy());

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

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
        // Dynamically manage routes if needed.
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
