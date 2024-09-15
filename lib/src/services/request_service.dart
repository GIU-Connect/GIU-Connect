import 'package:cloud_firestore/cloud_firestore.dart';

class RequestService {
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

  Future<void> deleteRequest(String id) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('requests').doc(id).delete();
  }


  Future<List<Object?>> search(String major, int currentTutNo, int desiredTutNo,
      String germanLevel, String englishLevel, String semester) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await _firestore
        .collection('requests')
        .where('major', isEqualTo: major)
        .where('currentTutNo', isEqualTo: currentTutNo)
        .where('desiredTutNo', isEqualTo: desiredTutNo)
        .where('germanLevel', isEqualTo: germanLevel)
        .where('englishLevel', isEqualTo: englishLevel)
        .where('semester', isEqualTo: semester)
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }
}