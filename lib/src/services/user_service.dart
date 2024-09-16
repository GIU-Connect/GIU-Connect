import 'package:cloud_firestore/cloud_firestore.dart';

class EditAccountInfoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> applyChangesToMyRequests({
    required String userId,
    required String field,
    required String newValue,
  }) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('requests')
        .where('userId', isEqualTo: userId)
        .get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await doc.reference.update({field: newValue});
    }
  }

  Future<void> changePhoneNumber({
    required String userId,
    required String oldPhoneNumber,
    required String newPhoneNumber,
  }) async {
    await _firestore.collection('users').doc(userId).update({
      'phoneNumber': newPhoneNumber,
    });
    await applyChangesToMyRequests(
      userId: userId,
      field: 'phoneNumber',
      newValue: newPhoneNumber,
    );
  }

  Future<void> changeUniversityId({
    required String userId,
    required String universityId,
  }) async {
    await _firestore.collection('users').doc(userId).update({
      'universityId': universityId,
    });
    await applyChangesToMyRequests(
      userId: userId,
      field: 'universityId',
      newValue: universityId,
    );
  }

  Future<void> changeCurrentTutorial({
    required String userId,
    required String currentTutorial,
  }) async {
    await _firestore.collection('users').doc(userId).update({
      'currentTutorial': currentTutorial,
    });
    await applyChangesToMyRequests(
      userId: userId,
      field: 'currentTutorial',
      newValue: currentTutorial,
    );
  }

  Future<void> changeName({
    required String userId,
    required String name,
  }) async {
    await _firestore.collection('users').doc(userId).update({
      'name': name,
    });
    await applyChangesToMyRequests(
      userId: userId,
      field: 'name',
      newValue: name,
    );
  }

  Future<void> changeSemester({
    required String userId,
    required String semester,
  }) async {
    await _firestore.collection('users').doc(userId).update({
      'semester': semester,
    });
    await applyChangesToMyRequests(
      userId: userId,
      field: 'semester',
      newValue: semester,
    );
  }

  Future<void> changeMajor({
    required String userId,
    required String major,
  }) async {
    await _firestore.collection('users').doc(userId).update({
      'major': major,
    });
    await applyChangesToMyRequests(
      userId: userId,
      field: 'major',
      newValue: major,
    );
  }
}
