import 'package:flutter/material.dart';

class NavigationController extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  String _activeSection = 'home';

  // Section keys for scrolling
  final GlobalKey homeKey = GlobalKey();
  final GlobalKey skillsKey = GlobalKey();
  final GlobalKey worksKey = GlobalKey();
  final GlobalKey faqKey = GlobalKey();
  final GlobalKey reviewKey = GlobalKey();

  String get activeSection => _activeSection;

  void setActiveSection(String section) {
    if (_activeSection != section) {
      _activeSection = section;
      notifyListeners();
    }
  }

  void scrollToSection(String section) {
    GlobalKey? targetKey;

    switch (section.toLowerCase()) {
      case 'home':
        targetKey = homeKey;
        break;
      case 'service':
      case 'skills':
        targetKey = skillsKey;
        break;
      case 'works':
        targetKey = worksKey;
        break;
      case 'faq':
        targetKey = faqKey;
        break;
      case 'review':
        targetKey = reviewKey;
        break;
    }

    if (targetKey != null && targetKey.currentContext != null) {
      final context = targetKey.currentContext!;
      final renderBox = context.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);

      // Smooth scroll to section with offset for navbar
      scrollController.animateTo(
        scrollController.offset + position.dy - 80, // 80px offset for navbar
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );

      setActiveSection(section.toLowerCase());
    }
  }

  void updateActiveSection() {
    // This will be called on scroll to update which section is active
    if (!scrollController.hasClients) return;

    final scrollOffset = scrollController.offset;

    // Check each section's position
    final sections = [
      {'key': homeKey, 'name': 'home'},
      {'key': skillsKey, 'name': 'skills'},
      {'key': worksKey, 'name': 'works'},
      {'key': faqKey, 'name': 'faq'},
      {'key': reviewKey, 'name': 'review'},
    ];

    for (var i = sections.length - 1; i >= 0; i--) {
      final section = sections[i];
      final key = section['key'] as GlobalKey;

      if (key.currentContext != null) {
        final renderBox = key.currentContext!.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);

        // If we've scrolled past this section's top (with some offset)
        if (scrollOffset >= position.dy - 100) {
          setActiveSection(section['name'] as String);
          break;
        }
      }
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
