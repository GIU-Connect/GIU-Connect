import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/error_handler.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser;

  // Sign up method
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
        return Future.error('Please use a student email');
      }

      // check if the university id is not in the database
      final QuerySnapshot result =
          await _firestore.collection('users').where('universityId', isEqualTo: universityId).get();
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.isNotEmpty) {
        return Future.error('University ID already exists');
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
        'numberOfActiveRequests': 0,
      });

      // Send email verification
      await userCredential.user!.sendEmailVerification();
    } catch (e) {
      AuthResultStatus status = AuthExceptionHandler.handleException(e);
      String errorMessage = AuthExceptionHandler.generateErrorMessage(status);
      return Future.error(errorMessage);
    }
  }

  // Sign in method
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
        return Future.error('Email not verified, please verify your email.');
      }
    } catch (e) {
      AuthResultStatus status = AuthExceptionHandler.handleException(e);
      String errorMessage = AuthExceptionHandler.generateErrorMessage(status);
      return Future.error(errorMessage);
    }
  }

  // Password reset method
  Future<bool> passwordReset({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      AuthResultStatus status = AuthExceptionHandler.handleException(e);
      String errorMessage = AuthExceptionHandler.generateErrorMessage(status);
      return Future.error(errorMessage);
    }
  }

  // Resend email verification
  Future<bool> resendVerificationEmail({required String email}) async {
    try {
      User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        return true;
      }
    } catch (e) {
      AuthResultStatus status = AuthExceptionHandler.handleException(e);
      String errorMessage = AuthExceptionHandler.generateErrorMessage(status);
      return Future.error(errorMessage);
    }
    return false;
  }

  // Sign out method
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      AuthResultStatus status = AuthExceptionHandler.handleException(e);
      String errorMessage = AuthExceptionHandler.generateErrorMessage(status);
      return Future.error(errorMessage);
    }
  }
}
