import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteRequestService {
  Future<void> deleteRequest(String id) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('requests').doc(id).delete();
  }
}