import 'package:flutter/material.dart';

enum DeviceType { mobile, tablet, web }

class ResponsiveConfig {
  // Breakpoints
  static const double mobileBreakpoint = 375;
  static const double tabletBreakpoint = 768;
  static const double webBreakpoint = 1280;

  // Grid Configuration
  // Web
  static const int webColumns = 12;
  static const double webGutter = 24.0;

  // Tablet
  static const int tabletColumns = 8;
  static const double tabletGutter = 20.0;

  // Mobile
  static const int mobileColumns = 6;
  static const double mobileGutter = 12.0;

  // Max Content Width
  static const double maxContentWidth = 1440;
}

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget web;

  const Responsive({
    super.key,
    required this.mobile,
    this.tablet,
    required this.web,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < ResponsiveConfig.tabletBreakpoint;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= ResponsiveConfig.tabletBreakpoint &&
      MediaQuery.of(context).size.width < ResponsiveConfig.webBreakpoint;

  static bool isWeb(BuildContext context) =>
      MediaQuery.of(context).size.width >= ResponsiveConfig.webBreakpoint;

  static DeviceType getDeviceType(BuildContext context) {
    if (isWeb(context)) return DeviceType.web;
    if (isTablet(context)) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  static double getGutter(BuildContext context) {
    if (isWeb(context)) return ResponsiveConfig.webGutter;
    if (isTablet(context)) return ResponsiveConfig.tabletGutter;
    return ResponsiveConfig.mobileGutter;
  }

  static int getColumns(BuildContext context) {
    if (isWeb(context)) return ResponsiveConfig.webColumns;
    if (isTablet(context)) return ResponsiveConfig.tabletColumns;
    return ResponsiveConfig.mobileColumns;
  }

  static double getResponsiveValue(
    BuildContext context, {
    required double mobile,
    double? tablet,
    required double web,
  }) {
    if (isWeb(context)) return web;
    if (isTablet(context)) return tablet ?? web;
    return mobile;
  }

  @override
  Widget build(BuildContext context) {
    if (isWeb(context)) return web;
    if (isTablet(context)) return tablet ?? web;
    return mobile;
  }
}

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;

  const ResponsiveWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: ResponsiveConfig.maxContentWidth,
        ),
        child: child,
      ),
    );
  }
}

class ResponsivePadding extends StatelessWidget {
  final Widget child;

  const ResponsivePadding({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final gutter = Responsive.getGutter(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: gutter),
      child: child,
    );
  }
}
