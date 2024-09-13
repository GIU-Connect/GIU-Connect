import 'package:firebase_core/firebase_core.dart';
import 'package:group_changing_app/firebase_options.dart';

class FirebaseUtils {
  // Initialize Firebase
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
