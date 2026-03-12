// lib/core/utils/web_download.dart
// Conditional import: on web uses dart:html, on native uses stub.

export 'web_download_stub.dart'
if (dart.library.html) 'web_download_web.dart';