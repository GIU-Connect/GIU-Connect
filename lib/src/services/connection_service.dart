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
    DocumentSnapshot requestSnapshot =
        await _firestore.collection('requests').doc(requestId).get();
    String userId = (requestSnapshot.data() as Map<String, dynamic>)['userId'];

    if (connectionSenderId == userId) {
      throw Exception('You cannot connect to a request you made.');
    }

    try {
      // Check if the connection request already exists
      QuerySnapshot existingRequests = await _firestore
          .collection('requests')
          .doc(requestId)
          .collection('connectionRequests')
          .where('connectionSenderId', isEqualTo: connectionSenderId)
          .get();

      if (existingRequests.docs.isNotEmpty) {
        throw Exception('Connection request already exists.');
      }

      // Add new connection request
      await _firestore
          .collection('requests')
          .doc(requestId)
          .collection('connectionRequests')
          .add({
        'connectionSenderId': connectionSenderId,
        'status': 'pending',
      });

      // Fetch the user and sender details
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(userId).get();
      String email = (userSnapshot.data() as Map<String, dynamic>)['email'];

      DocumentSnapshot connectionSenderSnapshot =
          await _firestore.collection('users').doc(connectionSenderId).get();
      String connectionSenderName =
          (connectionSenderSnapshot.data() as Map<String, dynamic>)['name'];

      // Send email notification
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

  Future<void> deleteConnection(String connectionId, String requestId) async {
    try {
      await _firestore
          .collection('requests')
          .doc(requestId)
          .collection('connectionRequests')
          .doc(connectionId)
          .delete();
    } catch (e) {
      throw Exception('Error deleting connection: $e');
    }
  }

  Future<void> acceptConnection(String requestId, String connectionId) async {
    // Implement logic
  }

  Future<void> rejectConnection(String id) async {
    // Implement logic
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
