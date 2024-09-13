import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser;

  Future<void> signUp({
    required String email,
    required String password,
    required String phoneNumber,
    required String universityId,
    required String major,
    required String currentTutorial,
    required String englishLevel,
    required String germanLevel,
  }) async {
    try {
      if (!email.trim().endsWith('@student.giu-uni.de')) {
        throw Exception('Invalid email');
      }
      // Sign up user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Write user data to Firestore
      final userId = userCredential.user!.uid;
      await _firestore.collection('users').doc(userId).set({
        'email': email,
        'phoneNumber': phoneNumber,
        'universityId': universityId,
        'major': major,
        'currentTutorial': currentTutorial,
        'englishLevel': englishLevel,
        'germanLevel': germanLevel,
      });

      await userCredential.user!.sendEmailVerification();
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = _auth.currentUser;

      print('sign in user backent: $user');

      if (user != null && !user.emailVerified) {
        throw Exception('Email not verified. Verification email sent.');
      }
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  Future<bool> passwordReset({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      throw Exception('Failed to send password reset email: $e');
    }
    return false;
  }

  Future<bool> resendVerificationEmail({required String email}) async {
    try {
      User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        return true;
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to resend verification email: $e');
    }
    return false;
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }
}
