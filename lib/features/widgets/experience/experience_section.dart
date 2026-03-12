// lib/features/home/widgets/experience_section_widget.dart

import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    with SingleTickerProviderStateMixin {
  bool _showMore = false;
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _anim = CurvedAnimation(
        parent: _ctrl,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggleMore() {
    setState(() => _showMore = !_showMore);
    _showMore ? _ctrl.forward() : _ctrl.reverse();
  }

  void _openModal(_Experience exp) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'close',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, _, _) => const SizedBox.shrink(),
      transitionBuilder: (ctx, anim, _, _) => Material(
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

    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(hPad, 80, hPad, 80),
      child: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────
          _SectionHeader(isMobile: isMobile),
          const SizedBox(height: 56),

          // ── Experience rows ─────────────────────────────────────────────
          ..._mainExperiences.asMap().entries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ExperienceRow(
              exp: e.value,
              isFirst: e.key == 0,
              isMobile: isMobile,
              onTap: () => _openModal(e.value),
            ),
          )),

          // ── Extra rows — animated collapse ──────────────────────────────
          AnimatedBuilder(
            animation: _anim,
            builder: (_, child) => ClipRect(
              child: Align(
                  heightFactor: _anim.value,
                  alignment: Alignment.topCenter,
                  child: child),
            ),
            child: Column(
              children: _extraExperiences
                  .map((exp) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ExperienceRow(
                  exp: exp,
                  isFirst: false,
                  isMobile: isMobile,
                  onTap: () => _openModal(exp),
                  slideAnim: _anim,
                ),
              ))
                  .toList(),
            ),
          ),

          const SizedBox(height: 32),

          // ── View More button ─────────────────────────────────────────────
          _ViewMoreButton(expanded: _showMore, onTap: _toggleMore),
        ],
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
        // Diagonal scratch lines — top right
        Positioned(
          right: isMobile ? -20 : 0,
          top: -10,
          child: const _ScratchLines(),
        ),

        // Center content
        Column(
          children: [
            // Sun icon
            const _SunIcon(size: 36),
            const SizedBox(height: 14),

            // Title
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

            // Description
            SizedBox(
              width: isMobile ? double.infinity : 420,
              child: Text(
                'There are many variations of passages of Lorem Ipsum available,\nbut the majority have suffered alteration in some form.',
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

// ─── Sun Icon (CustomPainter) ─────────────────────────────────────────────────

class _SunIcon extends StatelessWidget {
  final double size;
  const _SunIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _SunPainter(),
    );
  }
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

    // Inner circle
    canvas.drawCircle(center, size.width * 0.12, paint..style = PaintingStyle.fill);

    paint.style = PaintingStyle.stroke;

    // Rays — 16 rays at different lengths for a dense sun feel
    final rayCount = 16;
    for (int i = 0; i < rayCount; i++) {
      final angle = (i / rayCount) * 2 * pi;
      final innerR = size.width * (i % 2 == 0 ? 0.22 : 0.28);
      final outerR = size.width * (i % 2 == 0 ? 0.44 : 0.36);
      canvas.drawLine(
        Offset(center.dx + innerR * cos(angle), center.dy + innerR * sin(angle)),
        Offset(center.dx + outerR * cos(angle), center.dy + outerR * sin(angle)),
        paint..strokeWidth = i % 2 == 0 ? 1.4 : 0.8,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Scratch Lines (top right decoration) ────────────────────────────────────

class _ScratchLines extends StatelessWidget {
  const _ScratchLines();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(90, 90),
      painter: _ScratchPainter(),
    );
  }
}

class _ScratchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final lineCount = 7;
    final spacing = size.width / (lineCount + 1);

    for (int i = 0; i < lineCount; i++) {
      final x = spacing * (i + 1);
      // Each line is slightly rotated (~30°) and has a shadow feel
      final paint = Paint()
        ..color = Colors.black.withValues(alpha: 0.13 + i * 0.04)
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 0.6 + i * 0.15);

      canvas.drawLine(
        Offset(x - 18, 0),
        Offset(x + 18, size.height),
        paint,
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

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 260));
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
      onEnter: (_) => _ctrl.forward(),
      onExit: (_) {
        if (!widget.isFirst) _ctrl.reverse();
      },
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _anim,
          builder: (_, _) {
            final v = _anim.value;
            final bg   = Color.lerp(Colors.white, Colors.black, v)!;
            final fg   = Color.lerp(Colors.black, Colors.white, v)!;
            final fgs  = Color.lerp(Colors.black54, Colors.white60, v)!;
            final bord = Color.lerp(const Color(0xFFD0D0D0), Colors.black, v)!;
            final divC = Color.lerp(Colors.black26, Colors.white30, v)!;

            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: bg,
                border: Border.all(color: bord, width: 1.2),
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

    // Slide in if part of the expandable section
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
        // Number badge
        _NumberBadge(number: widget.exp.number, fg: fg),
        const SizedBox(width: 20),

        // Role + company
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.exp.role,
                  style: GoogleFonts.dmSans(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: fg,
                      height: 1.2)),
              const SizedBox(height: 4),
              Text(widget.exp.company,
                  style: GoogleFonts.dmSans(
                      fontSize: 13, color: fgs, height: 1.3)),
            ],
          ),
        ),

        // Thin divider
        Container(width: 1, height: 36, color: divC),
        const SizedBox(width: 28),

        // Duration
        Text(
          'JOB DURATION -  ${widget.exp.duration}',
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
        Row(children: [
          _NumberBadge(number: widget.exp.number, fg: fg),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.exp.role,
                    style: GoogleFonts.dmSans(
                        fontSize: 15, fontWeight: FontWeight.w700, color: fg)),
                const SizedBox(height: 3),
                Text(widget.exp.company,
                    style: GoogleFonts.dmSans(fontSize: 12, color: fgs)),
              ],
            ),
          ),
        ]),
        const SizedBox(height: 14),
        Container(width: double.infinity, height: 1, color: divC),
        const SizedBox(height: 10),
        Text(
          'JOB DURATION -  ${widget.exp.duration}',
          style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: fgs,
              letterSpacing: 0.8),
        ),
      ],
    );
  }
}

// ─── Number Badge ─────────────────────────────────────────────────────────────

class _NumberBadge extends StatelessWidget {
  final int number;
  final Color fg;
  const _NumberBadge({required this.number, required this.fg});

  @override
  Widget build(BuildContext context) {
    // Badge inverts: white bg + black text when row is dark (hovered/first)
    final isLight = fg == Colors.white;
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: isLight ? Colors.grey.withValues(alpha: 0.4) : Colors.black,
        borderRadius: BorderRadius.circular(8), // Adjust the radius value as needed
      ),
      child: Center(
        child: Text(
          '$number',
          style: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isLight ? Colors.white : Colors.white,
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
      onExit:  (_) => setState(() => _hov = false),
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
  const _ExperienceModal(
      {required this.experience, required this.animation});

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.of(context).size;
    final isMobile = sz.width < 600;

    return Stack(children: [
      // Blurred backdrop
      Positioned.fill(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
              child: Container(color: Colors.black.withValues(alpha: 0.22)),
            ),
          ),
        ),
      ),

      // Modal card
      Center(
        child: ScaleTransition(
          scale:
          CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: isMobile
                  ? sz.width * 0.92
                  : (sz.width * 0.46).clamp(380.0, 580.0),
              constraints: BoxConstraints(maxHeight: sz.height * 0.84),
              margin: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.22), width: 1.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 60,
                    spreadRadius: -8,
                    offset: const Offset(0, 24),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Container(
                    color: Colors.white.withValues(alpha: 0.08),
                    child: _ModalContent(
                        experience: experience, isMobile: isMobile),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}

class _ModalContent extends StatelessWidget {
  final _Experience experience;
  final bool isMobile;
  const _ModalContent(
      {required this.experience, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final pad = isMobile ? 24.0 : 40.0;
    return SingleChildScrollView(
      padding: EdgeInsets.all(pad),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top: number badge + close
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25), width: 1),
                  ),
                  child: Center(
                    child: Text(
                      '${experience.number}',
                      style: GoogleFonts.dmSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
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
                        color: Colors.white.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2), width: 1),
                      ),
                      child: const Icon(Icons.close_rounded,
                          size: 17, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: isMobile ? 20 : 26),

            // Role
            Text(experience.role,
                style: GoogleFonts.dmSans(
                    fontSize: isMobile ? 20 : 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                    letterSpacing: -0.3)),
            const SizedBox(height: 6),

            // Company + duration row
            Row(children: [
              Text(experience.company,
                  style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: Colors.white60,
                      fontWeight: FontWeight.w500)),
              const SizedBox(width: 16),
              Container(width: 1, height: 14, color: Colors.white24),
              const SizedBox(width: 16),
              Text(experience.duration,
                  style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white54,
                      letterSpacing: 0.8)),
            ]),

            const SizedBox(height: 18),
            Container(height: 1, color: Colors.white.withValues(alpha: 0.15)),
            const SizedBox(height: 18),

            // Description
            Text(experience.description,
                style: GoogleFonts.dmSans(
                    fontSize: isMobile ? 13.5 : 14.5,
                    color: Colors.white.withValues(alpha: 0.82),
                    height: 1.72)),

            const SizedBox(height: 20),

            // Highlights
            Text('KEY HIGHLIGHTS',
                style: GoogleFonts.dmSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white54,
                    letterSpacing: 1.6)),
            const SizedBox(height: 12),

            ...experience.highlights.map((h) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      margin: const EdgeInsets.only(top: 8, right: 12),
                      decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.7),
                          shape: BoxShape.circle),
                    ),
                    Expanded(
                      child: Text(h,
                          style: GoogleFonts.dmSans(
                              fontSize: isMobile ? 13 : 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.88),
                              height: 1.5)),
                    ),
                  ]),
            )),

            const SizedBox(height: 24),
            _ModalClose(),
          ]),
    );
  }
}

class _ModalClose extends StatefulWidget {
  @override
  State<_ModalClose> createState() => _ModalCloseState();
}

class _ModalCloseState extends State<_ModalClose> {
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
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: _hov
              ? Colors.white.withValues(alpha: 0.22)
              : Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border:
          Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1),
        ),
        child: Center(
          child: Text('CLOSE',
              style: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 1.2)),
        ),
      ),
    ),
  );
}