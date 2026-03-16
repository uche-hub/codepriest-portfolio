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
  late AnimationController _karaokeCtrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 8));
    _waveCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _karaokeCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 5))..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _ctrl.forward();
        _waveCtrl.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _waveCtrl.dispose();
    _karaokeCtrl.dispose();
    super.dispose();
  }

  Widget _staggeredFade(Widget child, double start, double end) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _ctrl, curve: Interval(start, end, curve: Curves.easeOut)),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(CurvedAnimation(parent: _ctrl, curve: Interval(start, end, curve: Curves.easeOutCubic))),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final titleSize = ResponsiveHelper.getHeroTitleFontSize(context);
    final bodySize = ResponsiveHelper.getBodyFontSize(context);

    final List<String> flutterDeveloperItems = [
      "Expertise in BLoC, Provider, and Clean Architecture",
      "Scalable Firebase & Supabase Backend Integration",
      "Optimized performance with Widget Tree refactoring",
      "Automated CI/CD workflows with GitHub Actions",
      "Native bridge implementation and Platform Channels",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _staggeredFade(
          RotationTransition(
            turns: Tween(begin: -0.05, end: 0.05).animate(_waveCtrl),
            child: Text('✋', style: TextStyle(fontSize: isMobile ? 28 : 36)),
          ),
          0.0, 0.1,
        ),
        const SizedBox(height: 12),
        _staggeredFade(
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: 'Hello! ', style: GoogleFonts.dmSans(fontSize: titleSize, fontWeight: FontWeight.w300, color: Colors.black)),
                  TextSpan(text: "I'm ${AppConstants.name}", style: GoogleFonts.dmSans(fontSize: titleSize, fontWeight: FontWeight.w800, color: Colors.black)),
                ],
              ),
            ),
          ),
          0.05, 0.15,
        ),
        const SizedBox(height: 16),
        _staggeredFade(
          Row(
            children: [
              Container(height: 1.5, width: isMobile ? 40 : 60, color: Colors.black),
              const SizedBox(width: 12),
              Text(AppConstants.role, style: GoogleFonts.dmSans(fontSize: isMobile ? 14 : 16, fontWeight: FontWeight.w400, color: Colors.black87)),
              const SizedBox(width: 10),
              const _StarShape(size: 14),
            ],
          ),
          0.1, 0.2,
        ),
        const SizedBox(height: 20),
        _staggeredFade(
          AnimatedBuilder(
            animation: _karaokeCtrl,
            builder: (context, child) {
              return ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) {
                  return LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: const [Colors.black, Color(0xFFE1BEE7), Color(0xFFFF80AB), Colors.black],
                    stops: [_karaokeCtrl.value - 0.1, _karaokeCtrl.value, _karaokeCtrl.value + 0.1, _karaokeCtrl.value + 0.2],
                    tileMode: TileMode.clamp,
                  ).createShader(bounds);
                },
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.dmSans(fontSize: bodySize, color: Colors.black, height: 1.65),
                    children: [
                      TextSpan(text: 'Hello! I\'m ${AppConstants.name}. I\'m a ', style: const TextStyle(fontWeight: FontWeight.w400)),
                      const TextSpan(text: 'Developer Programmer | Flutter Developer', style: TextStyle(fontWeight: FontWeight.w700)),
                      const TextSpan(text: ', with 5 years of experience in Software Development and 3 years of professional experience in Mobile Development Flutter.', style: TextStyle(fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
              );
            },
          ),
          0.15, 0.3,
        ),
        SizedBox(height: isMobile ? 20 : 28),
        _TypewriterItem(text: flutterDeveloperItems[0], controller: _ctrl, start: 0.3, end: 0.45, bodySize: bodySize),
        _TypewriterItem(text: flutterDeveloperItems[1], controller: _ctrl, start: 0.45, end: 0.6, bodySize: bodySize),
        _TypewriterItem(text: flutterDeveloperItems[2], controller: _ctrl, start: 0.6, end: 0.75, bodySize: bodySize),
        _TypewriterItem(text: flutterDeveloperItems[3], controller: _ctrl, start: 0.75, end: 0.9, bodySize: bodySize),
        _TypewriterItem(text: flutterDeveloperItems[4], controller: _ctrl, start: 0.9, end: 1.0, bodySize: bodySize),
        SizedBox(height: isMobile ? 28 : 36),
        _staggeredFade(
          Wrap(
            spacing: 24,
            runSpacing: 14,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _BlackButton(label: "Let's Talk", onTap: () => context.read<ScrollProvider>().scrollToSection('contact')),
              const _DownloadCvButton(),
            ],
          ),
          0.8, 1.0,
        ),
      ],
    );
  }
}

class _TypewriterItem extends StatelessWidget {
  final String text;
  final AnimationController controller;
  final double start, end, bodySize;
  const _TypewriterItem({required this.text, required this.controller, required this.start, required this.end, required this.bodySize});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final t = (controller.value - start) / (end - start);
        final currentLength = (text.length * t.clamp(0.0, 1.0)).toInt();
        final opacity = (t * 10.0).clamp(0.0, 1.0);
        return Opacity(
          opacity: opacity,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check, size: 17, color: Colors.black),
                const SizedBox(width: 10),
                Expanded(child: Text(text.substring(0, currentLength), style: GoogleFonts.dmSans(fontSize: bodySize, fontWeight: FontWeight.w400, color: Colors.black87))),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Visual Content ───────────────────────────────────────────────────────────

class _HeroVisualContent extends StatefulWidget {
  const _HeroVisualContent();
  @override
  State<_HeroVisualContent> createState() => _HeroVisualContentState();
}

class _HeroVisualContentState extends State<_HeroVisualContent> with SingleTickerProviderStateMixin {
  late AnimationController _floatCtrl;
  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
  }
  @override
  void dispose() { _floatCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      if (w < 600) return _MobileVisual(floatCtrl: _floatCtrl);
      if (w < 1100) return _TabletVisual(availableWidth: w, imgHeight: (w * 1.05).clamp(0.0, screenH * 0.70), floatCtrl: _floatCtrl);
      return _DesktopVisual(imgHeight: screenH * 0.92, floatCtrl: _floatCtrl);
    });
  }
}

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
          Positioned(left: imgLeft, top: 0, bottom: 0, child: _PersonImage(height: imgHeight, width: imgWidth)),
          AnimatedBuilder(
            animation: floatCtrl,
            builder: (context, child) => Positioned(
              top: (imgHeight / 2 - circleSize / 2) + (floatCtrl.value * 15),
              left: circleLeft,
              child: child!,
            ),
            child: _CrossedCircle(circleSize: circleSize),
          ),
        ],
      ),
    );
  }
}

class _TabletVisual extends StatelessWidget {
  final double availableWidth, imgHeight;
  final AnimationController floatCtrl;
  const _TabletVisual({required this.availableWidth, required this.imgHeight, required this.floatCtrl});

  @override
  Widget build(BuildContext context) {
    final circleSize = (availableWidth * 0.14).clamp(90.0, 140.0);
    final imgWidth = (availableWidth * 0.62).clamp(300.0, 680.0);
    final imgLeft = (availableWidth - imgWidth) / 2;
    final circleLeft = imgLeft - circleSize * 0.35;

    return SizedBox(
      width: availableWidth, height: imgHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(left: imgLeft, top: 0, bottom: 0, child: _PersonImage(height: imgHeight, width: imgWidth)),
          AnimatedBuilder(
            animation: floatCtrl,
            builder: (context, child) => Positioned(
              top: (imgHeight / 2 - circleSize / 2) + (floatCtrl.value * 12),
              left: circleLeft.clamp(0.0, availableWidth),
              child: child!,
            ),
            child: _CrossedCircle(circleSize: circleSize),
          ),
        ],
      ),
    );
  }
}

class _MobileVisual extends StatelessWidget {
  final AnimationController floatCtrl;
  const _MobileVisual({required this.floatCtrl});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final imgWidth = screenW - 40.0;
    final imgHeight = imgWidth * 1.28;
    const circleSize = 110.0;
    final circleLeft = 20.0 + (imgWidth / 2) - (circleSize / 2);

    return SizedBox(
      width: double.infinity, height: imgHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(bottom: 0, left: 20.0, child: _PersonImage(height: imgHeight, width: imgWidth)),
          AnimatedBuilder(
            animation: floatCtrl,
            builder: (context, child) => Positioned(
              top: (imgHeight / 2 - circleSize / 2) + (floatCtrl.value * 10),
              left: circleLeft,
              child: child!,
            ),
            child: _CrossedCircle(circleSize: circleSize),
          ),
        ],
      ),
    );
  }
}

class _CrossedCircle extends StatefulWidget {
  final double circleSize;
  const _CrossedCircle({required this.circleSize, super.key});
  @override State<_CrossedCircle> createState() => _CrossedCircleState();
}

class _CrossedCircleState extends State<_CrossedCircle> {
  int _langIndex = 0;
  final List<String> _hellos = ["Hello", "Bonjour", "Hola", "Hallo", "你好", "こんにちは"];

  @override
  void initState() {
    super.initState();
    _startLanguageLoop();
  }

  void _startLanguageLoop() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) setState(() => _langIndex = (_langIndex + 1) % _hellos.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.circleSize, height: widget.circleSize,
      child: Stack(
        children: [
          Container(width: widget.circleSize, height: widget.circleSize, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle)),
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: SlideTransition(position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(animation), child: child)),
              child: Text(_hellos[_langIndex], key: ValueKey(_hellos[_langIndex]), textAlign: TextAlign.center, style: GoogleFonts.dmSans(fontSize: widget.circleSize * 0.18, fontWeight: FontWeight.w400, color: Colors.white, letterSpacing: 0.5)),
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonImage extends StatelessWidget {
  final double height, width;
  const _PersonImage({required this.height, required this.width});
  @override Widget build(BuildContext context) => ClipRRect(borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)), child: Image.asset('assets/images/profile.png', width: width, height: height, fit: BoxFit.cover, alignment: Alignment.topCenter));
}

class _StarShape extends StatelessWidget {
  final double size;
  const _StarShape({required this.size});
  @override Widget build(BuildContext context) => SizedBox(width: size, height: size, child: CustomPaint(painter: _StarPainter()));
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
  @override bool shouldRepaint(_) => false;
}

class _BlackButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _BlackButton({required this.label, required this.onTap});
  @override State<_BlackButton> createState() => _BlackButtonState();
}

class _BlackButtonState extends State<_BlackButton> {
  bool _h = false;
  @override Widget build(BuildContext context) => MouseRegion(onEnter: (_) => setState(() => _h = true), onExit: (_) => setState(() => _h = false), child: GestureDetector(onTap: widget.onTap, child: AnimatedContainer(duration: const Duration(milliseconds: 200), padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15), decoration: BoxDecoration(color: _h ? const Color(0xFF333333) : Colors.black, borderRadius: BorderRadius.circular(50)), child: Text(widget.label, style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 0.2)))));
}

class _DownloadCvButton extends StatefulWidget {
  const _DownloadCvButton();
  @override State<_DownloadCvButton> createState() => _DownloadCvButtonState();
}

class _DownloadCvButtonState extends State<_DownloadCvButton> {
  bool _h = false;
  @override Widget build(BuildContext context) => Consumer<DownloadProvider>(builder: (context, dl, _) {
    final s = dl.state; final isDl = s == DownloadState.downloading;
    return MouseRegion(onEnter: (_) => setState(() => _h = true), onExit: (_) => setState(() => _h = false), child: GestureDetector(onTap: dl.downloadCv, child: SizedBox(width: 140, child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [Row(mainAxisSize: MainAxisSize.min, children: [Text(s == DownloadState.done ? 'Downloaded!' : isDl ? '${dl.percent}%' : 'Download CV', style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w500, color: _h || isDl ? Colors.black : Colors.black87)), const SizedBox(width: 6), if (isDl) const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 1.5, color: Colors.black)) else Icon(Icons.download, size: 16, color: _h ? Colors.black : Colors.black87)]), const SizedBox(height: 4), Stack(children: [Container(height: 1.5, width: 140, color: Colors.black12), AnimatedContainer(duration: const Duration(milliseconds: 50), height: 1.5, width: 140 * dl.progress, color: Colors.black)])]))));
  });
}