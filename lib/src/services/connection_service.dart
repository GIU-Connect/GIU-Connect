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
      await _firestore
          .collection('requests')
          .doc(requestId)
          .collection('connectionRequests')
          .add({
        'connectionSenderId': connectionSenderId,
        'status': 'pending',
      });

      DocumentSnapshot requestSnapshot =
          await _firestore.collection('requests').doc(requestId).get();
      String userId =
          (requestSnapshot.data() as Map<String, dynamic>)['userId'];

      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(userId).get();
      String email = (userSnapshot.data() as Map<String, dynamic>)['email'];
      String name = (userSnapshot.data() as Map<String, dynamic>)['name'];

      await emailSender.sendEmail(
        recipientEmail: email,
        subject: 'New Connection Request',
        body:
            'Hello,\n\nYou have received a new connection request from $name.\n\nBest regards,\nGIU Changing Group App Team',
      );
    } catch (e) {
      // Handle the error appropriately, e.g., log it or rethrow it
      // For example, you can use a logging package or rethrow the error
      // Here, we'll rethrow the error for simplicity
      throw Exception('Error sending connection request: $e');
    }
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
