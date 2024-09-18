import 'package:cloud_firestore/cloud_firestore.dart';

class EditAccountInfoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> applyChangesToMyRequests({
    required String userId,
    required String field,
    required String newValue,
  }) async {
    QuerySnapshot querySnapshot = await _firestore.collection('requests').where('userId', isEqualTo: userId).get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await doc.reference.update({field: newValue});
    }
  }

  Future<void> applyAll({
    required String userId,
    required Map<String, dynamic> newValues,
  }) async {
    QuerySnapshot querySnapshot = await _firestore.collection('requests').where('userId', isEqualTo: userId).get();

    // Batch write for efficiency
    WriteBatch batch = _firestore.batch();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      batch.update(doc.reference, newValues);
    }

    await batch.commit();
  }
}
