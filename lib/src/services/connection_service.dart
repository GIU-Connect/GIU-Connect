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
    // Update the connection status to 'accepted'
    await _firestore
      .collection('requests')
      .doc(requestId)
      .collection('connectionRequests')
      .doc(connectionId)
      .update({'status': 'accepted'});

      // make all other connection requests sent by this user on this request to 'inactive'
      DocumentSnapshot connectionSnapshot = await _firestore
        .collection('requests')
        .doc(requestId)
        .collection('connectionRequests')
        .doc(connectionId)
        .get();
      String connectionSenderId = (connectionSnapshot.data() as Map<String, dynamic>)['connectionSenderId'];

      // Update the status of all connections sent by this user on all other requests to 'inactive'
      QuerySnapshot allConnections = await _firestore
        .collectionGroup('connectionRequests')
        .where('connectionSenderId', isEqualTo: connectionSenderId)
        .where('status', isEqualTo: 'pending')
        .get();

      for (QueryDocumentSnapshot doc in allConnections.docs) {
        if (doc.reference.parent.parent!.id != requestId) {
        await doc.reference.update({'status': 'inactive'});
        }
      }

      // Fetch the request owner's userId
      DocumentSnapshot requestSnapshot = await _firestore.collection('requests').doc(requestId).get();
      String requestOwnerId = (requestSnapshot.data() as Map<String, dynamic>)['userId'];

      // Update the status of all requests made by this request owner to 'inactive'
      QuerySnapshot ownerRequests = await _firestore
        .collection('requests')
        .where('userId', isEqualTo: requestOwnerId)
        .where('status', isEqualTo: 'active')
        .get();

      for (QueryDocumentSnapshot doc in ownerRequests.docs) {
        await doc.reference.update({'status': 'inactive'});
      }

      QuerySnapshot connectionSenderRequests = await _firestore
        .collection('requests')
        .where('userId', isEqualTo: connectionSenderId)
        .where('status', isEqualTo: 'active')
        .get();

      for (QueryDocumentSnapshot doc in connectionSenderRequests.docs) {
        await doc.reference.update({'status': 'inactive'});
      }

    

    // send email to the connection sender
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
