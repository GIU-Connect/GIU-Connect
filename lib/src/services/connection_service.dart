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
      final requestSnapshotFuture = _firestore.collection('requests').doc(requestId).get();
      final masterId = (await _firestore.collection('requests').doc(requestId).get()).get('userId');
      final userSnapshotFuture = _firestore.collection('users').doc(connectionSenderId).get();
      final senderSnapshotFuture = _firestore.collection('users').doc(masterId).get();

      final List<DocumentSnapshot> snapshots =
          await Future.wait([requestSnapshotFuture, userSnapshotFuture, senderSnapshotFuture]);
      final requestSnapshot = snapshots[0];
      final userSnapshot = snapshots[1];
      final senderSnapshot = snapshots[2];
      Map<String, dynamic> requestData = requestSnapshot.data() as Map<String, dynamic>;
      String userId = requestData['userId'];

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
      if (requestData['englishLevel'].toString() != userSnapshot.get('englishLevel').toString()) {
        throw Exception('Cannot send connection request: user has a different english level.');
      }
      if (requestData['germanLevel'].toString() != userSnapshot.get('germanLevel').toString()) {
        throw Exception('Cannot send connection request: user has a different german level.');
      }

      QuerySnapshot existingRequests = await _firestore
          .collection('connectionRequests')
          .where('requestId', isEqualTo: requestId)
          .where('connectionSenderId', isEqualTo: connectionSenderId)
          .where('connectionReceiverId', isEqualTo: userId)
          .where('status', isEqualTo: 'pending')
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

      String email = userSnapshot.get('email');
      String connectionSenderName = senderSnapshot.get('name');

      Future(() async {
        try {
          await emailSender.sendEmail(
            recipientEmail: email,
            subject: 'New Connection Request',
            body:
                'Hello,\n\nYou have received a new connection request from $connectionSenderName.\n\nBest regards,\nGIU Changing Group App Team',
          );
        } catch (emailError) {
          throw Exception('Error sending email: $emailError');
        }
      });
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

      DocumentSnapshot masterSnapshot = await _firestore.collection('users').doc(masterId).get();
      DocumentSnapshot slaveSnapshot = await _firestore.collection('users').doc(slaveId).get();

      QuerySnapshot connectionRequests =
          await _firestore.collection('connectionRequests').where('requestId', isEqualTo: requestId).get();
      for (var doc in connectionRequests.docs) {
        batch.update(doc.reference, {'status': 'inactive'});
      }
      DocumentReference connectionRef = _firestore.collection('connectionRequests').doc(connectionId);
      batch.update(connectionRef, {'status': 'accepted'});

      await batch.commit();

      String masterName = masterSnapshot.get('name');
      String masterPhoneNumber = masterSnapshot.get('phoneNumber');
      String slaveName = slaveSnapshot.get('name');
      String slavePhoneNumber = slaveSnapshot.get('phoneNumber');

      Future<void> sendEmails() async {
        String slaveEmail = (await _firestore.collection('users').doc(slaveId).get()).get('email');
        await emailSender.sendEmail(
          recipientEmail: slaveEmail,
          subject: 'Connection Request Accepted',
          body:
              'Hello,\n\nYour connection request on $masterName has been accepted.\nPlease contact him on his Phone Number : $masterPhoneNumber.\n\nBest regards,\nGIU Changing Group App Team',
        );

        await emailSender.sendEmail(
          recipientEmail: masterSnapshot.get('email'),
          subject: 'Connection Request Accepted',
          body:
              'Hello,\n\nYou have successfully accepted $slaveName connection request.\nPlease contact him on his Phone Number : $slavePhoneNumber.\n\nBest regards,\nGIU Changing Group App Team',
        );
      }

      sendEmails();
    } catch (e) {
      throw Exception('Error accepting connection: $e');
    }
  }

  Future<void> rejectConnection(String requestId, String connectionId) async {
    try {
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
    } catch (e) {
      throw Exception('Error rejecting connection: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getPendingConnections(String userId) async {
    try {
      // 1. Get all pending connection requests for the user
      QuerySnapshot connectionRequests = await _firestore
          .collection('connectionRequests')
          .where('connectionSenderId', isEqualTo: userId)
          .where('status', isEqualTo: 'pending')
          .get();

      // 2. Collect all unique requestIds and connectionReceiverIds
      List<String> requestIds = connectionRequests.docs.map((doc) => doc.get('requestId') as String).toList();
      List<String> receiverIds =
          connectionRequests.docs.map((doc) => doc.get('connectionReceiverId') as String).toList();

      if (requestIds.isEmpty && receiverIds.isEmpty) {
        return [];
      }
      // 3. Batch read all requests and users in one go
      final requestSnapshotsFuture =
          _firestore.collection('requests').where(FieldPath.documentId, whereIn: requestIds).get();
      final userSnapshotsFuture =
          _firestore.collection('users').where(FieldPath.documentId, whereIn: receiverIds).get();

      final requestSnapshots = await requestSnapshotsFuture;
      final userSnapshots = await userSnapshotsFuture;

      // 4. Create maps for quick lookup
      Map<String, DocumentSnapshot> requestMap = {for (var snap in requestSnapshots.docs) snap.id: snap};
      Map<String, DocumentSnapshot> userMap = {for (var snap in userSnapshots.docs) snap.id: snap};

      // 5. Construct the result efficiently
      List<Map<String, dynamic>> pendingConnections = connectionRequests.docs.map((doc) {
        String requestId = doc.get('requestId');
        String receiverId = doc.get('connectionReceiverId');

        // log the content of the pending connections first

        return {
          'connectionId': doc.id,
          'requestId': requestId,
          'connectionReceiverId': receiverId,
          'submitterName': userMap[receiverId]!.get('name'),
          'major': userMap[receiverId]!.get('major'),
          'semester': userMap[receiverId]!.get('semester'),
          'currentTutNo': userMap[receiverId]!.get('currentTutorial'),
          'desiredTutNo': requestMap[requestId]!.get('desiredTutNo'),
          'englishLevel': requestMap[requestId]!.get('englishLevel'),
          'germanLevel': requestMap[requestId]!.get('germanLevel'),
        };
      }).toList();
      return pendingConnections;
    } catch (e) {
      throw Exception('Error getting pending connections: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getIncomingConnections(String userId) async {
    try {
      // 1. Get all pending incoming connection requests for the user
      QuerySnapshot connectionRequests = await _firestore
          .collection('connectionRequests')
          .where('connectionReceiverId', isEqualTo: userId)
          .where('status', isEqualTo: 'pending')
          .get();

      // 2. Collect all unique requestIds and connectionSenderIds
      List<String> requestIds = connectionRequests.docs.map((doc) => doc.get('requestId') as String).toList();
      List<String> senderIds = connectionRequests.docs.map((doc) => doc.get('connectionSenderId') as String).toList();

      if (requestIds.isEmpty && senderIds.isEmpty) {
        return [];
      }
      // 3. Batch read all requests and users
      final requestSnapshotsFuture =
          _firestore.collection('requests').where(FieldPath.documentId, whereIn: requestIds).get();
      final userSnapshotsFuture = _firestore.collection('users').where(FieldPath.documentId, whereIn: senderIds).get();

      final requestSnapshots = await requestSnapshotsFuture;
      final userSnapshots = await userSnapshotsFuture;

      // 4. Create maps for quick lookup
      Map<String, DocumentSnapshot> requestMap = {for (var snap in requestSnapshots.docs) snap.id: snap};
      Map<String, DocumentSnapshot> userMap = {for (var snap in userSnapshots.docs) snap.id: snap};

      // 5. Construct the result
      List<Map<String, dynamic>> incomingConnections = connectionRequests.docs.map((doc) {
        String requestId = doc.get('requestId');
        String senderId = doc.get('connectionSenderId');

        return {
          'connectionId': doc.id,
          'requestId': requestId,
          'connectionSenderId': senderId,
          'submitterName': userMap[senderId]!.get('name'),
          'major': userMap[senderId]!.get('major'),
          'semester': userMap[senderId]!.get('semester'),
          'currentTutNo': userMap[senderId]!.get('currentTutorial'),
          'desiredTutNo': requestMap[requestId]!.get('desiredTutNo'),
          'englishLevel': requestMap[requestId]!.get('englishLevel'),
          'germanLevel': requestMap[requestId]!.get('germanLevel'),
        };
      }).toList();

      return incomingConnections;
    } catch (e) {
      throw Exception('Error getting incoming connections: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAcceptedConnections(String userId) async {
    try {
      // 1. Get all accepted connection requests where the user is either the sender or receiver
      QuerySnapshot outgoingConnections = await _firestore
          .collection('connectionRequests')
          .where('connectionSenderId', isEqualTo: userId)
          .where('status', isEqualTo: 'accepted')
          .get();

      QuerySnapshot incomingConnections = await _firestore
          .collection('connectionRequests')
          .where('connectionReceiverId', isEqualTo: userId)
          .where('status', isEqualTo: 'accepted')
          .get();

      if (incomingConnections.docs.isEmpty && outgoingConnections.docs.isEmpty) {
        return [];
      }

      // 2. Collect all unique requestIds and userIds (senders and receivers)
      List<String> requestIds = [...outgoingConnections.docs, ...incomingConnections.docs]
          .map((doc) => doc.get('requestId') as String)
          .toList();
      List<String> userIds = [...outgoingConnections.docs, ...incomingConnections.docs]
          .expand((doc) => [doc.get('connectionSenderId') as String, doc.get('connectionReceiverId') as String])
          .toSet() // Use a Set to get unique userIds
          .toList();

      // 3. Batch read all requests and users
      final requestSnapshotsFuture =
          _firestore.collection('requests').where(FieldPath.documentId, whereIn: requestIds).get();
      final userSnapshotsFuture = _firestore.collection('users').where(FieldPath.documentId, whereIn: userIds).get();
      final requestSnapshots = await requestSnapshotsFuture;
      final userSnapshots = await userSnapshotsFuture;

      // 4. Create maps for quick lookup
      Map<String, DocumentSnapshot> requestMap = {for (var snap in requestSnapshots.docs) snap.id: snap};
      Map<String, DocumentSnapshot> userMap = {for (var snap in userSnapshots.docs) snap.id: snap};

      // 5. Construct the result, combining outgoing and incoming connections
      List<Map<String, dynamic>> acceptedConnections = [
        ...outgoingConnections.docs.map((doc) {
          String requestId = doc.get('requestId');
          String receiverId = doc.get('connectionReceiverId');

          return {
            'connectionId': doc.id,
            'requestId': requestId,
            'connectionReceiverId': receiverId,
            'submitterName': userMap[receiverId]!.get('name'),
            'major': userMap[receiverId]!.get('major'),
            'semester': userMap[receiverId]!.get('semester'),
            'currentTutNo': userMap[receiverId]!.get('currentTutorial'),
            'desiredTutNo': requestMap[requestId]!.get('desiredTutNo'),
            'englishLevel': requestMap[requestId]!.get('englishLevel'),
            'germanLevel': requestMap[requestId]!.get('germanLevel'),
            'phoneNumber': userMap[receiverId]!.get('phoneNumber'),
          };
        }),
        ...incomingConnections.docs.map((doc) {
          String requestId = doc.get('requestId');
          String senderId = doc.get('connectionSenderId');

          return {
            'connectionId': doc.id,
            'requestId': requestId,
            'connectionSenderId': senderId,
            'submitterName': userMap[senderId]!.get('name'),
            'major': userMap[senderId]!.get('major'),
            'semester': userMap[senderId]!.get('semester'),
            'currentTutNo': userMap[senderId]!.get('currentTutorial'),
            'desiredTutNo': requestMap[requestId]!.get('desiredTutNo'),
            'englishLevel': requestMap[requestId]!.get('englishLevel'),
            'germanLevel': requestMap[requestId]!.get('germanLevel'),
            // No phone number needed for incoming
          };
        }),
      ];

      return acceptedConnections;
    } catch (e) {
      throw Exception('Error getting accepted connections: $e');
    }
  }

  Future<void> _updateRequestsToInactiveUsingMethods(String userId, WriteBatch batch) async {
    try {
      DocumentReference userRef = _firestore.collection('users').doc(userId);
      batch.update(userRef, {'numberOfActiveRequests': 0});
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
