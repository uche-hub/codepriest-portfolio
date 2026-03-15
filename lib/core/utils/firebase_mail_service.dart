// lib/core/utils/firebase_mail_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseMailService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Sends a contact form submission to Firestore.
  /// The 'Trigger Email' extension will pick this up and send it to your Gmail.
  static Future<String?> send({
    required String name,
    required String email,
    required String company,
    required String topics,
    required String message,
  }) async {
    try {
      // The extension specifically looks for 'to', 'replyTo', and 'message'
      await _db.collection('mail').add({
        'to': ['ucj.justice@gmail.com'],
        'replyTo': email,
        'message': {
          'subject': 'Portfolio Contact: $name',
          'html': '''
            <div style="font-family: sans-serif; line-height: 1.6; color: #333;">
              <h2>New Project Inquiry</h2>
              <p><strong>Name:</strong> $name</p>
              <p><strong>Email:</strong> $email</p>
              <p><strong>Company:</strong> ${company.isEmpty ? '—' : company}</p>
              <p><strong>Topics:</strong> $topics</p>
              <hr style="border: 0; border-top: 1px solid #eee;">
              <p><strong>Message:</strong></p>
              <p style="white-space: pre-wrap;">$message</p>
            </div>
          ''',
        },
        'timestamp': FieldValue.serverTimestamp(),
      });
      return null; // success
    } catch (e) {
      return 'Database error: ${e.toString()}';
    }
  }
}