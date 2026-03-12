// lib/providers/download_provider.dart

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/utils/web_download_stub.dart';

enum DownloadState { idle, downloading, done, error }

class DownloadProvider extends ChangeNotifier {
  static const _prefKey     = 'cv_downloaded';
  static const _prefPathKey = 'cv_saved_path';
  static const _assetPath   = 'assets/files/cv.pdf';
  static const _fileName    = 'cv.pdf';

  DownloadState _state    = DownloadState.idle;
  double        _progress = 0.0;
  int           _percent  = 0;
  String?       _savedPath;
  String?       _errorMessage;

  DownloadState get state        => _state;
  double        get progress     => _progress;
  int           get percent      => _percent;
  String?       get savedPath    => _savedPath;
  String?       get errorMessage => _errorMessage;

  DownloadProvider() {
    _restoreState();
  }

  // ── Restore persisted state on app start ────────────────────────────────────
  Future<void> _restoreState() async {
    final prefs = await SharedPreferences.getInstance();
    final wasDone = prefs.getBool(_prefKey) ?? false;

    if (!wasDone) return;

    if (kIsWeb) {
      // Web has no filesystem — just remember it was done
      _setState(DownloadState.done, progress: 1.0, percent: 100);
      return;
    }

    final path = prefs.getString(_prefPathKey);
    if (path != null && File(path).existsSync()) {
      _savedPath = path;
      _setState(DownloadState.done, progress: 1.0, percent: 100);
    } else {
      // File gone — clear stale prefs
      await prefs.remove(_prefKey);
      await prefs.remove(_prefPathKey);
    }
  }

  // ── Public: kick off download ────────────────────────────────────────────────
  Future<void> downloadCv() async {
    if (_state == DownloadState.downloading) return;

    _setState(DownloadState.downloading, progress: 0.0, percent: 0);

    try {
      // 1. Load asset bytes from bundle
      final ByteData data  = await rootBundle.load(_assetPath);
      final bytes          = data.buffer.asUint8List();

      // 2. Simulate chunked progress (looks great, feels real)
      await _simulateProgress(bytes.length);

      // 3. Actually deliver the file to the user
      if (kIsWeb) {
        // dart:html blob anchor — only real way to download on web
        triggerWebDownload(bytes, _fileName);
        await _markDone(null);
      } else {
        await _saveNative(bytes);
      }
    } catch (e) {
      _setState(DownloadState.error, percent: 0, progress: 0.0);
      Future.delayed(const Duration(seconds: 3), () {
        if (_state == DownloadState.error) {
          _setState(DownloadState.idle, progress: 0.0, percent: 0);
        }
      });
    }
  }

  // ── Simulate chunked progress with natural easing ───────────────────────────
  Future<void> _simulateProgress(int totalBytes) async {
    const steps    = 25;
    const stepMs   = 90; // ~2.25s total

    for (int i = 1; i <= steps; i++) {
      await Future.delayed(const Duration(milliseconds: stepMs));

      final raw    = i / steps;
      // Ease curve: fast → slow middle → fast end (mimics real download)
      final eased  = raw < 0.5
          ? 0.72 * (raw / 0.5)
          : 0.72 + 0.28 * ((raw - 0.5) / 0.5);

      _progress = eased.clamp(0.0, 1.0);
      _percent  = (_progress * 100).round();
      notifyListeners();
    }
  }

  // ── Native: write to Documents dir, then open with system app ───────────────
  Future<void> _saveNative(Uint8List bytes) async {
    final dir      = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/$_fileName';
    await File(filePath).writeAsBytes(bytes, flush: true);

    _savedPath = filePath;
    await _markDone(filePath);

    // Let the OS open it (Files app, PDF viewer, etc.)
    final uri = Uri.file(filePath);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  // ── Mark complete + persist ──────────────────────────────────────────────────
  Future<void> _markDone(String? path) async {
    _setState(DownloadState.done, progress: 1.0, percent: 100);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, true);
    if (path != null) await prefs.setString(_prefPathKey, path);
  }

  // ── Public: reset so user can re-download ───────────────────────────────────
  Future<void> reset() async {
    _savedPath    = null;
    _errorMessage = null;
    _setState(DownloadState.idle, progress: 0.0, percent: 0);

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefKey);
    await prefs.remove(_prefPathKey);
  }

  // ── Internal state helper ────────────────────────────────────────────────────
  void _setState(DownloadState state, {required double progress, required int percent}) {
    _state    = state;
    _progress = progress;
    _percent  = percent;
    notifyListeners();
  }
}