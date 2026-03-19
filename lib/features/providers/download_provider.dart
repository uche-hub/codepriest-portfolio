import 'dart:io';

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/utils/web_download.dart'; // conditional web

enum DownloadState { idle, downloading, done, error }

class DownloadProvider extends ChangeNotifier {
  static const _prefKey = 'cv_downloaded_once';
  static const _assetPath = 'assets/files/cv.pdf';
  static const _fileName = 'Uchenna_Ndukwe_CV.pdf';

  DownloadState _state = DownloadState.idle;
  double _progress = 0.0;
  int _percent = 0;
  String? _error;

  DownloadState get state => _state;
  double get progress => _progress;
  int get percent => _percent;
  String? get error => _error;

  DownloadProvider() {
    _loadPersistedState();
  }

  Future<void> _loadPersistedState() async {
    final prefs = await SharedPreferences.getInstance();
    final done = prefs.getBool(_prefKey) ?? false;
    if (done) {
      _setState(DownloadState.done, 1.0, 100);
    }
  }

  Future<void> downloadCv() async {
    if (_state == DownloadState.downloading) return;
    if (_state == DownloadState.done)
      return; // already done — no re-download needed

    _setState(DownloadState.downloading, 0.0, 0);

    try {
      final bytes = await rootBundle
          .load(_assetPath)
          .then((data) => data.buffer.asUint8List());

      await _simulateRealisticProgress();

      if (kIsWeb) {
        triggerWebDownload(bytes, _fileName);
      } else {
        await _saveToDeviceAndOpen(bytes);
      }

      await _markAsDone();
    } catch (e) {
      _error = e.toString();
      _setState(DownloadState.error, 0.0, 0);
      Future.delayed(const Duration(seconds: 4), () {
        if (_state == DownloadState.error) _reset();
      });
    }
  }

  Future<void> _saveToDeviceAndOpen(Uint8List bytes) async {
    Directory dir;
    if (Platform.isAndroid) {
      dir =
          (await getExternalStorageDirectory()) ??
          await getTemporaryDirectory();
    } else if (Platform.isIOS || Platform.isMacOS) {
      dir = await getApplicationDocumentsDirectory();
    } else {
      dir = await getTemporaryDirectory();
    }

    final file = File('${dir.path}/$_fileName');
    await file.writeAsBytes(bytes);

    final result = await OpenFile.open(file.path);
    if (result.type != ResultType.done) {
      throw 'Open failed: ${result.message}';
    }
  }

  Future<void> _simulateRealisticProgress() async {
    const steps = 30;
    for (int i = 1; i <= steps; i++) {
      await Future.delayed(const Duration(milliseconds: 80));
      final val = i / steps;
      _progress = Curves.easeOut.transform(val);
      _percent = (_progress * 100).round();
      notifyListeners();
    }
  }

  Future<void> _markAsDone() async {
    _setState(DownloadState.done, 1.0, 100);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, true);
  }

  void _reset() {
    _setState(DownloadState.idle, 0.0, 0);
    _error = null;
  }

  void _setState(DownloadState s, double p, int pct) {
    _state = s;
    _progress = p;
    _percent = pct;
    notifyListeners();
  }
}
