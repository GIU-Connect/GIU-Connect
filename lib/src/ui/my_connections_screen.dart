import 'package:flutter/material.dart';
import '../services/connection_service.dart';
import '../widgets/pending_connections_post.dart';
import '../widgets/incoming_connections_post.dart';
import '../widgets/accepted_connections_post.dart';

class MyConnectionsScreen extends StatefulWidget {
  final String userId;

  const MyConnectionsScreen({super.key, required this.userId});

  @override
  State<MyConnectionsScreen> createState() => _MyConnectionsScreenState();
}

class _MyConnectionsScreenState extends State<MyConnectionsScreen> {
  final ConnectionService _connectionService = ConnectionService();
  List<Map<String, dynamic>> _pendingConnections = [];
  List<Map<String, dynamic>> _acceptedConnections = [];
  List<Map<String, dynamic>> _incomingConnections = [];

  bool _isLoadingPending = true;
  bool _isLoadingAccepted = true;
  bool _isLoadingIncoming = true;
  bool _isProcessingAction = false; // Combined loading state variable

  @override
  void initState() {
    super.initState();
    _fetchAllConnections();
  }

  Future<void> _fetchAllConnections() async {
    try {
      await Future.wait([
        _connectionService.getPendingConnections(widget.userId).then((data) {
          setState(() {
            _pendingConnections = data;
            _isLoadingPending = false;
          });
        }),
        _connectionService.getAcceptedConnections(widget.userId).then((data) {
          setState(() {
            _acceptedConnections = data;
            _isLoadingAccepted = false;
          });
        }),
        _connectionService.getIncomingConnections(widget.userId).then((data) {
          setState(() {
            _incomingConnections = data;
            _isLoadingIncoming = false;
          });
        }),
      ]);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching connections: $e'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoadingPending = false;
          _isLoadingAccepted = false;
          _isLoadingIncoming = false;
        });
      }
    }
  }

  Future<void> _handleDeleteConnection(String connectionId) async {
    bool? confirmDelete = await _showConfirmDialog(
      title: 'Confirm Delete',
      content: 'Are you sure you want to delete this connection request?',
      confirmText: 'Delete',
      confirmColor: Colors.red,
    );

    if (confirmDelete == true) {
      setState(() {
        _isProcessingAction = true; // Start loading
      });

      try {
        await _connectionService.deleteConnection(connectionId);

        setState(() {
          _pendingConnections.removeWhere((connection) => connection['connectionId'] == connectionId);
          _isProcessingAction = false; // Stop loading
          _fetchAllConnections();
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Connection deleted successfully.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isProcessingAction = false; // Stop loading
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting connection: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _handleAcceptConnection(String requestId, String connectionId) async {
    bool? confirmAccept = await _showConfirmDialog(
      title: 'Confirm Accept',
      content:
          'Are you sure you want to accept this connection request? Accepting this request will delete all other pending requests and connections.',
      confirmText: 'Accept',
      confirmColor: Colors.green,
    );

    if (confirmAccept == true) {
      setState(() {
        _isProcessingAction = true; // Start loading
      });

      try {
        await _connectionService.acceptConnection(requestId, connectionId);

        setState(() {
          _pendingConnections.removeWhere((connection) => connection['connectionId'] == connectionId);
          _fetchAllConnections();
          _isProcessingAction = false; // Stop loading
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Connection accepted successfully.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isProcessingAction = false; // Stop loading
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error accepting connection: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _handleRejectConnection(String requestId, String connectionId) async {
    bool? confirmReject = await _showConfirmDialog(
      title: 'Confirm Reject',
      content: 'Are you sure you want to reject this connection request?',
      confirmText: 'Reject',
      confirmColor: Colors.red,
    );

    if (confirmReject == true) {
      setState(() {
        _isProcessingAction = true; // Start loading
      });

      try {
        await _connectionService.rejectConnection(requestId, connectionId);

        setState(() {
          _pendingConnections.removeWhere((connection) => connection['connectionId'] == connectionId);
          _isProcessingAction = false; // Stop loading
          _fetchAllConnections();
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Connection rejected successfully.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isProcessingAction = false; // Stop loading
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error rejecting connection: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<bool?> _showConfirmDialog({
    required String title,
    required String content,
    required String confirmText,
    required Color confirmColor,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: confirmColor),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildConnectionsList({
    required List<Map<String, dynamic>> connections,
    required Widget Function(Map<String, dynamic>) itemBuilder,
    required bool isLoading,
    required String emptyMessage,
  }) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : connections.isEmpty
            ? Center(child: Text(emptyMessage))
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: connections.length,
                itemBuilder: (context, index) {
                  final connection = connections[index];
                  return itemBuilder(connection);
                },
              );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Accepted Connections'),
                _buildConnectionsList(
                  connections: _acceptedConnections,
                  itemBuilder: (connection) => AcceptedConnectionsPost(
                    phoneNumber: connection['phoneNumber'].toString(),
                    semester: connection['semester'].toString(),
                    submitterName: connection['submitterName'].toString(),
                    major: connection['major'].toString(),
                    currentTutNo: connection['currentTutNo'].toString(),
                    desiredTutNo: connection['desiredTutNo'].toString(),
                    englishLevel: connection['englishLevel'].toString(),
                    germanLevel: connection['germanLevel'].toString(),
                    isActive: false,
                    isLoading1: false,
                    onDeletePressed: () => _handleDeleteConnection(
                      connection['connectionId'],
                    ),
                  ),
                  isLoading: _isLoadingAccepted,
                  emptyMessage: 'No accepted connections.',
                ),
                _buildSectionTitle('Incoming Connections'),
                _buildConnectionsList(
                  connections: _incomingConnections,
                  itemBuilder: (connection) => IncomingConnectionsPost(
                    phoneNumber: '',
                    semester: connection['semester'].toString(),
                    submitterName: connection['submitterName'].toString(),
                    major: connection['major'].toString(),
                    currentTutNo: connection['currentTutNo'].toString(),
                    desiredTutNo: connection['desiredTutNo'].toString(),
                    englishLevel: connection['englishLevel'].toString(),
                    germanLevel: connection['germanLevel'].toString(),
                    isActive: true,
                    isLoading1: false,
                    onAcceptPressed: () => _handleAcceptConnection(
                      connection['requestId'],
                      connection['connectionId'],
                    ),
                    onRejectPressed: () => _handleRejectConnection(
                      connection['requestId'],
                      connection['connectionId'],
                    ),
                  ),
                  isLoading: _isLoadingIncoming,
                  emptyMessage: 'No incoming connections.',
                ),
                _buildSectionTitle('Pending Connections'),
                _buildConnectionsList(
                  connections: _pendingConnections,
                  itemBuilder: (connection) => PendingConnectionsPost(
                    phoneNumber: connection['phoneNumber'].toString(),
                    semester: connection['semester'].toString(),
                    submitterName: connection['submitterName'].toString(),
                    major: connection['major'].toString(),
                    currentTutNo: connection['currentTutNo'].toString(),
                    desiredTutNo: connection['desiredTutNo'].toString(),
                    englishLevel: connection['englishLevel'].toString(),
                    germanLevel: connection['germanLevel'].toString(),
                    isActive: false,
                    isLoading1: _isProcessingAction, // Show loading state
                    onDeletePressed: () => _handleDeleteConnection(
                      connection['connectionId'],
                    ),
                  ),
                  isLoading: _isLoadingPending,
                  emptyMessage: 'No pending connections.',
                ),
              ],
            ),
          ),
          if (_isProcessingAction) // Show loading overlay if processing
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
