import 'package:cloud_firestore/cloud_firestore.dart';

class ConnectionService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> sendConnectionRequest(String requestId, String connectionSenderId) async {
    _firestore.collection('requests')
    .doc(requestId)
    .collection('connectionRequests')
    .add({
      'connectionSenderId': connectionSenderId,
      'status': 'pending',
    });
  }

  Future<void> deleteConnection(String connectionId, String requestId) async {
    _firestore.collection('requests')
    .doc(requestId)
    .collection('connectionRequests')
    .doc(connectionId)
    .delete();
  }

  Future<void> acceptConnection(String requestId, String connectionId) async {
    
  }

  Future<void> rejectConnection(String id) async {

  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> showAllConnectionsForRequest(String requestId) async {
    return _firestore.collection('requests')
    .doc(requestId)
    .collection('connectionRequests')
    .snapshots();
  }
}