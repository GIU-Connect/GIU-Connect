import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/email_sender.dart';

class ConnectionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final EmailSender emailSender = EmailSender(
    apiUrl: 'https://email-sender-red.vercel.app/send-email',
    authToken: '123456',
  );

  Future<void> sendConnectionRequest(String requestId, String connectionSenderId) async {
    try {
      DocumentSnapshot requestSnapshot = await _firestore.collection('requests').doc(requestId).get();
      Map<String, dynamic> requestData = requestSnapshot.data() as Map<String, dynamic>;
      String userId = requestData['userId'];
      DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(connectionSenderId).get();

      if (connectionSenderId == userId) {
        throw Exception('You cannot connect to a request you made.');
      }

      if (requestData['status'].toString() == 'inactive') {
        throw Exception('Cannot send connection request: request is inactive.');
      }

      if (requestData['major'].toString() != userSnapshot.get('major').toString()) {
        throw Exception('Cannot send connection request: user has a different major.');
      }

      if (requestData['semester'].toString() != userSnapshot.get('semester').toString()) {
        throw Exception('Cannot send connection request: user has a different semester.');
      }

      if (requestData['desiredTutNo'].toString() != userSnapshot.get('currentTutorial').toString()) {
        throw Exception('Cannot send connection request: user has a different desired tutorial number.');
      }

      QuerySnapshot existingRequests = await _firestore
          .collection('connectionRequests')
          .where('requestId', isEqualTo: requestId)
          .where('connectionSenderId', isEqualTo: connectionSenderId)
          .where('connectionReceiverId', isEqualTo: userId)
          .get();

      if (existingRequests.docs.isNotEmpty) {
        throw Exception('Connection request already exists.');
      }

      await _firestore.collection('connectionRequests').add({
        'requestId': requestId,
        'connectionSenderId': connectionSenderId,
        'connectionReceiverId': userId,
        'status': 'pending',
      });

      String email = (await _firestore.collection('users').doc(userId).get()).get('email');
      String connectionSenderName = (await _firestore.collection('users').doc(connectionSenderId).get()).get('name');

      await emailSender.sendEmail(
        recipientEmail: email,
        subject: 'New Connection Request',
        body:
            'Hello,\n\nYou have received a new connection request from $connectionSenderName.\n\nBest regards,\nGIU Changing Group App Team',
      );
    } catch (e) {
      throw Exception('Error sending connection request: $e');
    }
  }

  Future<void> deleteConnection(String connectionId) async {
    try {
      DocumentSnapshot connectionSnapshot = await _firestore.collection('connectionRequests').doc(connectionId).get();

      if (!connectionSnapshot.exists) {
        throw Exception('Connection request does not exist.');
      }

      await _firestore.collection('connectionRequests').doc(connectionId).update({'status': 'inactive'});
    } catch (e) {
      throw Exception('Error deleting connection: $e');
    }
  }

  Future<void> acceptConnection(String requestId, String connectionId) async {
    try {
      final requestSnapshotFuture = _firestore.collection('requests').doc(requestId).get();
      final connectionSnapshotFuture = _firestore.collection('connectionRequests').doc(connectionId).get();

      final requestSnapshot = await requestSnapshotFuture;
      final connectionSnapshot = await connectionSnapshotFuture;

      String masterId = requestSnapshot.get('userId');
      String slaveId = connectionSnapshot.get('connectionSenderId');

      if (connectionSnapshot.get('status') != 'pending') {
        throw Exception('Only pending connection requests can be accepted.');
      }

      WriteBatch batch = _firestore.batch();

      await _updateRequestsToInactiveUsingMethods(masterId, batch);
      await _updateRequestsToInactiveUsingMethods(slaveId, batch);

      QuerySnapshot connectionRequests =
          await _firestore.collection('connectionRequests').where('requestId', isEqualTo: requestId).get();
      for (var doc in connectionRequests.docs) {
        batch.update(doc.reference, {'status': 'inactive'});
      }
      DocumentReference connectionRef = _firestore.collection('connectionRequests').doc(connectionId);
      batch.update(connectionRef, {'status': 'accepted'});

      await batch.commit();

      Future<void> sendEmails() async {
        String slaveEmail = (await _firestore.collection('users').doc(slaveId).get()).get('email');
        await emailSender.sendEmail(
          recipientEmail: slaveEmail,
          subject: 'Connection Request Accepted',
          body: 'Hello,\n\nYour connection request has been accepted.\n\nBest regards,\nGIU Changing Group App Team',
        );
      }

      sendEmails();
    } catch (e) {
      throw Exception('Error accepting connection: $e');
    }
  }

  Future<void> rejectConnection(String requestId, String connectionId) async {
    DocumentSnapshot connectionSnapshot = await _firestore.collection('connectionRequests').doc(connectionId).get();
    if (connectionSnapshot.get('status') != 'pending') {
      throw Exception('Only pending connection requests can be rejected.');
    }
    await _firestore.collection('connectionRequests').doc(connectionId).update({'status': 'rejected'});

    String slaveId = connectionSnapshot.get('connectionSenderId');

    await emailSender.sendEmail(
      recipientEmail: (await _firestore.collection('users').doc(slaveId).get()).get('email'),
      subject: 'Connection Request Rejected',
      body: 'Hello,\n\nYour connection request has been rejected.\n\nBest regards,\nGIU Changing Group App Team',
    );
  }

  Future<List<Map<String, dynamic>>> getAllConnections(String userId) async {
    try {
      // Get all connections where the user is the sender
      QuerySnapshot sentConnections = await _firestore
          .collection('connectionRequests')
          .where('connectionSenderId', isEqualTo: userId)
          .where('status', whereIn: ['accepted', 'pending']).get();

      // Get all connections where the user is the receiver
      QuerySnapshot receivedConnections = await _firestore
          .collection('connectionRequests')
          .where('connectionReceiverId', isEqualTo: userId)
          .where('status', whereIn: ['accepted', 'pending']).get();

      List<Map<String, dynamic>> connections = [];

      // Fetch user details for connections where user is the sender
      for (var doc in sentConnections.docs) {
        String receiverId = doc.get('connectionReceiverId');
        DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(receiverId).get();
        connections.add({
          'connectionId': doc.id,
          'userId': receiverId,
          'userDetails': userSnapshot.data(),
          'role': 'receiver', // Current user is the sender, so the other user is the receiver
        });
      }

      // Fetch user details for connections where user is the receiver
      for (var doc in receivedConnections.docs) {
        String senderId = doc.get('connectionSenderId');
        DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(senderId).get();
        connections.add({
          'connectionId': doc.id,
          'userId': senderId,
          'userDetails': userSnapshot.data(),
          'role': 'sender', // Current user is the receiver, so the other user is the sender
        });
      }

      return connections;
    } catch (e) {
      throw Exception('Error fetching connections: $e');
    }
  }

  Future<void> _updateRequestsToInactiveUsingMethods(String userId, WriteBatch batch) async {
    try {
      QuerySnapshot requests = await _firestore.collection('requests').where('userId', isEqualTo: userId).get();
      QuerySnapshot connectionRequests =
          await _firestore.collection('connectionRequests').where('connectionSenderId', isEqualTo: userId).get();
      for (var doc in requests.docs) {
        batch.update(doc.reference, {'status': 'inactive'});
      }
      for (var doc in connectionRequests.docs) {
        batch.update(doc.reference, {'status': 'inactive'});
      }
    } catch (e) {
      throw Exception('Error updating requests to inactive using methods: $e');
    }
  }
}
