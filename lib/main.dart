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
        // Define the color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          primary: Colors.grey[900]!,
          secondary: Colors.blue,
        ),
        // Define the default font family
        fontFamily: 'Roboto',
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
          bodySmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.white70),
          labelLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        // Define default button styles
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blueAccent,
            textStyle: const TextStyle(fontSize: 14.0),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.transparent,
          labelStyle: TextStyle(color: Colors.grey[500]),
          errorStyle: const TextStyle(color: Colors.red),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF212121), // Dark Grey 900
          titleTextStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.black, // Set background color to black
      ),
      home: const SignInScreen(),
    );
  }
}
