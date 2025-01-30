import '../utils/email_sender.dart';

class ReportService {
final emailSender = EmailSender(authToken: '36187ca7-6a5c-45df-be9d-4d879881dc8e');


  Future<void> sendReport(String message, String senderName) async {
    try {
      await emailSender.sendEmail(
          recipientEmail: 'aly.abdelmoneim@student.giu-uni.de',
          subject: 'New Report !',
          body: message);

      await emailSender.sendEmail(
          recipientEmail: 'amr.khaled@student.giu-uni.de',
          subject: 'New Report !',
          body: message);

      await emailSender.sendEmail(
          recipientEmail: 'momen.elkhouli@student.giu-uni.de',
          subject: 'New Report !',
          body: message);
    } catch (emailError) {
      throw Exception('Error sending email: $emailError');
    }
  }
}
