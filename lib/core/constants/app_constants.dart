// lib/core/constants/app_constants.dart

class AppConstants {
  // Colors
  static const int primaryWhite = 0xFFFFFFFF;
  static const int primaryBlack = 0xFF0A0A0A;
  static const int lightGrey = 0xFFF5F5F5;
  static const int mediumGrey = 0xFF9E9E9E;

  // Blur colors
  static const int blurBlue = 0xFF64B5F6;
  static const int blurYellow = 0xFFFFE082;
  static const int blurRed = 0xFFEF9A9A;
  static const int blurGreen = 0xFFA5D6A7;

  // Strings
  static const String name = "Uchenna";
  static const String role = "Developer Programmer | Flutter Developer";
  static const String email = "ucj.justice@gmail.com";
  static const String shortBio =
      "Developer Programmer | Flutter Developer with a 5 years experience in Software Development and 3 years professional experience in Mobile Development Flutter. Reliable and a hard worker. A fast learner, ready to work with others. Proven ability to collaborate in remote Agile teams, write clean scalable code, and deliver production-ready mobile solutions.";

  static const List<String> philosophies = [
    "Product must be authentic",
    "Solve pain points elegantly",
    "User testing, feedback, and validation",
  ];

  static const List<String> skills = [
    " Developer Programmer ",
    " Flutter Developer ",
    " Dart ",
    " Firebase ",
    " CI/CD ",
    " Git ",
  ];

  // Nav links
  static const List<Map<String, String>> navLinks = [
    {
      'title': 'My Skills',
      'description': 'Flutter, Dart, Firebase and the full mobile stack.',
      'route': '/skills',
    },
    {
      'title': 'My Projects',
      'description': 'Real apps shipped to iOS and Android — see the work.',
      'route': '/projects',
    },
    {
      'title': 'Experience',
      'description': '5 years building software, 3 focused on mobile',
      'route': '/experience',
    },
    {
      'title': 'Contact me',
      'description': 'ucj.justice@gmail.com',
      'route': '/contact',
    },
  ];

  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1100;
  static const double desktopBreakpoint = 1200;

  // Spacing
  static const double maxContentWidth = 1400;
  static const double horizontalPaddingDesktop = 80;
  static const double horizontalPaddingTablet = 48;
  static const double horizontalPaddingMobile = 20;
}
