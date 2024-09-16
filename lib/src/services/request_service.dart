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
        .where('status', isEqualTo: 'active')
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      throw Exception('Request already exists');
    }
    if (currentTutNo == desiredTutNo) {
      throw Exception('Current and desired tutorial numbers cannot be the same');
    }
    DocumentSnapshot userDoc = await firestore.collection('users').doc(userId).get();
    if (!userDoc.exists) {
      throw Exception('User not found');
    }
    if (userDoc['numberOfActiveRequests'] >= 3) {
      throw Exception('You cannot have more than 3 active requests');
    }
    QuerySnapshot oppositeRequestSnapshot = await firestore
        .collection('requests')
        .where('currentTutNo', isEqualTo: desiredTutNo)
        .where('desiredTutNo', isEqualTo: currentTutNo)
        .where('germanLevel', isEqualTo: germanLevel)
        .where('englishLevel', isEqualTo: englishLevel)
        .where('major', isEqualTo: major)
        .where('semester', isEqualTo: semester)
        .get();
    if (oppositeRequestSnapshot.docs.isNotEmpty) {
      throw Exception('A matching opposite request already exists');
    }

    await firestore.collection('users').doc(userId).update({
      'numberOfActiveRequests': FieldValue.increment(1),
    });
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

  Future<List<Map<String, dynamic>>> search(
      String userId, int currentTutNo, int desiredTutNo, String germanLevel, String englishLevel) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot userDoc = await firestore.collection('users').doc(userId).get();
    if (!userDoc.exists) {
      throw Exception('User not found');
    }
    String major = userDoc['major'];
    String semester = userDoc['semester'];

    QuerySnapshot querySnapshot = await firestore
        .collection('requests')
        .where('major', isEqualTo: major)
        .where('currentTutNo', isEqualTo: currentTutNo)
        .where('desiredTutNo', isEqualTo: desiredTutNo)
        .where('germanLevel', isEqualTo: germanLevel)
        .where('englishLevel', isEqualTo: englishLevel)
        .where('semester', isEqualTo: semester)
        .get();

    // Include the document ID in the result
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'id': doc.id, // Add the document ID
        ...data, // Spread the document data
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getActiveRequests() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore.collection('requests').where('status', isEqualTo: 'active').get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'id': doc.id, // Add the document ID
        ...data, // Spread the document data
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getActiveRequestsForUser(String userId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firestore
        .collection('requests')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'active')
        .get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'id': doc.id, // Add the document ID
        ...data, // Spread the document data
      };
    }).toList();
  }

  Future<void> editRequest({
    required String requestId,
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

    DocumentSnapshot requestDoc = await firestore.collection('requests').doc(requestId).get();
    if (!requestDoc.exists) {
      throw Exception('Request not found');
    }

    if (currentTutNo == desiredTutNo) {
      throw Exception('Current and desired tutorial numbers cannot be the same');
    }

    DocumentSnapshot userDoc = await firestore.collection('users').doc(userId).get();
    if (!userDoc.exists) {
      throw Exception('User not found');
    }

    await firestore.collection('requests').doc(requestId).update({
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
    });
  }

  // get all connection requests for a request
  Stream<QuerySnapshot<Map<String, dynamic>>> showAllConnectionsForRequest(String requestId) {
    return FirebaseFirestore.instance.collection('connections').where('requestId', isEqualTo: requestId).snapshots();
  }
}
