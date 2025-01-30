import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class EmailSender {
  final String apiUrl = 'https://api.postmarkapp.com/email';
  final String authToken; // Your Postmark Server API Token

  EmailSender({required this.authToken});

  Future<void> sendEmail({
    required String recipientEmail,
    required String subject,
    required String body,
  }) async {
    final payload = jsonEncode({
      'From': 'aly.abdelmoneim@student.giu-uni.de',  // Must be verified in Postmark
      'To': recipientEmail,
      'Subject': subject,
      'TextBody': body,
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-Postmark-Server-Token': authToken,
        },
        body: payload,
      );

      if (response.statusCode == 200) {
        Logger().i('Email sent successfully');
      } else {
        Logger().e('Failed: ${response.body}');
      }
    } catch (e) {
      Logger().e('Error sending email: $e');
    }
  }
}
