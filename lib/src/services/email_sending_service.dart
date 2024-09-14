import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EmailSendingService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<void> sendEmail(String recipientEmail, String subject, String message) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      // Assuming you have a node in your Firebase Realtime Database to store emails
      await _database.child('emails').push().set({
        'recipient': recipientEmail,
        'subject': subject,
        'message': message,
        'timestamp': DateTime.now().toIso8601String(),
        'sender': user.email,
      });

      print("Email sent successfully");
    } catch (e) {
      print("Failed to send email: $e");
    }
  }
}