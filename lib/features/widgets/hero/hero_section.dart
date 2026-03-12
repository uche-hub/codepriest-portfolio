// lib/features/home/widgets/hero_section_widget.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/responsive_helper.dart';
import '../../providers/download_prodiver.dart';
import '../../providers/scroll_provider.dart';
import 'hero_skills_bar.dart';

class HeroSectionWidget extends StatelessWidget {
  const HeroSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // LayoutBuilder gives us the actual available width — most reliable
          LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              if (w < 600) return const _HeroBodyMobile();
              if (w < 1100) return _HeroBodyTablet(availableWidth: w);
              return const _HeroBodyDesktop();
            },
          ),
          const SkillsTickerWidget(),
        ],
      ),
    );
  }
}

// ─── Desktop Layout (≥1100px) ─────────────────────────────────────────────────

class _HeroBodyDesktop extends StatelessWidget {
  const _HeroBodyDesktop();

  @override
  Widget build(BuildContext context) {
    final hPad = ResponsiveHelper.getHorizontalPadding(context);
    final screenH = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(minHeight: screenH * 0.90),
      padding: EdgeInsets.fromLTRB(hPad, 40, 0, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            flex: 44,
            child: Padding(
              padding: EdgeInsets.only(right: hPad, bottom: 48),
              child: const _HeroTextContent(),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 56,
            child: const _HeroVisualContent(),
          ),
        ],
      ),
    );
  }
}

// ─── Tablet Layout (600–1099px) ───────────────────────────────────────────────
// Stacked: text on top, image below. Image scales with available width.

class _HeroBodyTablet extends StatelessWidget {
  final double availableWidth;
  const _HeroBodyTablet({required this.availableWidth});

  @override
  Widget build(BuildContext context) {
    final hPad = ResponsiveHelper.getHorizontalPadding(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text block — full width with padding
        Padding(
          padding: EdgeInsets.fromLTRB(hPad, 80, hPad, 36),
          child: const _HeroTextContent(),
        ),
        // Visual block — full width, image scales to available space
        const _HeroVisualContent(),
      ],
    );
  }
}

// ─── Mobile Layout (<600px) ───────────────────────────────────────────────────

class _HeroBodyMobile extends StatelessWidget {
  const _HeroBodyMobile();

  @override
  Widget build(BuildContext context) {
    final hPad = ResponsiveHelper.getHorizontalPadding(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(hPad, 72, hPad, 28),
          child: const _HeroTextContent(),
        ),
        const _HeroVisualContent(),
      ],
    );
  }
}

// ─── Text Content ─────────────────────────────────────────────────────────────

class _HeroTextContent extends StatefulWidget {
  const _HeroTextContent();

  @override
  State<_HeroTextContent> createState() => _HeroTextContentState();
}

class _HeroTextContentState extends State<_HeroTextContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final titleSize = ResponsiveHelper.getHeroTitleFontSize(context);
    final bodySize = ResponsiveHelper.getBodyFontSize(context);

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hi emoji
            Text(
              '✋',
              style: TextStyle(fontSize: isMobile ? 28 : 36),
            ),
            const SizedBox(height: 12),

            // Hello! I'm Uchenna — always one line, shrinks if needed
            LayoutBuilder(
              builder: (context, constraints) {
                return FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    maxLines: 1,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Hello! ',
                          style: GoogleFonts.dmSans(
                            fontSize: titleSize,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            height: 1.08,
                          ),
                        ),
                        TextSpan(
                          text: "I'm ${AppConstants.name}",
                          style: GoogleFonts.dmSans(
                            fontSize: titleSize,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                            height: 1.08,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Role line with star
            Row(
              children: [
                Container(
                  height: 1.5,
                  width: isMobile ? 40 : 60,
                  color: Colors.black,
                ),
                const SizedBox(width: 12),
                Text(
                  AppConstants.role,
                  style: GoogleFonts.dmSans(
                    fontSize: isMobile ? 14 : 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(width: 10),
                const _StarShape(size: 14),
              ],
            ),
            const SizedBox(height: 20),

            // Bio description — single RichText, wraps in ~2 lines
            RichText(
              text: TextSpan(
                style: GoogleFonts.dmSans(
                  fontSize: bodySize,
                  color: Colors.black87,
                  height: 1.65,
                ),
                children: [
                  TextSpan(
                    text: 'Hello! I\'m ${AppConstants.name}. I\'m a ',
                    style: const TextStyle(fontWeight: FontWeight.w400),
                  ),
                  TextSpan(
                    text: 'Developer Programmer | Flutter Developer',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const TextSpan(
                    text: ', with a 5 years experience in Software Development and 3 years professional experience in Mobile Development Flutter. Reliable and a hard worker. A fast learner, ready to work with others. Proven ability to collaborate in remote Agile teams, write clean scalable code, and deliver production-ready mobile solutions. ',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            SizedBox(height: isMobile ? 20 : 28),

            // Checklist
            ...AppConstants.philosophies.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  const Icon(Icons.check, size: 17, color: Colors.black),
                  const SizedBox(width: 10),
                  Text(
                    item,
                    style: GoogleFonts.dmSans(
                      fontSize: bodySize,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            )),
            SizedBox(height: isMobile ? 28 : 36),

            // CTA Buttons
            Wrap(
              spacing: 24,
              runSpacing: 14,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _BlackButton(
                  label: "Let's Talk",
                  onTap: () {
                    final sp = context.read<ScrollProvider>();
                    sp.scrollToSection('contact');
                  },
                ),
                _DownloadCvButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Visual Content ───────────────────────────────────────────────────────────

class _HeroVisualContent extends StatelessWidget {
  const _HeroVisualContent();

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;

      if (w < 600) {
        // Mobile: centered image with margins
        return const _MobileVisual();
      }

      if (w < 1100) {
        // Tablet: image fills full width, height capped at 70vh
        final imgHeight = (w * 1.05).clamp(0.0, screenH * 0.70);
        return _TabletVisual(availableWidth: w, imgHeight: imgHeight);
      }

      // Desktop: tall image
      final imgHeight = screenH * 0.92;
      return _DesktopVisual(imgHeight: imgHeight);
    });
  }
}

// ─── Desktop visual (≥1100px) ─────────────────────────────────────────────────

class _DesktopVisual extends StatelessWidget {
  final double imgHeight;
  const _DesktopVisual({required this.imgHeight});

  @override
  Widget build(BuildContext context) {
    final circleSize = imgHeight < 500 ? 120.0 : 155.0;
    final imgWidth   = imgHeight * 0.72;
    const circleLeft = 0.0;
    final imgLeft    = circleLeft + circleSize - 18.0;

    return SizedBox(
      height: imgHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top:  imgHeight / 2 - circleSize / 2,
            left: circleLeft,
            child: _CrossedCircle(circleSize: circleSize),
          ),
          Positioned(
            left:   imgLeft,
            top:    0,
            bottom: 0,
            child: _PersonImage(height: imgHeight, width: imgWidth),
          ),
          Positioned(
            left: imgLeft + imgWidth - 10,
            top:  imgHeight * 0.28,
            child: const _WormLines(),
          ),
        ],
      ),
    );
  }
}

// ─── Tablet visual (600–1099px) ───────────────────────────────────────────────
// Full available width. Image centered, Hello circle left side, worms right.

class _TabletVisual extends StatelessWidget {
  final double availableWidth;
  final double imgHeight;
  const _TabletVisual({required this.availableWidth, required this.imgHeight});

  @override
  Widget build(BuildContext context) {
    // Scale elements relative to available width
    final circleSize = (availableWidth * 0.14).clamp(90.0, 140.0);
    final imgWidth   = (availableWidth * 0.62).clamp(300.0, 680.0);

    // Image centered in available space
    final imgLeft    = (availableWidth - imgWidth) / 2;
    // Circle left of image, partially hidden behind it
    final circleLeft = imgLeft - circleSize * 0.55;

    return SizedBox(
      width: availableWidth,
      height: imgHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Hello circle — vertically centered, behind image
          Positioned(
            top:  imgHeight / 2 - circleSize / 2,
            left: circleLeft.clamp(0.0, availableWidth),
            child: _CrossedCircle(circleSize: circleSize),
          ),

          // Person image — centered
          Positioned(
            left:   imgLeft,
            top:    0,
            bottom: 0,
            child: _PersonImage(height: imgHeight, width: imgWidth),
          ),

          // Worm lines — right edge of image
          Positioned(
            left: (imgLeft + imgWidth - 12).clamp(0.0, availableWidth - 30),
            top:  imgHeight * 0.28,
            child: const _WormLines(),
          ),
        ],
      ),
    );
  }
}

// ─── Mobile visual ────────────────────────────────────────────────────────────

class _MobileVisual extends StatelessWidget {
  const _MobileVisual();

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    const hMargin = 20.0;
    final imgWidth = screenW - hMargin * 2;
    final imgHeight = imgWidth * 1.28;
    const circleSize = 110.0;

    // Circle peeks out ~40% from behind image left edge
    final circleLeft = hMargin - circleSize * 0.40;

    return SizedBox(
      width: double.infinity,
      height: imgHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Hello circle — vertically centered, behind image
          Positioned(
            top: imgHeight / 2 - circleSize / 2,
            left: circleLeft,
            child: _CrossedCircle(circleSize: circleSize),
          ),

          // Person image — bottom flush, left margin
          Positioned(
            bottom: 0,
            left: hMargin,
            child: _PersonImage(height: imgHeight, width: imgWidth),
          ),

          // Worm lines — right of image
          Positioned(
            right: hMargin - 10,
            top: imgHeight * 0.22,
            child: const _WormLines(),
          ),
        ],
      ),
    );
  }
}

class _CrossedCircle extends StatelessWidget {
  final double circleSize;
  const _CrossedCircle({required this.circleSize});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: circleSize,
      height: circleSize,
      child: Stack(
        children: [
          // Black circle
          Container(
            width: circleSize,
            height: circleSize,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),

          // Slanted line: top-left → bottom-right
          CustomPaint(
            size: Size(circleSize, circleSize),
            painter: _SlantedLinePainter(circleSize: circleSize),
          ),

          // "Hello" text centered
          Center(
            child: Text(
              'Hello',
              style: GoogleFonts.dmSans(
                fontSize: circleSize * 0.21,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SlantedLinePainter extends CustomPainter {
  final double circleSize;
  const _SlantedLinePainter({required this.circleSize});

  @override
  void paint(Canvas canvas, Size size) {
    // Slant: top-left corner → bottom-right corner of the bounding box
    // This gives the exact diagonal seen in the screenshot
    final topLeft = Offset(0, 0);
    final bottomRight = Offset(size.width, size.height);

    // Black line extending well beyond circle edges
    canvas.drawLine(
      topLeft,
      bottomRight,
      Paint()
        ..color = Colors.black
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );

    // White segment inside circle only — clip to circle path
    final circlePath = Path()
      ..addOval(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.save();
    canvas.clipPath(circlePath);
    canvas.drawLine(
      topLeft,
      bottomRight,
      Paint()
        ..color = Colors.white
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_SlantedLinePainter old) => old.circleSize != circleSize;
}

class _PersonImage extends StatelessWidget {
  final double height;
  final double width;
  const _PersonImage({required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      ),
      child: Image.asset(
        'assets/images/profile.png',
        width: width,
        height: height,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
      ),
    );
  }
}

// ─── Worm Lines ───────────────────────────────────────────────────────────────
// Two thick slanted S-curves, touching image's right edge.
// Black solid + white with black border, stacked side by side.

class _WormLines extends StatelessWidget {
  const _WormLines();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 80,
      child: CustomPaint(painter: _WormPainter()),
    );
  }
}

class _WormPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Slant the curves: they lean top-right → bottom-left (mirrored S shape)
    // Black worm — left
    final path1 = Path();
    path1.moveTo(w * 0.20, 0);
    path1.cubicTo(
      w * 1.0,  h * 0.15,
      w * -0.2, h * 0.65,
      w * 0.20, h,
    );
    canvas.drawPath(
      path1,
      Paint()
        ..color = Colors.black
        ..strokeWidth = 6
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // White worm with black border — right, slightly offset
    final path2 = Path();
    path2.moveTo(w * 0.72, 0);
    path2.cubicTo(
      w * 1.5,  h * 0.18,
      w * 0.30, h * 0.68,
      w * 0.72, h,
    );
    // Border first
    canvas.drawPath(
      path2,
      Paint()
        ..color = Colors.black
        ..strokeWidth = 8
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    // White fill on top
    canvas.drawPath(
      path2,
      Paint()
        ..color = Colors.white
        ..strokeWidth = 5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_WormPainter _) => false;
}

// ─── Reusable Widgets ─────────────────────────────────────────────────────────

class _StarShape extends StatelessWidget {
  final double size;
  const _StarShape({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _StarPainter()),
    );
  }
}

class _StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;
    const points = 4;
    const innerRatio = 0.35;
    final path = Path();
    for (int i = 0; i < points * 2; i++) {
      final angle = (i * pi / points) - pi / 2;
      final radius = i.isEven ? r : r * innerRatio;
      final pt = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      i == 0 ? path.moveTo(pt.dx, pt.dy) : path.lineTo(pt.dx, pt.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_StarPainter _) => false;
}

class _BlackButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _BlackButton({required this.label, required this.onTap});

  @override
  State<_BlackButton> createState() => _BlackButtonState();
}

class _BlackButtonState extends State<_BlackButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 22 : 28,
            vertical: isMobile ? 12 : 15,
          ),
          decoration: BoxDecoration(
            color: _hovered ? const Color(0xFF333333) : Colors.black,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            widget.label,
            style: GoogleFonts.dmSans(
              fontSize: isMobile ? 13 : 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}

class _DownloadCvButton extends StatefulWidget {
  @override
  State<_DownloadCvButton> createState() => _DownloadCvButtonState();
}

class _DownloadCvButtonState extends State<_DownloadCvButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final fontSize = isMobile ? 13.0 : 14.0;

    return Consumer<DownloadProvider>(
      builder: (context, dl, _) {
        final isIdle = dl.state == DownloadState.idle;
        final isDownloading = dl.state == DownloadState.downloading;
        final isDone = dl.state == DownloadState.done;
        final isError = dl.state == DownloadState.error;

        // Label text
        final label = isDone
            ? 'Downloaded!'
            : isError
            ? 'Try again'
            : isDownloading
            ? '${dl.percent}%'
            : 'Download CV';

        // Icon
        Widget icon;
        if (isDone) {
          icon = Icon(Icons.check_circle_rounded,
              key: const ValueKey('check'), size: fontSize + 2, color: Colors.black);
        } else if (isDownloading) {
          icon = SizedBox(
            key: const ValueKey('spin'),
            width: fontSize + 2,
            height: fontSize + 2,
            child: CircularProgressIndicator(
              value: dl.progress,
              strokeWidth: 1.8,
              color: Colors.black,
              backgroundColor: Colors.black12,
            ),
          );
        } else if (isError) {
          icon = Icon(Icons.error_outline_rounded,
              key: const ValueKey('err'), size: fontSize + 2, color: Colors.black54);
        } else {
          icon = Icon(Icons.download_rounded,
              key: const ValueKey('dl'),
              size: fontSize + 2,
              color: _hovered ? Colors.black : Colors.black87);
        }

        return MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          cursor: isDownloading
              ? SystemMouseCursors.basic
              : SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              if (isDone) {
                // Already downloaded — allow re-download
                dl.reset();
              } else {
                dl.downloadCv();
              }
            },
            child: SizedBox(
              width: 140,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Label + icon row
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          label,
                          key: ValueKey(label),
                          style: GoogleFonts.dmSans(
                            fontSize: fontSize,
                            fontWeight: FontWeight.w500,
                            color: _hovered || isDownloading
                                ? Colors.black
                                : Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: icon,
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Progress underline bar
                  Stack(
                    children: [
                      // Track
                      Container(
                        height: 1.5,
                        width: 140,
                        color: _hovered && isIdle
                            ? Colors.black
                            : Colors.black26,
                      ),
                      // Fill — animates with actual progress
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 40),
                        height: 1.5,
                        width: 140 * dl.progress,
                        decoration: BoxDecoration(
                          color: isDone ? Colors.black : Colors.black,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}