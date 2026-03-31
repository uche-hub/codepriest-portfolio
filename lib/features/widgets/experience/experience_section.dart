// lib/features/home/widgets/experience_section_widget.dart

import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../core/constants/responsive_helper.dart';

// ─── Data ─────────────────────────────────────────────────────────────────────

class _Experience {
  final int number;
  final String role;
  final String company;
  final String duration;
  final String description;
  final List<String> highlights;

  const _Experience({
    required this.number,
    required this.role,
    required this.company,
    required this.duration,
    required this.description,
    required this.highlights,
  });
}

const _mainExperiences = [
  _Experience(
    number: 1,
    role: 'Team Lead | Flutter Developer',
    company: 'Shop Online New York · USA (Remote)',
    duration: 'AUG 2025 – PRESENT',
    description:
    'Leading a multi-stack team (React + Flutter) to achieve feature parity across e-commerce platforms. I focus on optimizing development velocity and establishing high-scale architecture standards.',
    highlights: [
      'Boosted team delivery velocity by 75% via component libraries',
      'Optimized PR workflows and revamped Jira project management',
      'Mentored interns on BLoC & Provider state management',
      'Championed scalable architecture for Android and iOS',
    ],
  ),
  _Experience(
    number: 2,
    role: 'Team Lead | Flutter Developer',
    company: 'Nexoris Technologies · Nigeria',
    duration: 'APR 2025 – JAN 2026',
    description:
    'Architected real-time tracking systems and gamification engines. I standardized the codebase on MVVM + BLoC patterns to reduce technical debt and simplify feature scaling.',
    highlights: [
      'Built XP-to-airtime gamification engine for user retention',
      'Architected Firebase real-time client-progress tracking',
      'Integrated REST APIs with full Swagger documentation',
      'Managed beta testing via Firebase App Distribution',
    ],
  ),
  _Experience(
    number: 3,
    role: 'Flutter Developer (Contract)',
    company: 'Credes · Remote',
    duration: 'DEC 2025 – JAN 2026',
    description:
    'Engineered high-performance audio and media systems while automating the deployment lifecycle through custom CI/CD pipelines.',
    highlights: [
      'Built GitHub Actions pipeline cutting deployment time by 90%',
      'Overhauled audio engine for 40% better playback stability',
      'Implemented automated quality gates (Analysis & Formatting)',
      'Engineered cross-platform media notification system',
    ],
  ),
  _Experience(
    number: 4,
    role: 'Flutter Developer (Contract)',
    company: 'Apptalic Lab · Remote',
    duration: 'JAN 2025 – PRESENT',
    description:
    'Specialized in app performance optimization and complex content rendering engines for published market-ready applications.',
    highlights: [
      'Optimized app performance by 70% via widget tree refactoring',
      'Built native-like PDF and EPUB reading engines',
      'Integrated Google Books API for dynamic content sourcing',
      'Shipped Internda & Novelle to Play Store & App Store',
    ],
  ),
];

const _extraExperiences = [
  _Experience(
    number: 5,
    role: 'Flutter Developer',
    company: 'Marketing Analytics Africa · Nigeria',
    duration: 'JAN 2025 – MAY 2025',
    description:
    'Developed biometric-tracking fintech solutions involving step-to-currency conversion and digital wallet integrations.',
    highlights: [
      'Integrated Google Fit & Health Connect for biometric sync',
      'Built digital wallet with Paystack for secure withdrawals',
      'Architected MAAL Tracker step-to-coin conversion engine',
      'Designed high-frequency Firestore schema for real-time data',
    ],
  ),
  _Experience(
    number: 6,
    role: 'Media Executive & Web Manager',
    company: 'Advertisers Association of Nigeria',
    duration: '2021 – 2024',
    description:
    'Managed digital presence and corporate web platforms, focusing on audience analytics and UX-driven content strategy.',
    highlights: [
      'Maintained corporate WordPress site with a focus on UX',
      'Managed data-driven digital campaigns across platforms',
      'Analyzed audience metrics to improve engagement strategy',
      'Coordinated cross-platform digital marketing initiatives',
    ],
  ),
];

// ─── Main Widget ──────────────────────────────────────────────────────────────

class ExperienceSectionWidget extends StatefulWidget {
  const ExperienceSectionWidget({super.key});

  @override
  State<ExperienceSectionWidget> createState() =>
      _ExperienceSectionWidgetState();
}

class _ExperienceSectionWidgetState extends State<ExperienceSectionWidget>
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
      duration: const Duration(milliseconds: 500),
    );
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _expandAnim = CurvedAnimation(
      parent: _expandCtrl,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
  }

  @override
  void dispose() {
    _expandCtrl.dispose();
    _entranceCtrl.dispose();
    super.dispose();
  }

  void _toggleMore() {
    setState(() => _showMore = !_showMore);
    _showMore ? _expandCtrl.forward() : _expandCtrl.reverse();
  }

  void _openModal(_Experience exp) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'close',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (ctx, anim, _, __) => Material(
        type: MaterialType.transparency,
        child: FadeTransition(
          opacity: anim,
          child: _ExperienceModal(experience: exp, animation: anim),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hPad = ResponsiveHelper.getHorizontalPadding(context);
    final isMobile = ResponsiveHelper.isMobile(context);

    return VisibilityDetector(
      key: const Key('experience-section'),
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
              child: _SectionHeader(isMobile: isMobile),
            ),
            const SizedBox(height: 56),
            ..._mainExperiences.asMap().entries.map((e) {
              final index = e.key;
              return _AnimatedEntrance(
                controller: _entranceCtrl,
                delay: 0.2 + (index * 0.1),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ExperienceRow(
                    exp: e.value,
                    isFirst: index == 0,
                    isMobile: isMobile,
                    onTap: () => _openModal(e.value),
                  ),
                ),
              );
            }),
            AnimatedBuilder(
              animation: _expandAnim,
              builder: (_, child) => ClipRect(
                child: Align(
                  heightFactor: _expandAnim.value,
                  alignment: Alignment.topCenter,
                  child: child,
                ),
              ),
              child: Column(
                children: _extraExperiences
                    .map(
                      (exp) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ExperienceRow(
                      exp: exp,
                      isFirst: false,
                      isMobile: isMobile,
                      onTap: () => _openModal(exp),
                      slideAnim: _expandAnim,
                    ),
                  ),
                )
                    .toList(),
              ),
            ),
            const SizedBox(height: 32),
            _AnimatedEntrance(
              controller: _entranceCtrl,
              delay: 0.6,
              child: _ViewMoreButton(expanded: _showMore, onTap: _toggleMore),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Animation Helper ─────────────────────────────────────────────────────────

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
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(anim),
        child: child,
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final bool isMobile;
  const _SectionHeader({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Positioned(
          right: isMobile ? -20 : 0,
          top: -10,
          child: const _ScratchLines(),
        ),
        Column(
          children: [
            const _SunIcon(size: 36),
            const SizedBox(height: 14),
            Text(
              'EXPERIENCE',
              style: GoogleFonts.dmSans(
                fontSize: isMobile ? 38 : 58,
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
                'A journey through my professional milestones, building production-grade mobile solutions across diverse industries.',
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
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
      center,
      size.width * 0.12,
      paint..style = PaintingStyle.fill,
    );
    paint.style = PaintingStyle.stroke;

    const rayCount = 16;
    for (int i = 0; i < rayCount; i++) {
      final angle = (i / rayCount) * 2 * pi;
      final innerR = size.width * (i % 2 == 0 ? 0.22 : 0.28);
      final outerR = size.width * (i % 2 == 0 ? 0.44 : 0.36);
      canvas.drawLine(
        Offset(
          center.dx + innerR * cos(angle),
          center.dy + innerR * sin(angle),
        ),
        Offset(
          center.dx + outerR * cos(angle),
          center.dy + outerR * sin(angle),
        ),
        paint..strokeWidth = i % 2 == 0 ? 1.4 : 0.8,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Scratch Lines ────────────────────────────────────────────────────────────

class _ScratchLines extends StatefulWidget {
  const _ScratchLines({super.key});

  @override
  State<_ScratchLines> createState() => _ScratchLinesState();
}

class _ScratchLinesState extends State<_ScratchLines>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _pulseCtrl,
    builder: (context, child) =>
        Opacity(opacity: 0.6 + (_pulseCtrl.value * 0.4), child: child),
    child: CustomPaint(size: const Size(90, 90), painter: _ScratchPainter()),
  );
}

class _ScratchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const lineCount = 7;
    final spacing = size.width / (lineCount + 1);
    for (int i = 0; i < lineCount; i++) {
      final x = spacing * (i + 1);
      canvas.drawLine(
        Offset(x - 18, 0),
        Offset(x + 18, size.height),
        Paint()
          ..color = Colors.black.withOpacity(0.13 + i * 0.04)
          ..strokeWidth = 2.2
          ..strokeCap = StrokeCap.round
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 0.6 + i * 0.15),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Experience Row ───────────────────────────────────────────────────────────

class _ExperienceRow extends StatefulWidget {
  final _Experience exp;
  final bool isFirst;
  final bool isMobile;
  final VoidCallback onTap;
  final Animation<double>? slideAnim;

  const _ExperienceRow({
    required this.exp,
    required this.isFirst,
    required this.isMobile,
    required this.onTap,
    this.slideAnim,
  });

  @override
  State<_ExperienceRow> createState() => _ExperienceRowState();
}

class _ExperienceRowState extends State<_ExperienceRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    if (widget.isFirst) _ctrl.value = 1.0;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget row = MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _ctrl.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        if (!widget.isFirst) _ctrl.reverse();
      },
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _anim,
          builder: (_, __) {
            final v = _anim.value;
            final bg = Color.lerp(Colors.white, Colors.black, v)!;
            final fg = Color.lerp(Colors.black, Colors.white, v)!;
            final fgs = Color.lerp(Colors.black54, Colors.white60, v)!;
            final bord = Color.lerp(const Color(0xFFD0D0D0), Colors.black, v)!;
            final divC = Color.lerp(Colors.black26, Colors.white30, v)!;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              transform: Matrix4.translationValues(_isHovered ? 8 : 0, 0, 0),
              decoration: BoxDecoration(
                color: bg,
                border: Border.all(color: bord, width: 1.2),
                boxShadow: _isHovered
                    ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
                    : [],
              ),
              padding: widget.isMobile
                  ? const EdgeInsets.all(20)
                  : const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
              child: widget.isMobile
                  ? _mobileContent(fg, fgs, divC)
                  : _desktopContent(fg, fgs, divC),
            );
          },
        ),
      ),
    );

    if (widget.slideAnim != null) {
      row = AnimatedBuilder(
        animation: widget.slideAnim!,
        builder: (_, child) => Transform.translate(
          offset: Offset(0, 24 * (1 - widget.slideAnim!.value)),
          child: child,
        ),
        child: row,
      );
    }

    return row;
  }

  Widget _desktopContent(Color fg, Color fgs, Color divC) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _NumberBadge(number: widget.exp.number, fg: fg),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.exp.role,
                style: GoogleFonts.dmSans(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: fg,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.exp.company,
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  color: fgs,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        Container(width: 1, height: 36, color: divC),
        const SizedBox(width: 28),
        Text(
          widget.exp.duration,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: fgs,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _mobileContent(Color fg, Color fgs, Color divC) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _NumberBadge(number: widget.exp.number, fg: fg),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.exp.role,
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: fg,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    widget.exp.company,
                    style: GoogleFonts.dmSans(fontSize: 12, color: fgs),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(width: double.infinity, height: 1, color: divC),
        const SizedBox(height: 10),
        Text(
          'JOB DURATION -  ${widget.exp.duration}',
          style: GoogleFonts.dmSans(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: fgs,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}

// ─── Number Badge ─────────────────────────────────────────────────────────────

class _NumberBadge extends StatelessWidget {
  final int number;
  final Color fg;
  const _NumberBadge({required this.number, required this.fg, super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = fg == Colors.white;
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: isLight ? Colors.grey.withOpacity(0.4) : Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          '$number',
          style: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// ─── View More Button ─────────────────────────────────────────────────────────

class _ViewMoreButton extends StatefulWidget {
  final bool expanded;
  final VoidCallback onTap;
  const _ViewMoreButton({
    required this.expanded,
    required this.onTap,
    super.key,
  });

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

// ─── Experience Modal ─────────────────────────────────────────────────────────

class _ExperienceModal extends StatelessWidget {
  final _Experience experience;
  final Animation<double> animation;
  const _ExperienceModal({
    required this.experience,
    required this.animation,
    super.key,
  });

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
                  color: const Color(0xFF0A0A0A).withOpacity(0.72),
                ),
              ),
            ),
          ),
        ),
        Center(
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack, // Corrected Curve
            ),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: isMobile
                    ? sz.width * 0.92
                    : (sz.width * 0.46).clamp(400.0, 600.0),
                constraints: BoxConstraints(maxHeight: sz.height * 0.86),
                margin: const EdgeInsets.symmetric(vertical: 40),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D0D0D).withOpacity(0.95),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.12),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.70),
                      blurRadius: 80,
                      spreadRadius: -4,
                      offset: const Offset(0, 32),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      Positioned(
                        top: -60,
                        right: -60,
                        child: CustomPaint(
                          size: const Size(220, 220),
                          painter: _GlowCirclePainter(),
                        ),
                      ),
                      _ModalContent(experience: experience, isMobile: isMobile),
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

class _GlowCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.white.withOpacity(0.06), Colors.white.withOpacity(0.0)],
      ).createShader(Rect.fromCircle(center: center, radius: size.width / 2));
    canvas.drawCircle(center, size.width / 2, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _ModalContent extends StatelessWidget {
  final _Experience experience;
  final bool isMobile;
  const _ModalContent({
    required this.experience,
    required this.isMobile,
    super.key,
  });

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
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.14),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${experience.number}',
                    style: GoogleFonts.dmSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
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
                      color: Colors.white.withOpacity(0.08),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.16),
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
          SizedBox(height: isMobile ? 22 : 28),
          Text(
            experience.role,
            style: GoogleFonts.dmSans(
              fontSize: isMobile ? 20 : 26,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.2,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Flexible(
                child: Text(
                  experience.company,
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  width: 1,
                  height: 13,
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
              Text(
                experience.duration,
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withOpacity(0.4),
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
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
          const SizedBox(height: 22),
          Text(
            experience.description,
            style: GoogleFonts.dmSans(
              fontSize: isMobile ? 13.5 : 14.5,
              color: Colors.white.withOpacity(0.75),
              height: 1.75,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Container(
                width: 3,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'KEY HIGHLIGHTS',
                style: GoogleFonts.dmSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withOpacity(0.45),
                  letterSpacing: 1.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...experience.highlights.map(
                (h) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 7, right: 12),
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.55),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      h,
                      style: GoogleFonts.dmSans(
                        fontSize: isMobile ? 13 : 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.82),
                        height: 1.55,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          const _ModalCloseButton(),
        ],
      ),
    );
  }
}

class _ModalCloseButton extends StatefulWidget {
  const _ModalCloseButton({super.key});

  @override
  State<_ModalCloseButton> createState() => _ModalCloseButtonState();
}

class _ModalCloseButtonState extends State<_ModalCloseButton> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _hov = true),
    onExit: (_) => setState(() => _hov = false),
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: _hov
              ? Colors.white.withOpacity(0.12)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _hov
                ? Colors.white.withOpacity(0.22)
                : Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            'CLOSE',
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white.withOpacity(_hov ? 0.9 : 0.55),
              letterSpacing: 1.8,
            ),
          ),
        ),
      ),
    ),
  );
}