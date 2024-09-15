import 'dart:convert';
import 'package:http/http.dart' as http;

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
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: payload,
      );

      if (response.statusCode == 200) {
        print('Email sent successfully: ${response.body}');
      } else {
        print('Failed to send email. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error sending email: $e');
    }
  }
}
