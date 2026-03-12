// lib/providers/scroll_provider.dart

import 'package:flutter/material.dart';

class ScrollProvider extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  double _scrollOffset = 0;
  bool _isNavScrolled = false;

  // Section keys for navigation
  final GlobalKey heroKey = GlobalKey();
  final GlobalKey skillKey = GlobalKey();
  final GlobalKey projectsKey = GlobalKey();
  final GlobalKey experienceKey = GlobalKey();
  final GlobalKey contactKey = GlobalKey();

  double get scrollOffset => _scrollOffset;
  bool get isNavScrolled => _isNavScrolled;

  ScrollProvider() {
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    _scrollOffset = scrollController.offset;
    final newScrolled = _scrollOffset > 50;
    if (newScrolled != _isNavScrolled) {
      _isNavScrolled = newScrolled;
    }
    notifyListeners(); // always notify so navbar can animate smoothly
  }

  void scrollToSection(String section) {
    GlobalKey? key;
    switch (section) {
      case 'skills':
        key = skillKey;
        break;
      case 'projects':
        key = projectsKey;
        break;
      case 'experience':
        key = experienceKey;
        break;
      case 'contact':
        key = contactKey;
        break;
      default:
        key = heroKey;
    }

    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }
}