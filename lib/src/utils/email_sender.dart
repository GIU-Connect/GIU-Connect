import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class EmailSender {
  final String apiUrl;
  final String authToken;

  EmailSender({
    required this.apiUrl,
    required this.authToken,
  });

  Future<void> sendEmail({
    required String recipientEmail,
    required String subject,
    required String body,
  }) async {
    final payload = jsonEncode({
      'to': recipientEmail,
      'subject': subject,
      'text': body,
    });

    try {
      await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: payload,
      );
    } catch (e) {
      Logger().e('Failed to send email: $e');
    }
  }
}
