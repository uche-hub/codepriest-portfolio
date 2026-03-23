import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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

// ─── Desktop Layout ─────────────────────────────────────────────────────────
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
          const Expanded(flex: 56, child: _HeroVisualContent()),
        ],
      ),
    );
  }
}

// ─── Tablet & Mobile Layouts ────────────────────────────────────────────────
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

// ─── Text Content - Fully Animated ──────────────────────────────────────────
class _HeroTextContent extends StatelessWidget {
  const _HeroTextContent();

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final titleSize = ResponsiveHelper.getHeroTitleFontSize(context);
    final bodySize = ResponsiveHelper.getBodyFontSize(context);

    final List<String> features = [
      "State Management (BLoC, Provider): Build scalable, maintainable apps",
      "Backend Integration (Firebase, Supabase): Create secure, real-time systems",
      "Performance Optimization: Deliver fast, smooth user experiences",
      "CI/CD (GitHub Actions): Automate testing and deployments",
      "Native Integration (Platform Channels): Add advanced device features",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Waving Hand - FIXED FOR SMOOTHNESS
        Text('✋', style: TextStyle(fontSize: isMobile ? 32 : 42))
            .animate()
            .fadeIn(delay: 300.ms, duration: 700.ms)
            .slideY(begin: 0.4, end: 0, curve: Curves.easeOutBack)
            .scaleXY(begin: 0.85, end: 1.0, curve: Curves.easeOutCubic)
            .then(delay: 200.ms) // Slight pause after entrance
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .rotate(
          begin: -0.15,
          end: 0.15,
          duration: 1000.ms,
          curve: Curves.easeInOutSine,
          alignment: Alignment.bottomCenter, // Pivots from the wrist
        ),

        const SizedBox(height: 12),

        // 2. Main Title
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Hello! ',
                  style: GoogleFonts.dmSans(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: "I'm ${AppConstants.name}",
                  style: GoogleFonts.dmSans(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        )
            .animate()
            .fadeIn(delay: 550.ms, duration: 900.ms)
            .slideY(begin: 0.35, end: 0)
            .blurXY(begin: 4, end: 0, curve: Curves.easeOut),

        const SizedBox(height: 16),

        // 3. Role + Star
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
              ),
            ),
            const SizedBox(width: 10),
            const _StarShape(size: 14),
          ],
        )
            .animate()
            .fadeIn(delay: 900.ms, duration: 800.ms)
            .slideX(begin: -0.25, end: 0, curve: Curves.easeOutQuad),

        const SizedBox(height: 24),

        // 4. Bio
        _AnimatedShimmerBio(bodySize: bodySize),

        SizedBox(height: isMobile ? 24 : 32),

        // 5. Features - Staggered Animation
        // ...features.asMap().entries.map((e) {
        //   final idx = e.key;
        //   return Padding(
        //     padding: const EdgeInsets.only(bottom: 12),
        //     child: Row(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         const Icon(Icons.check, size: 18, color: Colors.black),
        //         const SizedBox(width: 12),
        //         Expanded(
        //           child: Text(
        //             e.value,
        //             style: GoogleFonts.dmSans(
        //               fontSize: bodySize,
        //               fontWeight: FontWeight.w400,
        //               color: Colors.black87,
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   )
        //       .animate()
        //       .fadeIn(delay: (1300 + idx * 220).ms, duration: 750.ms)
        //       .slideX(begin: -0.3, end: 0, curve: Curves.easeOutCubic);
        // }),

        SizedBox(height: isMobile ? 32 : 40),

        // 6. Buttons
        Wrap(
          spacing: 20,
          runSpacing: 16,
          alignment: WrapAlignment.start,
          children: [
            _BlackButton(
              label: "Let's Talk",
              onTap: () =>
                  context.read<ScrollProvider>().scrollToSection('contact'),
            ),
            const _DownloadCvButton(),
          ],
        )
            .animate()
            .fadeIn(delay: 2400.ms, duration: 900.ms)
            .scaleXY(begin: 0.88, end: 1.0, curve: Curves.easeOutBack),
      ],
    );
  }
}

// Bio Shimmer
class _AnimatedShimmerBio extends StatelessWidget {
  final double bodySize;

  final bool isMobile;
  const _AnimatedShimmerBio({required this.bodySize, this.isMobile = false});



  @override
  Widget build(BuildContext context) {
    final fs = isMobile ? 28.0 : 40.0;
    return Animate(
      onPlay: (controller) => controller.repeat(reverse: true),
      effects: [
        ShimmerEffect(
          duration: 3000.ms,
          color: const Color(0xFFFF80AB).withOpacity(0.25),
          blendMode: BlendMode.srcATop,
          delay: 1200.ms,
        ),
        FadeEffect(
          begin: 0.92,
          end: 1.0,
          curve: Curves.easeInOut,
          duration: 2800.ms,
        ),
      ],
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.dmSans(
            fontSize: fs,
            color: const Color(0xFF0F0F0F),
            height: 1.2,
          ),
          children: const [
            TextSpan(text: 'I build mobile apps that\n'),
            TextSpan(
              text: 'ship fast,',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Color(0xFF1A4FD6),
              ),
            ),
            TextSpan(text: ' scale cleanly,\nand feel native.'),
          ],
        ),
      )
    );
  }
}

// ─── Visual Content with Nice Entrance ──────────────────────────────────────
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        if (w < 600) return _MobileVisual(floatCtrl: _floatCtrl);
        if (w < 1100) {
          return _TabletVisual(
            availableWidth: w,
            imgHeight: (w * 1.05).clamp(0.0, screenH * 0.70),
            floatCtrl: _floatCtrl,
          );
        }
        return _DesktopVisual(imgHeight: screenH * 0.92, floatCtrl: _floatCtrl);
      },
    );
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
          Positioned(
            left: imgLeft,
            top: 0,
            bottom: 0,
            child: _PersonImage(height: imgHeight, width: imgWidth)
                .animate()
                .fadeIn(delay: 500.ms, duration: 1100.ms)
                .slideX(begin: 0.3, end: 0, curve: Curves.easeOutCubic),
          ),
          AnimatedBuilder(
            animation: floatCtrl,
            builder: (context, child) => Positioned(
              top: (imgHeight / 2 - circleSize / 2) + (floatCtrl.value * 15),
              left: circleLeft,
              child: child!,
            ),
            child: _CrossedCircle(circleSize: circleSize)
                .animate()
                .fadeIn(delay: 900.ms, duration: 1000.ms)
                .scaleXY(begin: 0.75, end: 1.0, curve: Curves.easeOutBack),
          ),
        ],
      ),
    );
  }
}

class _TabletVisual extends StatelessWidget {
  final double availableWidth, imgHeight;
  final AnimationController floatCtrl;
  const _TabletVisual({
    required this.availableWidth,
    required this.imgHeight,
    required this.floatCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final circleSize = (availableWidth * 0.14).clamp(90.0, 140.0);
    final imgWidth = (availableWidth * 0.62).clamp(300.0, 680.0);
    final imgLeft = (availableWidth - imgWidth) / 2;
    final circleLeft = imgLeft - circleSize * 0.35;

    return SizedBox(
      width: availableWidth,
      height: imgHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: imgLeft,
            top: 0,
            bottom: 0,
            child: _PersonImage(height: imgHeight, width: imgWidth)
                .animate()
                .fadeIn(delay: 500.ms, duration: 1100.ms)
                .slideY(begin: 0.2, end: 0),
          ),
          AnimatedBuilder(
            animation: floatCtrl,
            builder: (context, child) => Positioned(
              top: (imgHeight / 2 - circleSize / 2) + (floatCtrl.value * 12),
              left: circleLeft.clamp(0.0, availableWidth),
              child: child!,
            ),
            child: _CrossedCircle(
              circleSize: circleSize,
            ).animate().fadeIn(delay: 800.ms).scaleXY(begin: 0.8, end: 1.0),
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
      width: double.infinity,
      height: imgHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            left: 20.0,
            child: _PersonImage(height: imgHeight, width: imgWidth)
                .animate()
                .fadeIn(delay: 400.ms, duration: 1000.ms)
                .slideY(begin: 0.25, end: 0),
          ),
          AnimatedBuilder(
            animation: floatCtrl,
            builder: (context, child) => Positioned(
              top: (imgHeight / 2 - circleSize / 2) + (floatCtrl.value * 10),
              left: circleLeft,
              child: child!,
            ),
            child: _CrossedCircle(
              circleSize: circleSize,
            ).animate().fadeIn(delay: 700.ms).scaleXY(begin: 0.85, end: 1.0),
          ),
        ],
      ),
    );
  }
}

// ─── Shared Components ──────────────────────────────────────────────────────
class _CrossedCircle extends StatefulWidget {
  final double circleSize;
  const _CrossedCircle({required this.circleSize, super.key});
  @override
  State<_CrossedCircle> createState() => _CrossedCircleState();
}

class _CrossedCircleState extends State<_CrossedCircle> {
  int _langIndex = 0;
  final List<String> _hellos = [
    "Hello",
    "Bonjour",
    "Hola",
    "Hallo",
    "你好",
    "こんにちは",
  ];

  @override
  void initState() {
    super.initState();
    _startLanguageLoop();
  }

  void _startLanguageLoop() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted)
        setState(() => _langIndex = (_langIndex + 1) % _hellos.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.circleSize,
      height: widget.circleSize,
      child: Stack(
        children: [
          Container(
            width: widget.circleSize,
            height: widget.circleSize,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.2),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
              child: Text(
                _hellos[_langIndex],
                key: ValueKey(_hellos[_langIndex]),
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontSize: widget.circleSize * 0.18,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
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
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(8),
      topRight: Radius.circular(8),
    ),
    child: Image.asset(
      'assets/images/profile3.png',
      width: width,
      height: height,
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
    ),
  );
}

class _StarShape extends StatelessWidget {
  final double size;
  const _StarShape({required this.size});
  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: CustomPaint(painter: _StarPainter()),
  );
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
    final path = Path();
    for (int i = 0; i < points * 2; i++) {
      final angle = (i * pi / points) - pi / 2;
      final radius = i.isEven ? r : r * 0.35;
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
  bool shouldRepaint(_) => false;
}

class _BlackButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _BlackButton({required this.label, required this.onTap});
  @override
  State<_BlackButton> createState() => _BlackButtonState();
}

class _BlackButtonState extends State<_BlackButton> {
  bool _h = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _h = true),
    onExit: (_) => setState(() => _h = false),
    child: GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
        decoration: BoxDecoration(
          color: _h ? const Color(0xFF333333) : Colors.black,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          widget.label,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.2,
          ),
        ),
      ),
    ),
  );
}

class _DownloadCvButton extends StatefulWidget {
  const _DownloadCvButton();
  @override
  State<_DownloadCvButton> createState() => _DownloadCvButtonState();
}

class _DownloadCvButtonState extends State<_DownloadCvButton> {
  bool _h = false;
  @override
  Widget build(BuildContext context) => Consumer<DownloadProvider>(
    builder: (context, dl, _) {
      final s = dl.state;
      final isDl = s == DownloadState.downloading;
      return MouseRegion(
        onEnter: (_) => setState(() => _h = true),
        onExit: (_) => setState(() => _h = false),
        child: GestureDetector(
          onTap: dl.downloadCv,
          child: SizedBox(
            width: 140,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      s == DownloadState.done
                          ? 'Downloaded!'
                          : isDl
                          ? '${dl.percent}%'
                          : 'Download CV',
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _h || isDl ? Colors.black : Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (isDl)
                      const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: Colors.black,
                        ),
                      )
                    else
                      Icon(
                        Icons.download,
                        size: 16,
                        color: _h ? Colors.black : Colors.black87,
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Stack(
                  children: [
                    Container(height: 1.5, width: 140, color: Colors.black12),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 50),
                      height: 1.5,
                      width: 140 * dl.progress,
                      color: Colors.black,
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