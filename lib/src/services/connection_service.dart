import 'package:cloud_firestore/cloud_firestore.dart';

class ConnectionService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendConnectionRequest(
      String requestId, String connectionSenderId) async {
    _firestore
        .collection('requests')
        .doc(requestId)
        .collection('connectionRequests')
        .add({
      'connectionSenderId': connectionSenderId,
      'status': 'pending',
    });
    // send email to master
  }

  Future<void> deleteConnection(String connectionId, String requestId) async {
    _firestore
        .collection('requests')
        .doc(requestId)
        .collection('connectionRequests')
        .doc(connectionId)
        .delete();
  }

  Future<void> acceptConnection(String requestId, String connectionId) async {
    // send email to slave
    // delete all other connection requests and the request itself
  }

  Future<void> rejectConnection(String id) async {
    // send email to slave
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>>
      showAllConnectionsForRequest(String requestId) async {
    return _firestore
        .collection('requests')
        .doc(requestId)
        .collection('connectionRequests')
        .snapshots();
  }
}
