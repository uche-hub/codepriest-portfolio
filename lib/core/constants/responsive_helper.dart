// lib/core/utils/responsive_helper.dart

import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

enum ScreenSize { mobile, tablet, desktop }

class ResponsiveHelper {
  static ScreenSize getScreenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < AppConstants.mobileBreakpoint) return ScreenSize.mobile;
    if (width < AppConstants.tabletBreakpoint) return ScreenSize.tablet;
    return ScreenSize.desktop;
  }

  static bool isMobile(BuildContext context) =>
      getScreenSize(context) == ScreenSize.mobile;

  static bool isTablet(BuildContext context) =>
      getScreenSize(context) == ScreenSize.tablet;

  static bool isDesktop(BuildContext context) =>
      getScreenSize(context) == ScreenSize.desktop;

  /// Fluid horizontal padding: scales linearly with screen width
  static double getHorizontalPadding(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w < 600) return 20;
    if (w < 1100) {
      // 600→1100 maps 20→60
      return 20 + (w - 600) / 500 * 40;
    }
    return 80;
  }

  /// Hero title: fluid scaling across all widths
  static double getHeroTitleFontSize(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w < 400) return 30;
    if (w < 600) return 36;
    if (w < 800) return 44;
    if (w < 1000) return 52;
    if (w < 1200) return 62;
    return 74;
  }

  /// Body text: fluid
  static double getBodyFontSize(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w < 600) return 13;
    if (w < 900) return 13.5;
    if (w < 1100) return 14;
    return 15;
  }

  /// Nav font
  static double getNavFontSize(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w < 600) return 13;
    if (w < 900) return 13;
    return 14;
  }

  /// Skill ticker font
  static double getSkillBarFontSize(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w < 600) return 10;
    if (w < 900) return 12;
    return 14;
  }

  /// Generic scale multiplier
  static double scale(BuildContext context, double value) {
    final w = MediaQuery.of(context).size.width;
    if (w < 600) return value * 0.6;
    if (w < 900) return value * 0.75;
    if (w < 1100) return value * 0.88;
    return value;
  }
}

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const Responsive({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < AppConstants.mobileBreakpoint) {
          return mobile;
        } else if (constraints.maxWidth < AppConstants.tabletBreakpoint) {
          return tablet ?? desktop;
        } else {
          return desktop;
        }
      },
    );
  }
}