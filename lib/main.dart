import 'package:flutter/material.dart';
import 'package:group_changing_app/src/ui/sign_up_screen.dart';
import './src/utils/firebase_utils.dart';
import './src/utils/email_sender.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:uni_links/uni_links.dart' as uni_links;
import 'package:flutter/services.dart' show PlatformException;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await FirebaseUtils.initializeFirebase();

  // Configure the URL strategy for clean URLs
  setUrlStrategy(PathUrlStrategy());

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
    _initDeepLinks();
  }

  // Initialize the deep link handling
  Future<void> _initDeepLinks() async {
    try {
      // Listen for incoming deep links
      uni_links.getUriLinksStream().listen((Uri? uri) {
        if (uri != null) {
          // Handle the deep link URL and navigate to the correct page
          // For example, if uri.path == "/sign-up", navigate to SignUpScreen
          if (uri.path == '/sign-up') {
            Navigator.pushNamed(context, '/sign-up');
          }
          // Add more routes or handling logic as needed
        }
      }, onError: (err) {
        // Handle any errors that occur during deep link handling
        print('Error occurred while handling deep link: $err');
      });
    } on PlatformException catch (e) {
      // Handle platform-specific errors if any
      print('Failed to handle platform deep links: ${e.message}');
    }
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
