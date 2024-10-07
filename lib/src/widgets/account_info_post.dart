import 'package:flutter/material.dart';
import 'package:group_changing_app/src/widgets/dropdown_widget.dart';

class AccountInfoPost extends StatelessWidget {
  final String userId;
  final String email;
  final String phoneNumber;
  final String major;
  final String semester;
  final String englishLevel;
  final String germanLevel;
  final ValueChanged<String?> onChangeMajor;
  final ValueChanged<String?> onChangeSemester;
  final ValueChanged<String?> onChangeEnglishLevel;
  final ValueChanged<String?> onChangeGermanLevel;

  const AccountInfoPost({
    Key? key,
    required this.userId,
    required this.email,
    required this.phoneNumber,
    required this.major,
    required this.semester,
    required this.englishLevel,
    required this.germanLevel,
    required this.onChangeMajor,
    required this.onChangeSemester,
    required this.onChangeEnglishLevel,
    required this.onChangeGermanLevel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            initialValue: userId,
            decoration: const InputDecoration(
              labelText: 'User ID',
              enabled: false,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: email,
            decoration: const InputDecoration(
              labelText: 'Email',
              enabled: false,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: phoneNumber,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
            ),
          ),
          const SizedBox(height: 16),
          DropdownWidget(
            hint: 'Major',
            value: major,
            items: const [
              'Informatics and Computer Science',
              'Business Informatics',
              'Business Administration',
              'Pharmaceutical Engineer',
              'Engineering',
              'Physical Therapy',
              'Architecture',
            ],
            onChanged: onChangeMajor,
          ),
          const SizedBox(height: 16),
          DropdownWidget(
            hint: 'English Level',
            value: englishLevel,
            items: const ['AE', 'AS', 'SM', 'CPS', 'RPW', 'No English'],
            onChanged: onChangeEnglishLevel,
          ),
          const SizedBox(height: 16),
          DropdownWidget(
            hint: 'German Level',
            value: germanLevel,
            items: const ['G1', 'G2', 'G3', 'G4', 'No German'],
            onChanged: onChangeGermanLevel,
          ),
          const SizedBox(height: 16),
          DropdownWidget(
            hint: 'Semester',
            value: semester, // Pass the semester directly as a String
            items: List.generate(8, (index) => (index + 1).toString()),
            onChanged: onChangeSemester,
          ),
        ],
      ),
    );
  }
}
