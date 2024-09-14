import 'package:cloud_firestore/cloud_firestore.dart';

class EditAccountInfoService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> changePhoneNumber({
    required String userId,
    required String oldPhoneNumber,
    required String newPhoneNumber,
  }) async {
    _firestore.collection('users').doc(userId).update({
      'phone_number': newPhoneNumber,
    });
  }
  Future<void> changeUniversityId({
    required String userId,
    required String universityId,
  }) async
  {
    _firestore.collection('users').doc(userId).update({
      'universityId': universityId,
    });
  }

  Future<void> changeCurrentTutorial({
    required String userId,
    required String currentTutorial,
  }) async {
    _firestore.collection('users').doc(userId).update({
      'current_tutorial': currentTutorial,
    });
  } 

  Future<void> changeFirstName({
    required String userId,
    required String firstName,
  }) async {
    _firestore.collection('users').doc(userId).update({
      'first_name': firstName,
    });
  } 

  Future<void> changeLastName({
    required String userId,
    required String lastName,
  }) async {
    _firestore.collection('users').doc(userId).update({
      'last_name': lastName,
    });
  } 

  Future<void> changeSemester({
    required String userId,
    required String semester,
  }) async {
    _firestore.collection('users').doc(userId).update({
      'semester': semester,
    });
  } 

  Future<void> changeMajor({
    required String userId,
    required String major,
  }) async {
    _firestore.collection('users').doc(userId).update({
      'major': major,
    });
  } 

}