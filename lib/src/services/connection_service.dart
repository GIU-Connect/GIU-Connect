import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_changing_app/src/services/request_service.dart';
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

      if (connectionSenderId == userId) {
        throw Exception('You cannot connect to a request you made.');
      }

      if (requestData['status'] == 'inactive') {
        throw Exception('Cannot send connection request to an inactive request.');
      }

      QuerySnapshot existingRequests = await _firestore
          .collection('connectionRequests')
          .where('requestId', isEqualTo: requestId)
          .where('connectionSenderId', isEqualTo: connectionSenderId)
          .get();

      if (existingRequests.docs.isNotEmpty) {
        throw Exception('Connection request already exists.');
      }

      await _firestore.collection('connectionRequests').add({
        'requestId': requestId,
        'connectionSenderId': connectionSenderId,
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
      DocumentSnapshot requestSnapshot = await _firestore.collection('requests').doc(requestId).get();
      DocumentSnapshot connectionSnapshot = await _firestore.collection('connectionRequests').doc(connectionId).get();

      String masterId = requestSnapshot.get('userId');
      String slaveId = connectionSnapshot.get('connectionSenderId');

      if (connectionSnapshot.get('status') != 'pending') {
        throw Exception('Only pending connection requests can be accepted.');
      }

      // Update requests and connection requests statuses to inactive for both users
      await _updateRequestsToInactiveUsingMethods(masterId);
      await _updateRequestsToInactiveUsingMethods(slaveId);

      await _firestore.collection('connectionRequests').doc(connectionId).update({'status': 'accepted'});

      // TODO: Implement email sending to master
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
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> showAllConnectionsForUser(String userId) async {
    return _firestore
      .collection('connectionRequests')
      .where('connectionSenderId', isEqualTo: userId)
      .snapshots();
  }

  // Helper method to update requests and connection requests to inactive
  // Future<void> _updateRequestsToInactive(String userId) async {
  //   try {
  //     QuerySnapshot requests = await _firestore.collection('requests').where('userId', isEqualTo: userId).get();
  //     QuerySnapshot connectionRequests =
  //         await _firestore.collection('connectionRequests').where('connectionSenderId', isEqualTo: userId).get();

  //     for (var doc in requests.docs) {
  //       await doc.reference.update({'status': 'inactive'});
  //     }
  //     for (var doc in connectionRequests.docs) {
  //       await doc.reference.update({'status': 'inactive'});
  //     }
  //   } catch (e) {
  //     throw Exception('Error updating requests to inactive: $e');
  //   }
  // }

  Future<void> _updateRequestsToInactiveUsingMethods(String userId) async {
    try {
      QuerySnapshot requests = await _firestore.collection('requests').where('userId', isEqualTo: userId).get();
      QuerySnapshot connectionRequests =
          await _firestore.collection('connectionRequests').where('connectionSenderId', isEqualTo: userId).get();

      for (var doc in requests.docs) {
        RequestService requestService = RequestService();
        await requestService.deleteRequest(doc.id);
      }
      for (var doc in connectionRequests.docs) {
        await deleteConnection(doc.id);
      }
    } catch (e) {
      throw Exception('Error updating requests to inactive using methods: $e');
    }
  }

}
