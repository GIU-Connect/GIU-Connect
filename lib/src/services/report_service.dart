import '../utils/email_sender.dart';

class ReportService {
  final EmailSender emailSender = EmailSender(
    apiUrl: 'https://email-sender-red.vercel.app/send-email',
    authToken: '123456',
  );

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
