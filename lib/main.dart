import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:group_changing_app/firebase_options.dart';
import 'package:group_changing_app/src/ui/sign_in_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/.env');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('Firebase initialized');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Group Changing App',
      theme: ThemeData(
        brightness: Brightness.dark,
        dialogBackgroundColor: Colors.grey[900],
        primaryColor: Colors.grey[900], // Main primary color
        hintColor: Colors.orange,

        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 96.0, fontWeight: FontWeight.bold, color: Colors.white),
          displayMedium: TextStyle(fontSize: 60.0, fontWeight: FontWeight.bold, color: Colors.white),
          displaySmall: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold, color: Colors.white),
          headlineMedium: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold, color: Colors.white),
          headlineSmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
          titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
          bodyLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.white),
          bodySmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.grey),
          labelLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            textStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.orangeAccent,
            textStyle: const TextStyle(fontSize: 14.0),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[800],
          labelStyle: TextStyle(color: Colors.grey[400]),
          errorStyle: const TextStyle(color: Colors.red),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[700]!),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.orange),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),

        // Apply the AppBarTheme globally
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900], // This ensures all AppBars use this color
          titleTextStyle: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0, // Remove shadow for a flatter look (optional)
        ),

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        ),

        scaffoldBackgroundColor: Colors.grey[900],
      ),
      home: const SignInScreen(),
    );
  }
}
