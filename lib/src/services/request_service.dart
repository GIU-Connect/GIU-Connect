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
    //check if such a request already exists
    QuerySnapshot querySnapshot = await firestore
        .collection('requests')
        .where('userId', isEqualTo: userId)
        .where('currentTutNo', isEqualTo: currentTutNo)
        .where('desiredTutNo', isEqualTo: desiredTutNo)
        .where('germanLevel', isEqualTo: germanLevel)
        .where('englishLevel', isEqualTo: englishLevel)
        .where('major', isEqualTo: major)
        .where('semester', isEqualTo: semester)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      throw Exception('Request already exists');
    }
    // Create a new document in the 'requests' collection
    await firestore.collection('requests').add({
      'userId': userId,
      'name': name,
      'currentTutNo': currentTutNo,
      'desiredTutNo': desiredTutNo,
      'germanLevel': germanLevel,
      'englishLevel': englishLevel,
      'major': major,
      'semester': semester,
      'phoneNumber': phoneNumber,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'active',
    });
  }

  Future<void> deleteRequest(String id) async {
    final firestore = FirebaseFirestore.instance;
    await firestore.collection('requests').doc(id).update({
      'status': 'inactive',
    });
    DocumentSnapshot requestDoc = await firestore.collection('requests').doc(id).get();
    String userId = requestDoc['userId'];

    DocumentReference userRef = firestore.collection('users').doc(userId);
    await firestore.runTransaction((transaction) async {
      DocumentSnapshot userSnapshot = await transaction.get(userRef);
      if (!userSnapshot.exists) {
        throw Exception('User not found');
      }
      int numberOfActiveRequests = userSnapshot['numberOfActiveRequests'];
      transaction.update(userRef, {'numberOfActiveRequests': numberOfActiveRequests - 1});
    });
  }

  Future<List<Object?>> search(String userId,int currentTutNo, int desiredTutNo, String germanLevel,
      String englishLevel) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
    if (!userDoc.exists) {
      throw Exception('User not found');
    }
    String major = userDoc['major'];
    String semester = userDoc['semester'];

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
