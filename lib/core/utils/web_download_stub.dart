// lib/core/utils/web_download_stub.dart
// Used on non-web platforms — does nothing, native handles its own download.

void triggerWebDownload(List<int> bytes, String fileName) {
  // No-op on native — handled by path_provider + open_file
}