// lib/features/home/widgets/services_section_widget.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/responsive_helper.dart';

// ─── Data ─────────────────────────────────────────────────────────────────────

class _Service {
  final FaIconData icon;
  final String title;
  final bool isHighlighted;
  final String modalTitle;
  final String description;
  final List<String> bullets;
  final List<String> tags;
  const _Service({
    required this.icon,
    required this.title,
    required this.isHighlighted,
    required this.modalTitle,
    required this.description,
    required this.bullets,
    required this.tags,
  });
}

const _allServices = [
  _Service(
    icon: FontAwesomeIcons.mobileScreenButton,
    title: 'FLUTTER\nDEVELOPMENT',
    isHighlighted: false,
    modalTitle: 'Mobile App Development',
    description:
    'Building high-performance, cross-platform applications for iOS and Android. I specialize in scalable architectures.',
    bullets: [
      'State Management: BLoC, Provider, and MVVM',
      'Backend: Firebase & Supabase',
      'Hardware: Google Fit & Health Connect',
      'Payments: Paystack & Stripe API',
    ],
    tags: ['Dart', 'BLoC', 'Firebase', 'iOS/Android'],
  ),
  _Service(
    icon: FontAwesomeIcons.code,
    title: 'NEXT.JS\nDEVELOPMENT',
    isHighlighted: false,
    modalTitle: 'Web & Frontend Development',
    description:
    'Crafting responsive, SEO-optimized web applications. I focus on clean code and fast load times.',
    bullets: [
      'ReactJS & Next.js SSR',
      'Tailwind CSS UI',
      'REST API & Swagger',
      'Performance Optimization',
    ],
    tags: ['Next.js', 'React', 'TypeScript', 'Tailwind'],
  ),
  _Service(
    icon: FontAwesomeIcons.cloud,
    title: 'BACKEND &\nFIREBASE',
    isHighlighted: false,
    modalTitle: 'Cloud Infrastructure',
    description:
    'Architecting secure, real-time databases and serverless logic to handle your data at scale.',
    bullets: [
      'Firebase Auth & Firestore',
      'Supabase Postgres',
      'RESTful API Design',
      'Security Rules & Roles',
    ],
    tags: ['Node.js', 'PostgreSQL', 'Serverless', 'APIs'],
  ),
  _Service(
    icon: FontAwesomeIcons.gears,
    title: 'DEVOPS &\nAUTOMATION',
    isHighlighted: false,
    modalTitle: 'Continuous Delivery',
    description:
    'Automating deployment pipelines to ensure every release is tested and stable.',
    bullets: [
      'CI/CD: GitHub Actions',
      'Firebase App Distribution',
      'Automated Builds',
      'Advanced Git Flow',
    ],
    tags: ['CI/CD', 'GitHub', 'Automation', 'Docker'],
  ),
  _Service(
    icon: FontAwesomeIcons.vial,
    title: 'TESTING &\nQUALITY',
    isHighlighted: false,
    modalTitle: 'Quality Assurance',
    description:
    'Ensuring software reliability through rigorous testing to deliver a polished user experience.',
    bullets: [
      'Unit & Logic Testing',
      'Widget UI Testing',
      'Static Analysis',
      'Sentry & Crashlytics',
    ],
    tags: ['Unit Test', 'QA', 'Sentry', 'Code Review'],
  ),
  _Service(
    icon: FontAwesomeIcons.usersGear,
    title: 'PRODUCT\nLEADERSHIP',
    isHighlighted: false,
    modalTitle: 'Agile & Project Strategy',
    description:
    'Managing the development lifecycle. I help align technical execution with business goals.',
    bullets: [
      'Agile/Scrum (Jira)',
      'Technical Documentation',
      'System Design',
      'Cross-functional Alignment',
    ],
    tags: ['Agile', 'Strategy', 'Scrum', 'Mentoring'],
  ),
];

// ─── Main Section ─────────────────────────────────────────────────────────────

class ServicesSectionWidget extends StatefulWidget {
  /// Pass the GlobalKey of your contact section so the modal CTA can scroll to it.
  final GlobalKey contactSectionKey;

  const ServicesSectionWidget({super.key, required this.contactSectionKey});

  @override
  State<ServicesSectionWidget> createState() => _ServicesSectionState();
}

class _ServicesSectionState extends State<ServicesSectionWidget>
    with TickerProviderStateMixin {
  bool _expanded = false;
  bool _isVisible = false;
  late AnimationController _expandCtrl;
  late Animation<double> _expandAnim;

  @override
  void initState() {
    super.initState();
    _expandCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _expandAnim = CurvedAnimation(
      parent: _expandCtrl,
      curve: Curves.easeInOutQuart,
    );
  }

  @override
  void dispose() {
    _expandCtrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _expandCtrl.forward() : _expandCtrl.reverse();
  }

  void _openModal(_Service s) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'close',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (ctx, anim, _, __) => Material(
        type: MaterialType.transparency,
        child: _ServiceModal(
          service: s,
          animation: anim,
          onGetInTouch: () {
            // Close modal first, then scroll to contact section
            Navigator.of(ctx).pop();
            Future.delayed(const Duration(milliseconds: 300), () {
              final context = widget.contactSectionKey.currentContext;
              if (context != null) {
                Scrollable.ensureVisible(
                  context,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOutCubic,
                );
              }
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hPad = ResponsiveHelper.getHorizontalPadding(context);
    final isMobile = ResponsiveHelper.isMobile(context);

    return VisibilityDetector(
      key: const Key('services-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_isVisible) {
          setState(() => _isVisible = true);
        }
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(hPad, 60, hPad, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(
              expanded: _expanded,
              onToggle: _toggle,
              isMobile: isMobile,
              isVisible: _isVisible,
            ),
            SizedBox(height: isMobile ? 40 : 56),
            isMobile ? _mobileCards() : _desktopCards(context),
          ],
        ),
      ),
    );
  }

  Widget _desktopCards(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ScrollIndicatorColumn()
            .animate(target: _isVisible ? 1 : 0)
            .fadeIn(delay: 400.ms)
            .slideX(begin: -0.2),
        SizedBox(width: isTablet ? 20 : 40),
        Expanded(
          child: LayoutBuilder(
            builder: (context, c) {
              final cardW = (c.maxWidth - 32) / 3;
              final cardH = (MediaQuery.of(context).size.height * 0.38).clamp(
                260.0,
                340.0,
              );
              return Column(
                children: [
                  _CardRow(
                    services: _allServices.sublist(0, 3),
                    cardW: cardW,
                    cardH: cardH,
                    onTap: _openModal,
                    isVisible: _isVisible,
                  ),
                  SizeTransition(
                    sizeFactor: _expandAnim,
                    axisAlignment: -1,
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        _CardRow(
                          services: _allServices.sublist(3, 6),
                          cardW: cardW,
                          cardH: cardH,
                          onTap: _openModal,
                          slide: true,
                          anim: _expandAnim,
                          isVisible: true,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _mobileCards() {
    return Column(
      children: [
        ...List.generate(
          3,
              (i) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _ServiceCard(
              service: _allServices[i],
              width: double.infinity,
              height: null,
              onTap: () => _openModal(_allServices[i]),
            )
                .animate(target: _isVisible ? 1 : 0)
                .fadeIn(delay: (200 + (i * 100)).ms)
                .slideY(begin: 0.1),
          ),
        ),
        SizeTransition(
          sizeFactor: _expandAnim,
          axisAlignment: -1,
          child: Column(
            children: List.generate(
              3,
                  (i) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _ServiceCard(
                  service: _allServices[i + 3],
                  width: double.infinity,
                  height: null,
                  onTap: () => _openModal(_allServices[i + 3]),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final bool expanded;
  final VoidCallback onToggle;
  final bool isMobile;
  final bool isVisible;
  const _Header({
    required this.expanded,
    required this.onToggle,
    required this.isMobile,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    final btn = _AllServicesButton(expanded: expanded, onTap: onToggle);

    Widget animate(Widget child, int delay) => child
        .animate(target: isVisible ? 1 : 0)
        .fadeIn(delay: delay.ms, duration: 600.ms)
        .blur(begin: const Offset(10, 0), end: Offset.zero)
        .slideX(begin: 0.05, end: 0);

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          animate(const _SectionLabel(), 0),
          const SizedBox(height: 12),
          animate(const _SectionTitle(), 100),
          const SizedBox(height: 24),
          animate(const _SectionDescription(), 200),
          const SizedBox(height: 20),
          animate(btn, 300),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        animate(const _SectionLabel(), 0),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            animate(const _SectionTitle(), 100),
            const SizedBox(width: 48),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: animate(const _SectionDescription(), 200)),
                  const SizedBox(width: 28),
                  animate(btn, 300),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Card Row ─────────────────────────────────────────────────────────────────

class _CardRow extends StatelessWidget {
  final List<_Service> services;
  final double cardW, cardH;
  final void Function(_Service) onTap;
  final bool slide;
  final Animation<double>? anim;
  final bool isVisible;
  const _CardRow({
    required this.services,
    required this.cardW,
    required this.cardH,
    required this.onTap,
    this.slide = false,
    this.anim,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(services.length, (i) {
        Widget card = _ServiceCard(
          service: services[i],
          width: cardW,
          height: cardH,
          onTap: () => onTap(services[i]),
        );

        if (slide && anim != null) {
          card = FadeTransition(opacity: anim!, child: card);
        } else {
          card = card
              .animate(target: isVisible ? 1 : 0)
              .fadeIn(delay: (400 + (i * 100)).ms)
              .slideY(begin: 0.1, curve: Curves.easeOutCubic);
        }

        return Padding(
          padding: EdgeInsets.only(right: i < 2 ? 16 : 0),
          child: card,
        );
      }),
    );
  }
}

// ─── Section Label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel();
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(width: 28, height: 1.2, color: Colors.black54),
      const SizedBox(width: 10),
      Text(
        'MY SKILLS',
        style: GoogleFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
          letterSpacing: 1.8,
        ),
      ),
    ],
  );
}

// ─── Section Title ────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle();
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final fs = w < 600 ? 36.0 : w < 900 ? 44.0 : w < 1200 ? 52.0 : 62.0;
    return Text(
      "WHAT I\nDO",
      style: GoogleFonts.dmSans(
        fontSize: fs,
        fontWeight: FontWeight.w800,
        color: Colors.black,
        height: 1.05,
        letterSpacing: -1.0,
      ),
    );
  }
}

// ─── Section Description ──────────────────────────────────────────────────────

class _SectionDescription extends StatelessWidget {
  const _SectionDescription();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: GoogleFonts.dmSans(
              fontSize: 28.0,
              color: const Color(0xFF0F0F0F),
              height: 1.2,
            ),
            children: const [
              TextSpan(text: 'I craft mobile experiences that\n'),
              TextSpan(
                text: 'launch quickly,',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF1A4FD6),
                ),
              ),
              TextSpan(text: ' scale effortlessly,\nand feel truly native.'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'From a single codebase, I deliver iOS and Android apps with real-time backends, smooth performance, and the reliability that keeps users coming back — and engineering teams sane.',
          style: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: const Color(0xFF4A4A4A),
            height: 1.8,
          ),
        ),
      ],
    );
  }
}

// ─── All Services Button ──────────────────────────────────────────────────────

class _AllServicesButton extends StatefulWidget {
  final bool expanded;
  final VoidCallback onTap;
  const _AllServicesButton({required this.expanded, required this.onTap});
  @override
  State<_AllServicesButton> createState() => _AllServicesButtonState();
}

class _AllServicesButtonState extends State<_AllServicesButton> {
  bool _hov = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _hov = true),
    onExit: (_) => setState(() => _hov = false),
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
        const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        decoration: BoxDecoration(
          color: _hov ? const Color(0xFF333333) : Colors.black,
          borderRadius: BorderRadius.circular(50),
          boxShadow: _hov
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ]
              : [],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: Text(
            widget.expanded ? 'CLOSE SKILLS' : 'ALL SKILLS',
            key: ValueKey(widget.expanded),
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ).animate(onPlay: (c) => c.repeat()).shimmer(
        delay: 3.seconds,
        duration: 1500.ms,
        color: Colors.white24,
      ),
    ),
  );
}

// ─── Scroll Indicator ─────────────────────────────────────────────────────────

class _ScrollIndicatorColumn extends StatelessWidget {
  const _ScrollIndicatorColumn();
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 32,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RotatedBox(
          quarterTurns: 1,
          child: Text(
            'SCROLL DOWN',
            style: GoogleFonts.dmSans(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
              letterSpacing: 2.0,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(width: 1, height: 80, color: Colors.black26),
        const SizedBox(height: 16),
        const _DownArrowBtn(),
      ],
    ),
  );
}

class _DownArrowBtn extends StatefulWidget {
  const _DownArrowBtn();
  @override
  State<_DownArrowBtn> createState() => _DownArrowBtnState();
}

class _DownArrowBtnState extends State<_DownArrowBtn> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _hov = true),
    onExit: (_) => setState(() => _hov = false),
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTap: () {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: _hov ? const Color(0xFF333333) : Colors.black,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.white,
          size: 22,
        ),
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true)).moveY(
      begin: 0,
      end: 8,
      duration: 1000.ms,
      curve: Curves.easeInOut,
    ),
  );
}

// ─── Service Card ─────────────────────────────────────────────────────────────

class _ServiceCard extends StatefulWidget {
  final _Service service;
  final double width;
  final double? height; // nullable — null = wrap content (mobile)
  final VoidCallback onTap;
  const _ServiceCard({
    required this.service,
    required this.width,
    required this.height,
    required this.onTap,
  });
  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _isHovered = false;

  String _truncateWords(String text, int wordLimit) {
    final words = text.split(' ');
    if (words.length <= wordLimit) return text;
    return '${words.take(wordLimit).join(' ')}...';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _isHovered || widget.service.isHighlighted;
    final fg = isDark ? Colors.white : Colors.black;
    final fgs = isDark ? Colors.white70 : Colors.black54;

    final tags = widget.service.tags;
    final shownTags = tags.length > 3 ? tags.sublist(0, 3) : tags;
    final overflowCount = tags.length > 3 ? tags.length - 3 : 0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutQuart,
          transform: Matrix4.translationValues(0, _isHovered ? -12 : 0, 0),
          width: widget.width == double.infinity ? null : widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: isDark ? Colors.black : Colors.white,
            border: Border.all(
              color: isDark ? Colors.black : const Color(0xFFCCCCCC),
              width: 1.2,
            ),
            boxShadow: _isHovered
                ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ]
                : [],
          ),
          padding: const EdgeInsets.all(26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // shrink-wrap on mobile
            children: [
              FaIcon(widget.service.icon, size: 32, color: fg)
                  .animate(target: _isHovered ? 1 : 0)
                  .scale(end: const Offset(1.2, 1.2))
                  .rotate(begin: 0, end: 0.05),

              const SizedBox(height: 16),

              Text(
                widget.service.title,
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: fg,
                  height: 1.25,
                  letterSpacing: 0.2,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                _truncateWords(widget.service.description, 10),
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: fgs,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 12),

              // Tags — max 3 shown + overflow chip
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  ...shownTags.map((tag) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.1)
                          : const Color(0xFFF5F7F9),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isDark
                            ? Colors.white10
                            : Colors.black.withOpacity(0.05),
                      ),
                    ),
                    child: Text(
                      tag.toUpperCase(),
                      style: GoogleFonts.dmSans(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w700,
                        color:
                        isDark ? Colors.white70 : Colors.black87,
                        letterSpacing: 0.5,
                      ),
                    ),
                  )),
                  if (overflowCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.06)
                            : const Color(0xFFEEEEEE),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '+$overflowCount',
                        style: GoogleFonts.dmSans(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          color:
                          isDark ? Colors.white38 : Colors.black45,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 20),

              // READ MORE
              Row(
                children: [
                  Text(
                    'READ MORE',
                    style: GoogleFonts.dmSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: fgs,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(Icons.arrow_forward_rounded, size: 12, color: fgs),
                ],
              ).animate(target: _isHovered ? 1 : 0)
                  .shimmer(duration: 800.ms, color: Colors.white54),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Service Modal ────────────────────────────────────────────────────────────

class _ServiceModal extends StatelessWidget {
  final _Service service;
  final Animation<double> animation;
  final VoidCallback onGetInTouch;
  const _ServiceModal({
    required this.service,
    required this.animation,
    required this.onGetInTouch,
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
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(color: Colors.black.withOpacity(0.7)),
            ),
          ).animate().fadeIn(),
        ),
        Center(
          child: Container(
            width: isMobile
                ? sz.width * 0.92
                : (sz.width * 0.46).clamp(380.0, 580.0),
            constraints: BoxConstraints(maxHeight: sz.height * 0.84),
            decoration: BoxDecoration(
              color: const Color(0xFF0E0E0E).withOpacity(0.95),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: _ModalContent(
                service: service,
                isMobile: isMobile,
                onGetInTouch: onGetInTouch,
              ),
            ),
          )
              .animate()
              .scale(
            begin: const Offset(0.8, 0.8),
            curve: Curves.easeOutBack,
            duration: 400.ms,
          )
              .blurXY(begin: 20, end: 0)
              .fadeIn(),
        ),
      ],
    );
  }
}

// ─── Modal Content ────────────────────────────────────────────────────────────

class _ModalContent extends StatelessWidget {
  final _Service service;
  final bool isMobile;
  final VoidCallback onGetInTouch;
  const _ModalContent({
    required this.service,
    required this.isMobile,
    required this.onGetInTouch,
  });

  @override
  Widget build(BuildContext context) {
    final pad = isMobile ? 24.0 : 40.0;
    return SingleChildScrollView(
      padding: EdgeInsets.all(pad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row — icon + close
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: Colors.white12),
                ),
                child: Center(
                  child: FaIcon(service.icon, size: 22, color: Colors.white70),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon:
                const Icon(Icons.close_rounded, color: Colors.white70),
              ),
            ],
          ),

          const SizedBox(height: 26),

          Text(
            service.modalTitle,
            style: GoogleFonts.dmSans(
              fontSize: isMobile ? 21 : 27,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ).animate().slideX(begin: 0.1, delay: 100.ms),

          const SizedBox(height: 18),

          Text(
            service.description,
            style: GoogleFonts.dmSans(
              fontSize: 14.5,
              color: Colors.white.withOpacity(0.8),
              height: 1.7,
            ),
          ).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: 30),

          // Bullets
          ...service.bullets
              .map(
                (b) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline,
                      size: 16, color: Colors.white38),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      b,
                      style:
                      const TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          )
              .toList()
              .animate(interval: 50.ms)
              .fadeIn()
              .slideX(begin: 0.05),

          const SizedBox(height: 20),

          // All tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: service.tags
                .map(
                  (tag) => Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.white12),
                ),
                child: Text(
                  tag.toUpperCase(),
                  style: GoogleFonts.dmSans(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white60,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            )
                .toList(),
          ).animate().fadeIn(delay: 300.ms),

          const SizedBox(height: 30),

          // CTA
          _ModalCta(onTap: onGetInTouch),
        ],
      ),
    );
  }
}

// ─── Modal CTA ────────────────────────────────────────────────────────────────

class _ModalCta extends StatefulWidget {
  final VoidCallback onTap;
  const _ModalCta({required this.onTap});
  @override
  State<_ModalCta> createState() => _ModalCtaState();
}

class _ModalCtaState extends State<_ModalCta> {
  bool _hov = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _hov = true),
    onExit: (_) => setState(() => _hov = false),
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: 200.ms,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color:
          _hov ? Colors.white : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            'GET IN TOUCH',
            style: TextStyle(
              color: _hov ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    ),
  );
}