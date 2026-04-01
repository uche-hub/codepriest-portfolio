// // lib/core/utils/emailjs_service.dart
// //
// // EmailJS REST API — works on Flutter Web with zero backend.
// //
// // SETUP STEPS (one-time, free at emailjs.com):
// // ─────────────────────────────────────────────
// // 1. Create a free account at https://www.emailjs.com
// // 2. Add a service: Email Services → Add New Service → Gmail
// //    → Connect your Gmail (ucj.justice@gmail.com) → Copy SERVICE_ID
// // 3. Create a template: Email Templates → Create New Template
// //    Use these exact template variables:
// //      Subject:  New Portfolio Contact from {{from_name}}
// //      Body:
// //        Name:    {{from_name}}
// //        Email:   {{reply_to}}
// //        Company: {{company}}
// //        Topics:  {{topics}}
// //        Message: {{message}}
// //    → Save and copy TEMPLATE_ID
// // 4. Get your Public Key: Account → API Keys → Public Key
// // 5. Paste the three values into the constants below.
//
// import 'dart:convert';
// // ignore: avoid_web_libraries_in_flutter
// import 'dart:html' as html;
//
// class EmailJSService {
//   // ── Paste your EmailJS credentials here ──────────────────────────────────
//   static const _serviceId  = 'YOUR_SERVICE_ID';   // e.g. 'service_abc123'
//   static const _templateId = 'YOUR_TEMPLATE_ID';  // e.g. 'template_xyz789'
//   static const _publicKey  = 'YOUR_PUBLIC_KEY';   // e.g. 'AbCdEfGhIjKlMnOp'
//   // ─────────────────────────────────────────────────────────────────────────
//
//   /// Sends a contact form submission via EmailJS REST API.
//   /// Returns null on success, or an error message string on failure.
//   static Future<String?> send({
//     required String name,
//     required String email,
//     required String company,
//     required String topics,
//     required String message,
//   }) async {
//     const url = 'https://api.emailjs.com/api/v1.0/email/send';
//
//     final payload = jsonEncode({
//       'service_id':  _serviceId,
//       'template_id': _templateId,
//       'user_id':     _publicKey,
//       'template_params': {
//         'from_name': name,
//         'reply_to':  email,
//         'company':   company.isEmpty ? '—' : company,
//         'topics':    topics.isEmpty  ? '—' : topics,
//         'message':   message.isEmpty ? '—' : message,
//         'to_email':  'ucj.justice@gmail.com',
//       },
//     });
//
//     try {
//       final xhr = html.HttpRequest();
//       xhr.open('POST', url, async: true);
//       xhr.setRequestHeader('Content-Type', 'application/json');
//
//       final completer = html.HttpRequest.request(
//         url,
//         method: 'POST',
//         requestHeaders: {'Content-Type': 'application/json'},
//         sendData: payload,
//       );
//
//       final response = await completer;
//
//       if (response.status == 200) {
//         return null; // success
//       } else {
//         return 'Failed to send (${response.status}). Please try again.';
//       }
//     } catch (e) {
//       return 'Network error. Please check your connection and try again.';
//     }
//   }
// }
