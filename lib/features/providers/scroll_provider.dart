// lib/providers/scroll_provider.dart

import 'package:flutter/material.dart';

class ScrollProvider extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  double _scrollOffset = 0;
  bool _isNavScrolled = false;

  // Section keys for navigation
  final GlobalKey heroKey       = GlobalKey();
  final GlobalKey skillKey      = GlobalKey();
  final GlobalKey projectsKey   = GlobalKey();
  final GlobalKey experienceKey = GlobalKey();
  final GlobalKey contactKey    = GlobalKey();

  double get scrollOffset  => _scrollOffset;
  bool   get isNavScrolled => _isNavScrolled;

  ScrollProvider() {
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    _scrollOffset = scrollController.offset;
    final newScrolled = _scrollOffset > 50;
    if (newScrolled != _isNavScrolled) {
      _isNavScrolled = newScrolled;
    }
    notifyListeners();
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
      // Scroll to top — clamped at 0, never goes negative
        if (scrollController.hasClients) {
          scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubic,
          );
        }
        return;
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