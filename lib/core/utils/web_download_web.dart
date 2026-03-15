// lib/core/utils/web_download_web.dart
// Only compiled on Flutter Web — uses dart:html to trigger a real browser download.

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

void triggerWebDownload(List<int> bytes, String fileName) {
  try {
    final blob = html.Blob([bytes], 'application/pdf');
    final url  = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..setAttribute('download', fileName)
      ..style.display = 'none';

    html.document.body!.append(anchor);
    anchor.click();
    anchor.remove();

    Future.delayed(const Duration(seconds: 3), () {
      html.Url.revokeObjectUrl(url);
    });
  } catch (e) {
    // fallback: open in new tab
    html.window.open(
      'assets/files/$fileName',
      '_blank',
    );
  }
}