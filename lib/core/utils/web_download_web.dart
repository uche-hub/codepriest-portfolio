// lib/core/utils/web_download_web.dart
// Only compiled on Flutter Web — uses dart:html to trigger a real browser download.

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

void triggerWebDownload(List<int> bytes, String fileName) {
  final blob = html.Blob([bytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);

  // Create a hidden <a download="cv.pdf" href="blob:..."> and click it
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', fileName)
    ..style.display = 'none';

  html.document.body!.append(anchor);
  anchor.click();
  anchor.remove();

  // Release the object URL after a short delay
  Future.delayed(const Duration(seconds: 2), () {
    html.Url.revokeObjectUrl(url);
  });
}