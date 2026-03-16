// lib/providers/download_provider.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/web_download_stub.dart';
// Add these imports for native platforms
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';

enum DownloadState { idle, downloading, done, error }

class DownloadProvider extends ChangeNotifier {
  static const _prefKey     = 'cv_downloaded';
  static const _assetPath   = 'assets/files/cv.pdf';
  static const _fileName    = 'cv.pdf';

  DownloadState _state    = DownloadState.idle;
  double        _progress = 0.0;
  int           _percent  = 0;
  String?       _errorMessage;

  DownloadState get state        => _state;
  double        get progress     => _progress;
  int           get percent      => _percent;
  String?       get errorMessage => _errorMessage;

  DownloadProvider() {
    _restoreState();
  }

  // ── Restore persisted state on app start ────────────────────────────────────
  // Temporarily modify this to debug
  Future<void> _restoreState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final wasDone = prefs.getBool(_prefKey) ?? false;
      print('Restore state - wasDone: $wasDone');

      // TEMPORARY: Force idle for debugging
      // Comment this out after testing
      if (wasDone) {
        print('Found done state, but forcing idle for testing');
        _setState(DownloadState.idle, progress: 0.0, percent: 0);
      } else {
        _setState(DownloadState.idle, progress: 0.0, percent: 0);
      }

      // Original code:
      // if (wasDone) {
      //   _setState(DownloadState.done, progress: 1.0, percent: 100);
      // }
    } catch (e) {
      print('Error restoring state: $e');
    }
  }

  Future<bool> checkAssetExists() async {
    try {
      await rootBundle.load(_assetPath);
      print('Asset exists at: $_assetPath');
      return true;
    } catch (e) {
      print('Asset NOT found: $_assetPath - Error: $e');
      return false;
    }
  }

  // ── Public: kick off download ────────────────────────────────────────────────
  Future<void> downloadCv() async {
    if (_state == DownloadState.downloading) return;

    // Check if asset exists first
    final assetExists = await checkAssetExists();
    if (!assetExists) {
      _errorMessage = 'CV file not found';
      _setState(DownloadState.error, progress: 0.0, percent: 0);
      return;
    }

    _setState(DownloadState.downloading, progress: 0.0, percent: 0);

    try {
      // 1. Load asset bytes from bundle
      final ByteData data = await rootBundle.load(_assetPath);
      final bytes = data.buffer.asUint8List();

      // 2. Simulate chunked progress
      await _simulateProgress();

      // 3. Deliver file based on platform
      if (kIsWeb) {
        // Web: use blob download
        triggerWebDownload(bytes, _fileName);
        await _markDone();
      } else {
        // Native (Android/iOS/Mac/Windows): save to temp directory and open
        await _saveAndOpenFile(bytes);
        await _markDone();
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setState(DownloadState.error, percent: 0, progress: 0.0);
      Future.delayed(const Duration(seconds: 3), () {
        if (_state == DownloadState.error) {
          _setState(DownloadState.idle, progress: 0.0, percent: 0);
        }
      });
    }
  }

  // ── Native file saving and opening ──────────────────────────────────────────
  Future<void> _saveAndOpenFile(Uint8List bytes) async {
    try {
      // Get temporary directory
      final Directory tempDir;
      if (Platform.isIOS || Platform.isMacOS) {
        tempDir = await getApplicationDocumentsDirectory();
      } else if (Platform.isAndroid) {
        tempDir = await getExternalStorageDirectory() ??
            await getTemporaryDirectory();
      } else {
        tempDir = await getTemporaryDirectory();
      }

      // Create file path
      final String filePath = '${tempDir.path}/$_fileName';
      final File file = File(filePath);

      // Write bytes to file
      await file.writeAsBytes(bytes);

      // Open the file
      final OpenResult result = await OpenFile.open(filePath);

      if (result.type != ResultType.done) {
        throw Exception('Failed to open file: ${result.message}');
      }
    } catch (e) {
      throw Exception('Failed to save/open file: $e');
    }
  }

  // ── Simulate chunked progress with natural easing ───────────────────────────
  Future<void> _simulateProgress() async {
    const steps  = 25;
    const stepMs = 90;

    for (int i = 1; i <= steps; i++) {
      await Future.delayed(const Duration(milliseconds: stepMs));
      final raw   = i / steps;
      final eased = raw < 0.5
          ? 0.72 * (raw / 0.5)
          : 0.72 + 0.28 * ((raw - 0.5) / 0.5);
      _progress = eased.clamp(0.0, 1.0);
      _percent  = (_progress * 100).round();
      notifyListeners();
    }
  }

  // ── Mark complete + persist ──────────────────────────────────────────────────
  Future<void> _markDone() async {
    _setState(DownloadState.done, progress: 1.0, percent: 100);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefKey, true);
    } catch (_) {}
  }

  Future<void> reset() async {
    print('Resetting download state...');
    _errorMessage = null;
    _setState(DownloadState.idle, progress: 0.0, percent: 0);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefKey);
      print('SharedPreferences cleared');
    } catch (e) {
      print('Error clearing SharedPreferences: $e');
    }
  }

  Future<void> forceReset() async {
    print('Force resetting...');
    _errorMessage = null;
    _setState(DownloadState.idle, progress: 0.0, percent: 0);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefKey);
      print('SharedPreferences cleared');
    } catch (e) {
      print('Error: $e');
    }
  }

  // ── Internal state helper ────────────────────────────────────────────────────
  void _setState(DownloadState state, {required double progress, required int percent}) {
    _state    = state;
    _progress = progress;
    _percent  = percent;
    notifyListeners();
  }
}