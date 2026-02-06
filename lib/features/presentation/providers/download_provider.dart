import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/utils/app_logger.dart';

// Modern Web Imports
import 'dart:js_interop';
import 'package:web/web.dart' as web;

class DownloadProvider extends ChangeNotifier {
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String _downloadStatus = '';

  bool get isDownloading => _isDownloading;
  double get downloadProgress => _downloadProgress;
  String get downloadStatus => _downloadStatus;

  Future<void> downloadCV() async {
    try {
      _isDownloading = true;
      _downloadProgress = 0.0;
      _downloadStatus = 'Preparing download...';
      notifyListeners();

      appLogger.info('Starting CV download');

      // Simulate progress steps for better UX
      await _updateProgress(0.1, 'Loading file...');

      // Load CV file from assets
      final ByteData data = await rootBundle.load('/files/cv.pdf');
      await _updateProgress(0.3, 'Processing...');

      final Uint8List bytes = data.buffer.asUint8List();
      await _updateProgress(0.6, 'Preparing download...');

      // Create blob and download for web
      if (kIsWeb) {
        // Convert Dart Uint8List to JS compatible array for the Blob
        final jsBytes = bytes.toJS;
        final blob = web.Blob(
          [jsBytes].toJS,
          web.BlobPropertyBag(type: 'application/pdf'),
        );

        await _updateProgress(0.8, 'Creating download link...');

        // Use the static URL class from package:web
        final url = web.URL.createObjectURL(blob);

        // Create anchor and trigger click
        final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
        anchor.href = url;
        anchor.download = 'Uchenna_Ndukwe_CV.pdf';
        anchor.click();

        await _updateProgress(0.95, 'Downloading...');

        // Revoke to prevent memory leaks
        web.URL.revokeObjectURL(url);

        await _updateProgress(1.0, 'Download complete!');
        appLogger.info('CV downloaded successfully');

        // Save download count
        await _incrementDownloadCount();
      }

      // Keep at 100% briefly before resetting
      await Future.delayed(const Duration(milliseconds: 500));

      _isDownloading = false;
      _downloadProgress = 0.0;
      notifyListeners();

      // Clear status after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        _downloadStatus = '';
        notifyListeners();
      });
    } catch (e, stackTrace) {
      _isDownloading = false;
      _downloadProgress = 0.0;
      _downloadStatus = 'Download failed';
      notifyListeners();
      appLogger.error('Failed to download CV', e, stackTrace);

      Future.delayed(const Duration(seconds: 3), () {
        _downloadStatus = '';
        notifyListeners();
      });
    }
  }

  Future<void> _updateProgress(double progress, String status) async {
    // Smooth animation from current to target progress
    final startProgress = _downloadProgress;
    const steps = 20;
    final increment = (progress - startProgress) / steps;

    for (int i = 0; i < steps; i++) {
      _downloadProgress = startProgress + (increment * (i + 1));
      _downloadStatus = status;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 30));
    }

    _downloadProgress = progress;
    _downloadStatus = status;
    notifyListeners();
  }

  Future<void> _incrementDownloadCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentCount = prefs.getInt('cv_download_count') ?? 0;
      await prefs.setInt('cv_download_count', currentCount + 1);
      await prefs.setString(
        'last_download_date',
        DateTime.now().toIso8601String(),
      );
      appLogger.debug('Download count: ${currentCount + 1}');
    } catch (e, stackTrace) {
      appLogger.error('Failed to save download count', e, stackTrace);
    }
  }

  Future<int> getDownloadCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('cv_download_count') ?? 0;
    } catch (e, stackTrace) {
      appLogger.error('Failed to get download count', e, stackTrace);
      return 0;
    }
  }

  Future<String?> getLastDownloadDate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('last_download_date');
    } catch (e, stackTrace) {
      appLogger.error('Failed to get last download date', e, stackTrace);
      return null;
    }
  }
}
