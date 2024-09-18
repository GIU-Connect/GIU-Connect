import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_changing_app/src/widgets/button_widget.dart';
import 'package:group_changing_app/src/widgets/account_info_post.dart';

class EditAccountInfoScreen extends StatefulWidget {
  final String userId;

  const EditAccountInfoScreen({
    super.key,
    required this.userId,
  });

  @override
  EditAccountInfoScreenState createState() => EditAccountInfoScreenState();
}

class EditAccountInfoScreenState extends State<EditAccountInfoScreen> {
  final _phoneNumberController = TextEditingController();
  final _submitterNameController = TextEditingController();
  final _currentTutNoController = TextEditingController();
  final _desiredTutNoController = TextEditingController();

  String _semester = '';
  String _major = '';
  String _englishLevel = '';
  String _germanLevel = '';

  bool _isLoading = false;
  bool _isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();

      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;
        _phoneNumberController.text = data['phoneNumber'] ?? '';
        _submitterNameController.text = data['submitterName'] ?? '';
        _currentTutNoController.text = (data['currentTutNo'] ?? 0).toString();
        _desiredTutNoController.text = (data['desiredTutNo'] ?? 0).toString();
        _semester = data['semester'] ?? '';
        _major = data['major'] ?? '';
        _englishLevel = data['englishLevel'] ?? '';
        _germanLevel = data['germanLevel'] ?? '';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching user data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
        _isDataLoaded = true;
      });
    }
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Prepare the data to update
      Map<String, dynamic> updatedData = {
        'phoneNumber': _phoneNumberController.text,
        'semester': _semester,
        'major': _major,
        'englishLevel': _englishLevel,
        'germanLevel': _germanLevel,
      };

      // Update only if the values have changed
      if (_submitterNameController.text.isNotEmpty) {
        updatedData['submitterName'] = _submitterNameController.text;
      }
      if (_currentTutNoController.text.isNotEmpty) {
        updatedData['currentTutNo'] = int.tryParse(_currentTutNoController.text) ?? 0;
      }
      if (_desiredTutNoController.text.isNotEmpty) {
        updatedData['desiredTutNo'] = int.tryParse(_desiredTutNoController.text) ?? 0;
      }

      // Update the user document in Firestore
      await FirebaseFirestore.instance.collection('users').doc(widget.userId).update(updatedData);

      // Optionally, use a service to update related requests
      // await EditAccountInfoService().applyAll(
      //   userId: widget.userId,
      //   newValues: {
      //     'major': _major,
      //     'semester': _semester,
      //     'englishLevel': _englishLevel,
      //     'germanLevel': _germanLevel,
      //   },
      // );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account information updated successfully.'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back
      Navigator.pop(context);
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating user data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Account Info'),
      ),
      body: _isDataLoaded
          ? FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(widget.userId).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(
                    child: Text('User data not found'),
                  );
                }

                var userDoc = snapshot.data!.data() as Map<String, dynamic>;

                return SingleChildScrollView(
                  // Make the content scrollable
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AccountInfoPost(
                          userId: userDoc['universityId'] ?? '',
                          email: userDoc['email'] ?? '',
                          phoneNumber: userDoc['phoneNumber'] ?? '',
                          major: _major,
                          semester: _semester,
                          englishLevel: _englishLevel,
                          germanLevel: _germanLevel,
                          onChangeMajor: (newValue) => setState(() => _major = newValue ?? ''),
                          onChangeSemester: (newValue) => setState(() => _semester = newValue ?? ''),
                          onChangeEnglishLevel: (newValue) => setState(() => _englishLevel = newValue ?? ''),
                          onChangeGermanLevel: (newValue) => setState(() => _germanLevel = newValue ?? ''),
                        ),
                        const SizedBox(height: 20.0),
                        CustomButton(
                          text: 'Save Changes',
                          isActive: true,
                          isLoading: _isLoading,
                          onPressed: _saveChanges,
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
