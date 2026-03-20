// lib/features/home/widgets/case_study_section_widget.dart

import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../core/constants/responsive_helper.dart';

// ─── Data ─────────────────────────────────────────────────────────────────────

class _CaseStudy {
  final String tag;
  final String title;
  final String subtitle;
  final String imagePath;
  final Color imageColor;
  final String description;
  final List<String> scope;
  final String year;
  final String client;
  final String url;

  const _CaseStudy({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.imageColor,
    required this.description,
    required this.scope,
    required this.year,
    required this.client,
    required this.url,
  });
}

const _mainStudies = [
  _CaseStudy(
    tag: 'Mobile App',
    title: 'Novelle',
    subtitle: 'Read Better',
    imagePath: 'assets/images/1.jpg',
    imageColor: Color(0xFFE8E8E8),
    description:
        'Novelle is a beautifully designed, intuitive app that helps you read better and get the most out of every page. Whether you are a casual reader seeking your next great escape or a dedicated bibliophile ready to delve into a new genre, Novelle transforms your reading journey. Our mission is to make reading a more engaging and interactive experience than ever before.',
    scope: ['Google Book API', 'Zen API', 'Flutter', 'Firebase'],
    year: '2025',
    client: 'Apptalic Lab',
    url:
        'https://play.google.com/store/apps/details?id=com.apptalic.novella&pcampaignid=web_share',
  ),
  _CaseStudy(
    tag: 'Mobile App',
    title: 'Internda',
    subtitle: 'Fast Internships',
    imagePath: 'assets/images/2.jpg',
    imageColor: Color(0xFFF0EDE8),
    description:
        'Break the "No Experience" Cycle with Internda! Internda helps you find companies that want fresh talent—no "prior experience" needed. Skip the job board stress. Land your dream internship.',
    scope: ['Flutter', 'LinkedIn API', 'Firebase', 'Google GEOLocation'],
    year: '2025',
    client: 'Apptalic Lab',
    url:
        'https://play.google.com/store/apps/details?id=com.apptalic.internda.app&pcampaignid=web_share',
  ),
];

const _extraStudies = [
  _CaseStudy(
    tag: 'Mobile App',
    title: 'MAAL Tracker',
    subtitle: 'Walk, Share, and Get Rewarded!',
    imagePath: 'assets/images/3.jpg',
    imageColor: Color(0xFFDEEBFF),
    description:
        'MAAL Tracker - Walk, Share, and Get Rewarded! Ready to turn your everyday steps into exciting rewards and boost your earnings by sharing your valuable opinions? Welcome to MAAL Tracker, the innovative app that motivates you to stay active and engaged while putting valuable in-app coins right in your pocket!',
    scope: [
      'Flutter',
      'Firebase',
      'Firestore',
      'GEOLocation',
      'Google Maps API',
      'Health Connect',
    ],
    year: '2025',
    client: 'Marketing Analytics Africa',
    url:
        'https://play.google.com/store/apps/details?id=com.maa.maal_tracker&pcampaignid=web_share',
  ),
  _CaseStudy(
    tag: 'Mobile App',
    title: 'Shelf',
    subtitle: 'The Fastest Way to Access Your Important Files, Notes & Docs ',
    imagePath: 'assets/images/4.jpg',
    imageColor: Color(0xFFF5E6D3),
    description:
        'Finding important files shouldn\'t feel like a chore. Shelf is a minimalist, high-speed file access tool designed to help you retrieve your most important files, notes, images, and documents in the least number of steps. Unlike traditional file managers, Shelf doesn\'t focus on managing storage—it focuses on instant access to what matters most.',
    scope: ['Flutter', 'just_audio', 'bLoc'],
    year: '2026',
    client: 'Credes Technologies',
    url:
        'https://play.google.com/store/apps/details?id=org.credes.shelf&pcampaignid=web_share',
  ),
  _CaseStudy(
    tag: 'pub.dev package',
    title: 'Button Loading FX',
    subtitle:
        'A Flutter package that provides beautiful, customizable loading animations for buttons.',
    imagePath: 'images/button-fx.gif',
    imageColor: Color(0xFFF5E6D3),
    description:
        'A Flutter package that provides beautiful, customizable loading animations for buttons. Transform boring loading states into delightful user experiences with smooth animations and progress indicators!',
    scope: ['Flutter', 'pub.dev', 'MIT License'],
    year: '2026',
    client: 'Uchenna Nduwke',
    url: 'https://pub.dev/packages/button_loading_fx',
  ),
];

// ─── Main Widget ──────────────────────────────────────────────────────────────

class CaseStudySectionWidget extends StatefulWidget {
  const CaseStudySectionWidget({super.key});

  @override
  State<CaseStudySectionWidget> createState() => _CaseStudySectionState();
}

class _CaseStudySectionState extends State<CaseStudySectionWidget>
    with TickerProviderStateMixin {
  bool _showMore = false;
  bool _isVisible = false;
  late AnimationController _expandCtrl;
  late AnimationController _entranceCtrl;
  late Animation<double> _expandAnim;

  @override
  void initState() {
    super.initState();
    _expandCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _expandAnim = CurvedAnimation(
      parent: _expandCtrl,
      curve: Curves.easeInOutQuart,
    );
  }

  @override
  void dispose() {
    _expandCtrl.dispose();
    _entranceCtrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _showMore = !_showMore);
    _showMore ? _expandCtrl.forward() : _expandCtrl.reverse();
  }

  void _openModal(_CaseStudy cs) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'close',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (ctx, anim, _, __) => Material(
        type: MaterialType.transparency,
        child: FadeTransition(
          opacity: anim,
          child: _CaseStudyModal(study: cs, animation: anim),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hPad = ResponsiveHelper.getHorizontalPadding(context);
    final isMobile = ResponsiveHelper.isMobile(context);

    return VisibilityDetector(
      key: const Key('case-study-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_isVisible) {
          setState(() => _isVisible = true);
          _entranceCtrl.forward();
        }
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(hPad, 80, hPad, 80),
        child: Column(
          children: [
            _AnimatedEntrance(
              controller: _entranceCtrl,
              delay: 0.0,
              child: _CaseHeader(isMobile: isMobile),
            ),
            const SizedBox(height: 64),

            // Main studies
            ..._mainStudies.asMap().entries.map(
              (e) => _AnimatedEntrance(
                controller: _entranceCtrl,
                delay: 0.2 + (e.key * 0.15),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: _CaseStudyItem(
                    study: e.value,
                    imageLeft: e.key % 2 == 0,
                    isMobile: isMobile,
                    onTap: () => _openModal(e.value),
                  ),
                ),
              ),
            ),

            // Extra studies
            SizeTransition(
              sizeFactor: _expandAnim,
              axisAlignment: -1,
              child: Column(
                children: _extraStudies.asMap().entries.map((e) {
                  final idx = _mainStudies.length + e.key;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 60),
                    child: _CaseStudyItem(
                      study: e.value,
                      imageLeft: idx % 2 == 0,
                      isMobile: isMobile,
                      onTap: () => _openModal(e.value),
                    ),
                  );
                }).toList(),
              ),
            ),

            _AnimatedEntrance(
              controller: _entranceCtrl,
              delay: 0.5,
              child: _ViewMoreButton(expanded: _showMore, onTap: _toggle),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Entrance Helper ──────────────────────────────────────────────────────────

class _AnimatedEntrance extends StatelessWidget {
  final Widget child;
  final AnimationController controller;
  final double delay;

  const _AnimatedEntrance({
    required this.child,
    required this.controller,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final anim = CurvedAnimation(
      parent: controller,
      curve: Interval(
        delay,
        (delay + 0.4).clamp(0.0, 1.0),
        curve: Curves.easeOutCubic,
      ),
    );

    return FadeTransition(
      opacity: anim,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(anim),
        child: child,
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────

class _CaseHeader extends StatelessWidget {
  final bool isMobile;
  const _CaseHeader({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Positioned(left: isMobile ? -16 : 0, top: -8, child: const _DotGrid()),
        Column(
          children: [
            const _SunIcon(size: 34),
            const SizedBox(height: 14),
            Text(
              'My Projects',
              style: GoogleFonts.dmSans(
                fontSize: isMobile ? 36 : 56,
                fontWeight: FontWeight.w800,
                color: Colors.black,
                letterSpacing: -1.0,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: isMobile ? double.infinity : 420,
              child: Text(
                'A collection of production-grade mobile applications and open-source tools I have built to solve real-world problems.',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontSize: 13.5,
                  color: Colors.black54,
                  height: 1.7,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Dot Grid ─────────────────────────────────────────────────────────────────

class _DotGrid extends StatelessWidget {
  const _DotGrid();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(110, 110), painter: _DotGridPainter());
  }
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const cols = 7;
    const rows = 7;
    final cellW = size.width / cols;
    final cellH = size.height / rows;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final distFromCenter = sqrt(
          pow(c - cols / 2, 2) + pow(r - rows / 2, 2),
        );
        final maxDist = sqrt(pow(cols / 2, 2) + pow(rows / 2, 2));
        final opacity = (1.0 - distFromCenter / maxDist).clamp(0.08, 0.75);
        final radius = (2.4 - distFromCenter * 0.18).clamp(0.8, 2.4);

        canvas.drawCircle(
          Offset(c * cellW + cellW / 2, r * cellH + cellH / 2),
          radius,
          Paint()..color = Colors.black.withOpacity(opacity),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Sun Icon ─────────────────────────────────────────────────────────────────

class _SunIcon extends StatefulWidget {
  final double size;
  const _SunIcon({required this.size, super.key});

  @override
  State<_SunIcon> createState() => _SunIconState();
}

class _SunIconState extends State<_SunIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotateCtrl;

  @override
  void initState() {
    super.initState();
    _rotateCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _rotateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RotationTransition(
    turns: _rotateCtrl,
    child: CustomPaint(
      size: Size(widget.size, widget.size),
      painter: _SunPainter(),
    ),
  );
}

class _SunPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(
      center,
      size.width * 0.12,
      paint..style = PaintingStyle.fill,
    );
    paint.style = PaintingStyle.stroke;

    const rayCount = 16;
    for (int i = 0; i < rayCount; i++) {
      final angle = (i / rayCount) * 2 * pi;
      final inner = size.width * (i % 2 == 0 ? 0.22 : 0.28);
      final outer = size.width * (i % 2 == 0 ? 0.44 : 0.36);
      canvas.drawLine(
        Offset(center.dx + inner * cos(angle), center.dy + inner * sin(angle)),
        Offset(center.dx + outer * cos(angle), center.dy + outer * sin(angle)),
        paint..strokeWidth = i % 2 == 0 ? 1.4 : 0.8,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ─── Case Study Item ──────────────────────────────────────────────────────────

class _CaseStudyItem extends StatelessWidget {
  final _CaseStudy study;
  final bool imageLeft;
  final bool isMobile;
  final VoidCallback onTap;

  const _CaseStudyItem({
    required this.study,
    required this.imageLeft,
    required this.isMobile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isMobile) return _buildMobile(context);
    return _buildDesktop(context);
  }

  Widget _buildDesktop(BuildContext context) {
    final image = _CaseImage(study: study, onTap: onTap);
    final content = _CaseContent(study: study, onTap: onTap);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: imageLeft
          ? [
              Expanded(flex: 55, child: image),
              const SizedBox(width: 56),
              Expanded(flex: 45, child: content),
            ]
          : [
              Expanded(flex: 45, child: content),
              const SizedBox(width: 56),
              Expanded(flex: 55, child: image),
            ],
    );
  }

  Widget _buildMobile(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CaseImage(study: study, onTap: onTap),
        const SizedBox(height: 28),
        _CaseContent(study: study, onTap: onTap),
      ],
    );
  }
}

// ─── Case Image ───────────────────────────────────────────────────────────────

class _CaseImage extends StatefulWidget {
  final _CaseStudy study;
  final VoidCallback onTap;
  const _CaseImage({required this.study, required this.onTap});

  @override
  State<_CaseImage> createState() => _CaseImageState();
}

class _CaseImageState extends State<_CaseImage> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final h = isMobile ? 240.0 : 380.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          transform: Matrix4.identity()..translate(0.0, _hov ? -5.0 : 0.0),
          decoration: BoxDecoration(
            color: widget.study.imageColor,
            border: Border.all(
              color: _hov ? Colors.black : Colors.transparent,
              width: 1.5,
            ),
            boxShadow: _hov
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : [],
          ),
          child: ClipRect(
            child: AnimatedScale(
              scale: _hov ? 1.03 : 1.0,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOut,
              child: Image.asset(
                widget.study.imagePath,
                fit: BoxFit.contain, // ← was BoxFit.cover
                width: double.infinity,
                errorBuilder: (_, __, ___) => Container(
                  height: isMobile ? 240.0 : 380.0,
                  color: widget.study.imageColor,
                  child: Center(
                    child: Text(
                      widget.study.tag,
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black38,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Case Content ─────────────────────────────────────────────────────────────

class _CaseContent extends StatelessWidget {
  final _CaseStudy study;
  final VoidCallback onTap;
  const _CaseContent({required this.study, required this.onTap});

  // Truncate description to ~7 words then add ellipsis
  String _snippet(String desc) {
    final words = desc.trim().split(RegExp(r'\s+'));
    if (words.length <= 20) return desc;
    return '${words.take(20).join(' ')}…';
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final titleSize = isMobile ? 24.0 : 32.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            study.tag,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          study.title,
          style: GoogleFonts.dmSans(
            fontSize: titleSize,
            fontWeight: FontWeight.w800,
            color: Colors.black,
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 16),
        // ── Short description snippet ─────────────────────────────────────
        Text(
          _snippet(study.description),
          style: GoogleFonts.dmSans(
            fontSize: isMobile ? 13 : 14,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 36),
        // ── Client · Year ─────────────────────────────────────────────────
        Row(
          children: [
            Text(
              study.client,
              style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            Container(
              width: 3,
              height: 3,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: const BoxDecoration(
                color: Colors.black38,
                shape: BoxShape.circle,
              ),
            ),
            Text(
              study.year,
              style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black38,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // ── Scope chips ───────────────────────────────────────────────────
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: study.scope.map((s) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26, width: 1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              s,
              style: GoogleFonts.dmSans(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          )).toList(),
        ),
        const SizedBox(height: 18),
        _SeeDetailsButton(onTap: onTap),
      ],
    );
  }
}

// ─── See Details Button ───────────────────────────────────────────────────────

class _SeeDetailsButton extends StatefulWidget {
  final VoidCallback onTap;
  const _SeeDetailsButton({required this.onTap});

  @override
  State<_SeeDetailsButton> createState() => _SeeDetailsButtonState();
}

class _SeeDetailsButtonState extends State<_SeeDetailsButton> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'See Details',
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedSlide(
                  offset: _hov ? const Offset(0.15, -0.15) : Offset.zero,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  child: const Icon(
                    Icons.arrow_outward_rounded,
                    size: 18,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              height: 1.5,
              width: _hov ? 140 : 110,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── View More Button ─────────────────────────────────────────────────────────

class _ViewMoreButton extends StatefulWidget {
  final bool expanded;
  final VoidCallback onTap;
  const _ViewMoreButton({required this.expanded, required this.onTap});

  @override
  State<_ViewMoreButton> createState() => _ViewMoreButtonState();
}

class _ViewMoreButtonState extends State<_ViewMoreButton> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: _hov ? Colors.black : Colors.transparent,
            border: Border.all(color: Colors.black, width: 1.2),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: Text(
                  widget.expanded ? 'Show Less' : 'View More',
                  key: ValueKey(widget.expanded),
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _hov ? Colors.white : Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              AnimatedRotation(
                turns: widget.expanded ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: _hov ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Modal ────────────────────────────────────────────────────────────────────

class _CaseStudyModal extends StatelessWidget {
  final _CaseStudy study;
  final Animation<double> animation;
  const _CaseStudyModal({required this.study, required this.animation});

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.of(context).size;
    final isMobile = sz.width < 600;

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  color: const Color(0xFF080808).withOpacity(0.74),
                ),
              ),
            ),
          ),
        ),
        Center(
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
            ),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: isMobile
                    ? sz.width * 0.92
                    : (sz.width * 0.52).clamp(420.0, 640.0),
                constraints: BoxConstraints(maxHeight: sz.height * 0.88),
                margin: const EdgeInsets.symmetric(vertical: 32),
                decoration: BoxDecoration(
                  color: const Color(0xFF0E0E0E).withOpacity(0.93),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.10),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.75),
                      blurRadius: 90,
                      spreadRadius: -6,
                      offset: const Offset(0, 36),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      Positioned(
                        top: -50,
                        right: -50,
                        child: CustomPaint(
                          size: const Size(200, 200),
                          painter: _CornerGlowPainter(),
                        ),
                      ),
                      _ModalContent(study: study, isMobile: isMobile),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CornerGlowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(
      center,
      size.width / 2,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.white.withOpacity(0.055),
            Colors.white.withOpacity(0.0),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: size.width / 2)),
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

class _ModalContent extends StatelessWidget {
  final _CaseStudy study;
  final bool isMobile;
  const _ModalContent({required this.study, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final pad = isMobile ? 24.0 : 40.0;

    return SingleChildScrollView(
      padding: EdgeInsets.all(pad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.14),
                    width: 1,
                  ),
                ),
                child: Text(
                  study.tag,
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withOpacity(0.85),
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.07),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.14),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: isMobile ? 180 : 240,
              width: double.infinity,
              color: study.imageColor.withOpacity(0.3),
              child: Image.asset(
                study.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            study.title,
            style: GoogleFonts.dmSans(
              fontSize: isMobile ? 20 : 26,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                study.client,
                style: GoogleFonts.dmSans(fontSize: 13, color: Colors.white60),
              ),
              const SizedBox(width: 14),
              Container(width: 1, height: 13, color: Colors.white24),
              const SizedBox(width: 14),
              Text(
                study.year,
                style: GoogleFonts.dmSans(fontSize: 12, color: Colors.white54),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.0),
                  Colors.white.withOpacity(0.18),
                  Colors.white.withOpacity(0.0),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            study.description,
            style: GoogleFonts.dmSans(
              fontSize: isMobile ? 13.5 : 14.5,
              color: Colors.white.withOpacity(0.82),
              height: 1.72,
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Container(
                width: 3,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'SCOPE OF WORK',
                style: GoogleFonts.dmSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withOpacity(0.42),
                  letterSpacing: 1.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: study.scope
                .map(
                  (s) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.14),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      s,
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 28),
          _ModalVisitBtn(url: study.url),
        ],
      ),
    );
  }
}

class _ModalVisitBtn extends StatefulWidget {
  final String url;
  const _ModalVisitBtn({required this.url});
  @override
  State<_ModalVisitBtn> createState() => _ModalVisitBtnState();
}

class _ModalVisitBtnState extends State<_ModalVisitBtn> {
  bool _hov = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _hov = true),
    onExit: (_) => setState(() => _hov = false),
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTap: () async {
        final uri = Uri.parse(widget.url);
        if (await canLaunchUrl(uri)) launchUrl(uri);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: _hov
              ? Colors.white.withOpacity(0.14)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _hov
                ? Colors.white.withOpacity(0.24)
                : Colors.white.withOpacity(0.10),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'VISIT PROJECT',
              style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white.withOpacity(_hov ? 0.95 : 0.55),
                letterSpacing: 1.8,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_outward_rounded,
              size: 14,
              color: Colors.white.withOpacity(_hov ? 0.95 : 0.55),
            ),
          ],
        ),
      ),
    ),
  );
}
