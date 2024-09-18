import 'package:flutter/material.dart';
import 'package:group_changing_app/src/ui/sign_in_screen.dart';
import './src/utils/firebase_utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await FirebaseUtils.initializeFirebase();

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
        // Use a dark color scheme with a primary orange accent
        brightness: Brightness.dark, // Set overall brightness to dark
        primaryColor: Colors.grey[900], // Dark background color
        hintColor: Colors.orange, // Use orange for accents
        // make

        // Define default text styles
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 96.0, fontWeight: FontWeight.bold, color: Colors.white),
          displayMedium: TextStyle(fontSize: 60.0, fontWeight: FontWeight.bold, color: Colors.white),
          displaySmall: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold, color: Colors.white),
          headlineMedium: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold, color: Colors.white),
          headlineSmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
          titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
          bodyLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.white),
          bodySmall: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.normal,
              color: Colors.grey), // Slightly lighter for less important text
          labelLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),

        // Define default button styles
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

        // Input decoration theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[800], // Slightly lighter background for input fields
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

        // AppBar theme
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
          titleTextStyle: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          iconTheme: const IconThemeData(color: Colors.white),
        ),

        // Floating action button theme
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        ),

        // Scaffold background color
        scaffoldBackgroundColor: Colors.grey[900], // Dark background
      ),
      home: const SignInScreen(),
    );
  }
}
