import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/email_sender.dart';

class ConnectionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final EmailSender emailSender = EmailSender(
    apiUrl: 'https://email-sender-red.vercel.app/send-email',
    authToken: '123456',
  );

  Future<void> sendConnectionRequest(
      String requestId, String connectionSenderId) async {
    try {
      DocumentSnapshot requestSnapshot =
          await _firestore.collection('requests').doc(requestId).get();
      Map<String, dynamic> requestData =
          requestSnapshot.data() as Map<String, dynamic>;
      String userId = requestData['userId'];
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(connectionSenderId).get();

      if (connectionSenderId == userId) {
        throw Exception('You cannot connect to a request you made.');
      }

      if (requestData['status'].toString() == 'inactive') {
        throw Exception('Cannot send connection request: request is inactive.');
      }

      if (requestData['major'].toString() !=
          userSnapshot.get('major').toString()) {
        throw Exception(
            'Cannot send connection request: user has a different major.');
      }

      if (requestData['semester'].toString() !=
          userSnapshot.get('semester').toString()) {
        throw Exception(
            'Cannot send connection request: user has a different semester.');
      }

      if (requestData['desiredTutNo'].toString() !=
          userSnapshot.get('currentTutorial').toString()) {
        throw Exception(
            'Cannot send connection request: user has a different desired tutorial number.');
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

      String email =
          (await _firestore.collection('users').doc(userId).get()).get('email');
      String connectionSenderName =
          (await _firestore.collection('users').doc(connectionSenderId).get())
              .get('name');

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
      DocumentSnapshot connectionSnapshot = await _firestore
          .collection('connectionRequests')
          .doc(connectionId)
          .get();

      if (!connectionSnapshot.exists) {
        throw Exception('Connection request does not exist.');
      }

      await _firestore
          .collection('connectionRequests')
          .doc(connectionId)
          .update({'status': 'inactive'});
    } catch (e) {
      throw Exception('Error deleting connection: $e');
    }
  }

  Future<void> acceptConnection(String requestId, String connectionId) async {
    try {
      final requestSnapshotFuture =
          _firestore.collection('requests').doc(requestId).get();
      final connectionSnapshotFuture =
          _firestore.collection('connectionRequests').doc(connectionId).get();

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

      DocumentSnapshot masterSnapshot =
          await _firestore.collection('users').doc(masterId).get();
      DocumentSnapshot slaveSnapshot =
          await _firestore.collection('users').doc(slaveId).get();

      QuerySnapshot connectionRequests = await _firestore
          .collection('connectionRequests')
          .where('requestId', isEqualTo: requestId)
          .get();
      for (var doc in connectionRequests.docs) {
        batch.update(doc.reference, {'status': 'inactive'});
      }
      DocumentReference connectionRef =
          _firestore.collection('connectionRequests').doc(connectionId);
      batch.update(connectionRef, {'status': 'accepted'});

      await batch.commit();

      String masterName = masterSnapshot.get('name');
      String masterPhoneNumber = masterSnapshot.get('phoneNumber');

      Future<void> sendEmails() async {
        String slaveEmail =
            (await _firestore.collection('users').doc(slaveId).get())
                .get('email');
        await emailSender.sendEmail(
          recipientEmail: slaveEmail,
          subject: 'Connection Request Accepted',
          body:
              'Hello,\n\nYour connection request on $masterName has been accepted.\nPlease contact him on his Phone Number : $masterPhoneNumber.\n\nBest regards,\nGIU Changing Group App Team',
        );
      }

      String slaveName = slaveSnapshot.get('name');
      String slavePhoneNumber = slaveSnapshot.get('phoneNumber');

      await emailSender.sendEmail(
        recipientEmail: masterSnapshot.get('email'),
        subject:
            'Connection Request Accepted successfully, $slaveName, $slavePhoneNumber',
        body:
            'Hello,\n\nYou have successfully accepted $slaveName connection request.\nPlease contact him on his Phone Number : $slavePhoneNumber.\n\nBest regards,\nGIU Changing Group App Team',
      );

      sendEmails();
    } catch (e) {
      throw Exception('Error accepting connection: $e');
    }
  }

  Future<void> rejectConnection(String requestId, String connectionId) async {
    DocumentSnapshot connectionSnapshot = await _firestore
        .collection('connectionRequests')
        .doc(connectionId)
        .get();
    if (connectionSnapshot.get('status') != 'pending') {
      throw Exception('Only pending connection requests can be rejected.');
    }
    await _firestore
        .collection('connectionRequests')
        .doc(connectionId)
        .update({'status': 'rejected'});

    String slaveId = connectionSnapshot.get('connectionSenderId');

    await emailSender.sendEmail(
      recipientEmail: (await _firestore.collection('users').doc(slaveId).get())
          .get('email'),
      subject: 'Connection Request Rejected',
      body:
          'Hello,\n\nYour connection request has been rejected.\n\nBest regards,\nGIU Changing Group App Team',
    );
  }

Future<List<Map<String, dynamic>>> getAllConnections(String userId) async {
  QuerySnapshot connectionRequestsSnapshot = await _firestore
      .collection('connectionRequests')
      .where('connectionSenderId', isEqualTo: userId)
      .where('status', whereIn: ['pending', 'accepted']).get();

  List<Map<String, dynamic>> connections = [];

  // Gather all the Futures to be executed in parallel
  List<Future<void>> futures = [];

  for (var doc in connectionRequestsSnapshot.docs) {
    Map<String, dynamic> connectionData = doc.data() as Map<String, dynamic>;

    // Add the Futures for user and request data fetching
    futures.add(Future<void>(() async {
      try {
        DocumentSnapshot userSnapshot = await _firestore
            .collection('users')
            .doc(connectionData['connectionReceiverId'])
            .get();

        DocumentSnapshot requestSnapshot = await _firestore
            .collection('requests')
            .doc(connectionData['requestId'])
            .get();

        // Add user and request data to the connectionData map
        connectionData['receiverName'] = userSnapshot.get('name');
        connectionData['currentTutNo'] = requestSnapshot.get('currentTutNo');
        connectionData['desiredTutNo'] = requestSnapshot.get('desiredTutNo');

        if (connectionData['status'] == 'accepted') {
          connectionData['receiverPhoneNumber'] = userSnapshot.get('phoneNumber');
        }

        connections.add(connectionData);
      } catch (e) {
        print('Error fetching user/request data: $e');
        // Optionally, you could skip adding this connection if data is missing or log it.
      }
    }));
  }

  // Wait for all Futures to complete
  await Future.wait(futures);

  return connections;
}


  Future<void> _updateRequestsToInactiveUsingMethods(
      String userId, WriteBatch batch) async {
    try {
      DocumentReference userRef = _firestore.collection('users').doc(userId);
      batch.update(userRef, {'numberOfActiveRequests': 0});
      QuerySnapshot requests = await _firestore
          .collection('requests')
          .where('userId', isEqualTo: userId)
          .get();
      QuerySnapshot connectionRequests = await _firestore
          .collection('connectionRequests')
          .where('connectionSenderId', isEqualTo: userId)
          .get();
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
