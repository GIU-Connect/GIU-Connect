import 'package:cloud_firestore/cloud_firestore.dart';

class AddRequestService {
  Future<void> addRequest({
    required String userId,
    required String name,
    required int currentTutNo,
    required int desiredTutNo,
    required String germanLevel,
    required String englishLevel,
    required String major,
    required String semester,
    required String phoneNumber,
  }) async {
    final firestore = FirebaseFirestore.instance;
    // Create a new document in the 'requests' collection
    await firestore.collection('requests').add({
      'userId': userId,
      'name': name,
      'currentTutNo': currentTutNo,
      'desiredTutNo': desiredTutNo,
      'germanLevel': germanLevel,
      'englishLevel': englishLevel,
      'major': major,
      'semester' : semester,
      'phoneNumber': phoneNumber,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
