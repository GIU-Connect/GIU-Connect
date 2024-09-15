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

    // Check if the request status is inactive
    if ((requestSnapshot.data() as Map<String, dynamic>)['status'] == 'inactive') {
      throw Exception('Cannot send connection request to an inactive request.');
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
  final firestore = FirebaseFirestore.instance;

  // Step 1: Check if the connection request status is pending
  DocumentSnapshot connectionSnapshot = await firestore
      .collection('requests')
      .doc(requestId)
      .collection('connectionRequests')
      .doc(connectionId)
      .get();

  final connectionData = connectionSnapshot.data() as Map<String, dynamic>;
  if (connectionData['status'] != 'pending') {
    throw Exception('Only pending connection requests can be accepted.');
  }

  // Step 2: Update the connection status to 'accepted'
  await firestore
      .collection('requests')
      .doc(requestId)
      .collection('connectionRequests')
      .doc(connectionId)
      .update({'status': 'accepted'});

  // Retrieve the connection sender ID
  String connectionSenderId = connectionData['connectionSenderId'];

  // Step 3: Make all other connection requests by this user on different requests 'inactive'
  QuerySnapshot allConnections = await firestore
      .collectionGroup('connectionRequests')
      .where('connectionSenderId', isEqualTo: connectionSenderId)
      .get();

  for (QueryDocumentSnapshot doc in allConnections.docs) {
    if (doc.reference.parent.parent!.id != requestId) {
      await doc.reference.update({'status': 'inactive'});
    }
  }

  // Step 4: Fetch the request owner's userId
  DocumentSnapshot requestSnapshot = await firestore
      .collection('requests')
      .doc(requestId)
      .get();
      
  final requestData = requestSnapshot.data() as Map<String, dynamic>;
  String requestOwnerId = requestData['userId'];

  // Step 5: Update the status of all requests made by this request owner to 'inactive'
  QuerySnapshot ownerRequests = await firestore
      .collection('requests')
      .where('userId', isEqualTo: requestOwnerId)
      .get();

  for (QueryDocumentSnapshot doc in ownerRequests.docs) {
    if ((doc.data() as Map<String, dynamic>)['status'] == 'active') {
      await doc.reference.update({'status': 'inactive'});
    }
  }

  // Step 6: Update the status of all requests made by the connection sender to 'inactive'
  QuerySnapshot connectionSenderRequests = await firestore
      .collection('requests')
      .where('userId', isEqualTo: connectionSenderId)
      .get();

  for (QueryDocumentSnapshot doc in connectionSenderRequests.docs) {
    if ((doc.data() as Map<String, dynamic>)['status'] == 'active') {
      await doc.reference.update({'status': 'inactive'});
    }
  }

  // Step 7: Update the original request's status to 'inactive'
  await firestore
      .collection('requests')
      .doc(requestId)
      .update({'status': 'inactive'});

  // Step 8: Send email to the connection sender
  // Implement email sending logic here
}


  Future<void> rejectConnection(String requestId, String connectionId) async {

    // Check if the connection request status is not pending
    DocumentSnapshot connectionSnapshot = await _firestore
      .collection('requests')
      .doc(requestId)
      .collection('connectionRequests')
      .doc(connectionId)
      .get();

    if ((connectionSnapshot.data() as Map<String, dynamic>)['status'] != 'pending') {
      throw Exception('Only pending connection requests can be rejected.');
    }

    
    // Update the connection status to 'rejected'
    await _firestore
      .collection('requests')
      .doc(requestId)
      .collection('connectionRequests')
      .doc(connectionId)
      .update({'status': 'rejected'});

    // send email to the connection sender
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
