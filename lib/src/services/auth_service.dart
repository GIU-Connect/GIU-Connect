import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/error_handler.dart';
import 'package:logger/logger.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser;

//sign up method
  Future<void> signUp({
    required String email,
    required String password,
    required String phoneNumber,
    required String universityId,
    required String major,
    required String currentTutorial,
    required String name,
    required String semester,
    required String confirmPassword,
  }) async {
    try {
      // Check if email is a student email
      if (!email.trim().endsWith('@student.giu-uni.de')) {
        throw Exception('Invalid email');
      }

      // Sign up user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
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
        'name': name,
        'semester': semester,
      });

      // Send email verification
      await userCredential.user!.sendEmailVerification();
    } catch (e) {
      AuthResultStatus status = AuthExceptionHandler.handleException(e);
      String errorMessage = AuthExceptionHandler.generateErrorMessage(status);
      return Future.error(errorMessage);
    }
  }

  //sign in method
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // Sign in user with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if the email is verified
      if (!userCredential.user!.emailVerified) {
        await userCredential.user!.sendEmailVerification();
        throw Exception('Email not verified. Verification email sent.');
      }

      // User is signed in and email is verified
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
  }

  Future<bool> resendVerificationEmail({required String email}) async {
    try {
      User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        return true;
      }
    } catch (e) {
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
