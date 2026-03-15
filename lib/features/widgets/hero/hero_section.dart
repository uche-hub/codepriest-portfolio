// lib/features/home/widgets/hero_section_widget.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/responsive_helper.dart';
import '../../providers/download_provider.dart';
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
          const Expanded(
            flex: 56,
            child: _HeroVisualContent(),
          ),
        ],
      ),
    );
  }
}

// ─── Tablet Layout (600–1099px) ───────────────────────────────────────────────

class _HeroBodyTablet extends StatelessWidget {
  final double availableWidth;
  const _HeroBodyTablet({required this.availableWidth, super.key});

  @override
  Widget build(BuildContext context) {
    final hPad = ResponsiveHelper.getHorizontalPadding(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(hPad, 80, hPad, 36),
          child: const _HeroTextContent(),
        ),
        const _HeroVisualContent(),
      ],
    );
  }
}

// ─── Mobile Layout (<600px) ───────────────────────────────────────────────────

class _HeroBodyMobile extends StatelessWidget {
  const _HeroBodyMobile({super.key});

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
    with TickerProviderStateMixin {
  late AnimationController _ctrl;
  late AnimationController _waveCtrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // FIX: Use addPostFrameCallback to avoid SchedulerPhase.midFrameMicrotasks error
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _ctrl.forward();
        _waveCtrl.repeat(reverse: true);
        Future.delayed(const Duration(milliseconds: 2400), () {
          if (mounted) _waveCtrl.stop();
        });
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _waveCtrl.dispose();
    super.dispose();
  }

  Widget _staggeredFade(Widget child, double start, double end) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _ctrl,
        curve: Interval(start, end, curve: Curves.easeOut),
      ),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
            .animate(CurvedAnimation(
          parent: _ctrl,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        )),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final titleSize = ResponsiveHelper.getHeroTitleFontSize(context);
    final bodySize = ResponsiveHelper.getBodyFontSize(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _staggeredFade(
          RotationTransition(
            turns: Tween(begin: -0.05, end: 0.05).animate(_waveCtrl),
            child: Text('✋', style: TextStyle(fontSize: isMobile ? 28 : 36)),
          ),
          0.0, 0.4,
        ),
        const SizedBox(height: 12),
        _staggeredFade(
          FittedBox(
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
          ),
          0.1, 0.5,
        ),
        const SizedBox(height: 16),
        _staggeredFade(
          Row(
            children: [
              Container(height: 1.5, width: isMobile ? 40 : 60, color: Colors.black),
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
          0.2, 0.6,
        ),
        const SizedBox(height: 20),
        _staggeredFade(
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
                const TextSpan(
                  text: 'Developer Programmer | Flutter Developer',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const TextSpan(
                  text: ', with a 5 years experience in Software Development and 3 years professional experience in Mobile Development Flutter.',
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          0.3, 0.7,
        ),
        SizedBox(height: isMobile ? 20 : 28),
        ...List.generate(AppConstants.philosophies.length, (index) {
          return _staggeredFade(
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  const Icon(Icons.check, size: 17, color: Colors.black),
                  const SizedBox(width: 10),
                  Text(
                    AppConstants.philosophies[index],
                    style: GoogleFonts.dmSans(
                      fontSize: bodySize,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            0.4 + (index * 0.05), 0.8 + (index * 0.05),
          );
        }),
        SizedBox(height: isMobile ? 28 : 36),
        _staggeredFade(
          Wrap(
            spacing: 24,
            runSpacing: 14,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _BlackButton(
                label: "Let's Talk",
                onTap: () => context.read<ScrollProvider>().scrollToSection('contact'),
              ),
              const _DownloadCvButton(),
            ],
          ),
          0.6, 1.0,
        ),
      ],
    );
  }
}

// ─── Visual Content ───────────────────────────────────────────────────────────

class _HeroVisualContent extends StatefulWidget {
  const _HeroVisualContent();

  @override
  State<_HeroVisualContent> createState() => _HeroVisualContentState();
}

class _HeroVisualContentState extends State<_HeroVisualContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatCtrl;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      if (w < 600) return _MobileVisual(floatCtrl: _floatCtrl);
      if (w < 1100) {
        final imgHeight = (w * 1.05).clamp(0.0, screenH * 0.70);
        return _TabletVisual(availableWidth: w, imgHeight: imgHeight, floatCtrl: _floatCtrl);
      }
      return _DesktopVisual(imgHeight: screenH * 0.92, floatCtrl: _floatCtrl);
    });
  }
}

// ─── Desktop visual (≥1100px) ─────────────────────────────────────────────────

class _DesktopVisual extends StatelessWidget {
  final double imgHeight;
  final AnimationController floatCtrl;
  const _DesktopVisual({required this.imgHeight, required this.floatCtrl});

  @override
  Widget build(BuildContext context) {
    final circleSize = imgHeight < 500 ? 120.0 : 155.0;
    final imgWidth = imgHeight * 0.72;
    const circleLeft = 0.0;
    final imgLeft = circleLeft + circleSize - 18.0;

    return SizedBox(
      height: imgHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedBuilder(
            animation: floatCtrl,
            builder: (context, child) => Positioned(
              top: (imgHeight / 2 - circleSize / 2) + (floatCtrl.value * 15),
              left: circleLeft,
              child: child!,
            ),
            child: _CrossedCircle(circleSize: circleSize),
          ),
          Positioned(
            left: imgLeft,
            top: 0,
            bottom: 0,
            child: _PersonImage(height: imgHeight, width: imgWidth),
          ),
          AnimatedBuilder(
            animation: floatCtrl,
            builder: (context, child) => Positioned(
              left: imgLeft + imgWidth - 10,
              top: (imgHeight * 0.28) - (floatCtrl.value * 10),
              child: child!,
            ),
            child: const _WormLines(),
          ),
        ],
      ),
    );
  }
}

// ─── Tablet visual (600–1099px) ───────────────────────────────────────────────

class _TabletVisual extends StatelessWidget {
  final double availableWidth;
  final double imgHeight;
  final AnimationController floatCtrl;
  const _TabletVisual({required this.availableWidth, required this.imgHeight, required this.floatCtrl});

  @override
  Widget build(BuildContext context) {
    final circleSize = (availableWidth * 0.14).clamp(90.0, 140.0);
    final imgWidth = (availableWidth * 0.62).clamp(300.0, 680.0);
    final imgLeft = (availableWidth - imgWidth) / 2;
    final circleLeft = imgLeft - circleSize * 0.55;

    return SizedBox(
      width: availableWidth,
      height: imgHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedBuilder(
            animation: floatCtrl,
            builder: (context, child) => Positioned(
              top: (imgHeight / 2 - circleSize / 2) + (floatCtrl.value * 12),
              left: circleLeft.clamp(0.0, availableWidth),
              child: child!,
            ),
            child: _CrossedCircle(circleSize: circleSize),
          ),
          Positioned(
            left: imgLeft,
            top: 0,
            bottom: 0,
            child: _PersonImage(height: imgHeight, width: imgWidth),
          ),
          AnimatedBuilder(
            animation: floatCtrl,
            builder: (context, child) => Positioned(
              left: (imgLeft + imgWidth - 12).clamp(0.0, availableWidth - 30),
              top: (imgHeight * 0.28) - (floatCtrl.value * 10),
              child: child!,
            ),
            child: const _WormLines(),
          ),
        ],
      ),
    );
  }
}

// ─── Mobile visual ────────────────────────────────────────────────────────────

class _MobileVisual extends StatelessWidget {
  final AnimationController floatCtrl;
  const _MobileVisual({required this.floatCtrl});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    const hMargin = 20.0;
    final imgWidth = screenW - hMargin * 2;
    final imgHeight = imgWidth * 1.28;
    const circleSize = 110.0;
    final circleLeft = hMargin - circleSize * 0.40;

    return SizedBox(
      width: double.infinity,
      height: imgHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedBuilder(
            animation: floatCtrl,
            builder: (context, child) => Positioned(
              top: (imgHeight / 2 - circleSize / 2) + (floatCtrl.value * 10),
              left: circleLeft,
              child: child!,
            ),
            child: _CrossedCircle(circleSize: circleSize),
          ),
          Positioned(
            bottom: 0,
            left: hMargin,
            child: _PersonImage(height: imgHeight, width: imgWidth),
          ),
          AnimatedBuilder(
            animation: floatCtrl,
            builder: (context, child) => Positioned(
              right: hMargin - 10,
              top: (imgHeight * 0.22) - (floatCtrl.value * 8),
              child: child!,
            ),
            child: const _WormLines(),
          ),
        ],
      ),
    );
  }
}

class _CrossedCircle extends StatelessWidget {
  final double circleSize;
  const _CrossedCircle({required this.circleSize, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: circleSize,
      height: circleSize,
      child: Stack(
        children: [
          Container(
            width: circleSize,
            height: circleSize,
            decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
          ),
          CustomPaint(
            size: Size(circleSize, circleSize),
            painter: _SlantedLinePainter(circleSize: circleSize),
          ),
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
    const topLeft = Offset(0, 0);
    final bottomRight = Offset(size.width, size.height);
    canvas.drawLine(topLeft, bottomRight, Paint()..color = Colors.black..strokeWidth = 2.5..strokeCap = StrokeCap.round);

    final circlePath = Path()..addOval(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.save();
    canvas.clipPath(circlePath);
    canvas.drawLine(topLeft, bottomRight, Paint()..color = Colors.white..strokeWidth = 2.5..strokeCap = StrokeCap.round);
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
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
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

class _WormLines extends StatelessWidget {
  const _WormLines();
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 20, height: 80, child: CustomPaint(painter: _WormPainter()));
  }
}

class _WormPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final path1 = Path()..moveTo(w * 0.20, 0)..cubicTo(w * 1.0, h * 0.15, w * -0.2, h * 0.65, w * 0.20, h);
    canvas.drawPath(path1, Paint()..color = Colors.black..strokeWidth = 6..style = PaintingStyle.stroke..strokeCap = StrokeCap.round);

    final path2 = Path()..moveTo(w * 0.72, 0)..cubicTo(w * 1.5, h * 0.18, w * 0.30, h * 0.68, w * 0.72, h);
    canvas.drawPath(path2, Paint()..color = Colors.black..strokeWidth = 8..style = PaintingStyle.stroke..strokeCap = StrokeCap.round);
    canvas.drawPath(path2, Paint()..color = Colors.white..strokeWidth = 5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round);
  }
  @override
  bool shouldRepaint(_WormPainter _) => false;
}

class _StarShape extends StatelessWidget {
  final double size;
  const _StarShape({required this.size});
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: size, height: size, child: CustomPaint(painter: _StarPainter()));
  }
}

class _StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black..style = PaintingStyle.fill;
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;
    const points = 4;
    final path = Path();
    for (int i = 0; i < points * 2; i++) {
      final angle = (i * pi / points) - pi / 2;
      final radius = i.isEven ? r : r * 0.35;
      final pt = Offset(center.dx + radius * cos(angle), center.dy + radius * sin(angle));
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
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 22 : 28, vertical: isMobile ? 12 : 15),
          decoration: BoxDecoration(
            color: _hovered ? const Color(0xFF333333) : Colors.black,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            widget.label,
            style: GoogleFonts.dmSans(fontSize: isMobile ? 13 : 14, fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 0.2),
          ),
        ),
      ),
    );
  }
}

class _DownloadCvButton extends StatefulWidget {
  const _DownloadCvButton();
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
        final isDownloading = dl.state == DownloadState.downloading;
        final isDone = dl.state == DownloadState.done;
        final isError = dl.state == DownloadState.error;
        final label = isDone ? 'Downloaded!' : isError ? 'Try again' : isDownloading ? '${dl.percent}%' : 'Download CV';

        Widget icon;
        if (isDone) icon = Icon(Icons.check_circle_rounded, key: const ValueKey('check'), size: fontSize + 2, color: Colors.black);
        else if (isDownloading) icon = SizedBox(key: const ValueKey('spin'), width: fontSize + 2, height: fontSize + 2, child: CircularProgressIndicator(value: dl.progress, strokeWidth: 1.8, color: Colors.black, backgroundColor: Colors.black12));
        else if (isError) icon = Icon(Icons.error_outline_rounded, key: const ValueKey('err'), size: fontSize + 2, color: Colors.black54);
        else icon = Icon(Icons.download_rounded, key: const ValueKey('dl'), size: fontSize + 2, color: _hovered ? Colors.black : Colors.black87);

        return MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          cursor: isDownloading ? SystemMouseCursors.basic : SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => isDone ? (dl.reset(), Future.delayed(const Duration(milliseconds: 100), () => dl.downloadCv())) : dl.downloadCv(),
            child: SizedBox(
              width: 140,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedSwitcher(duration: const Duration(milliseconds: 200), child: Text(label, key: ValueKey(label), style: GoogleFonts.dmSans(fontSize: fontSize, fontWeight: FontWeight.w500, color: _hovered || isDownloading ? Colors.black : Colors.black87))),
                      const SizedBox(width: 6),
                      AnimatedSwitcher(duration: const Duration(milliseconds: 200), child: icon),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Stack(
                    children: [
                      Container(height: 1.5, width: 140, color: _hovered ? Colors.black : Colors.black26),
                      AnimatedContainer(duration: const Duration(milliseconds: 40), height: 1.5, width: 140 * dl.progress, color: Colors.black),
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