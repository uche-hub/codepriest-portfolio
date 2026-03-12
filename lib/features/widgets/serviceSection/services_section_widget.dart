// lib/features/home/widgets/services_section_widget.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/constants/responsive_helper.dart';

// ─── Data ─────────────────────────────────────────────────────────────────────

class _Service {
  final FaIconData icon;
  final String title;
  final bool isHighlighted;
  final String modalTitle;
  final String description;
  final List<String> bullets;
  const _Service({
    required this.icon, required this.title, required this.isHighlighted,
    required this.modalTitle, required this.description, required this.bullets,
  });
}

const _allServices = [
  _Service(
    icon: FontAwesomeIcons.mobileScreenButton,
    title: 'FLUTTER\nDEVELOPMENT',
    isHighlighted: true,
    modalTitle: 'Mobile App Development',
    description: 'Building high-performance, cross-platform applications for iOS and Android using Dart. I specialize in scalable architectures and seamless hardware integrations.',
    bullets: [
      'State Management: BLoC, Provider, and MVVM',
      'Backend: Firebase (Auth, Firestore) & Supabase',
      'Hardware: Google Fit & Health Connect integration',
      'Payments: Paystack & Stripe API implementation'
    ],
  ),
  _Service(
    icon: FontAwesomeIcons.code,
    title: 'NEXT.JS\nDEVELOPMENT',
    isHighlighted: false,
    modalTitle: 'Web & Frontend Development',
    description: 'Crafting responsive, SEO-optimized web applications using Next.js and React. I focus on clean code, fast load times, and bridging the gap between design and engineering.',
    bullets: [
      'ReactJS & Next.js server-side rendering',
      'Responsive UI with Tailwind CSS & JavaScript',
      'REST API integration & Swagger documentation',
      'Performance optimization & accessibility (a11y)'
    ],
  ),
  _Service(
    icon: FontAwesomeIcons.cloud,
    title: 'BACKEND &\nFIREBASE',
    isHighlighted: false,
    modalTitle: 'Cloud Infrastructure',
    description: 'Architecting the "brain" of your application. I set up secure, real-time databases and serverless logic to handle your data at scale.',
    bullets: [
      'Firebase: Auth, Firestore, & Cloud Functions',
      'Supabase: Postgres & Real-time subscriptions',
      'API Design: RESTful Services & Swagger',
      'Security: Rules, Roles, & Data Encryption'
    ],
  ),
  _Service(
    icon: FontAwesomeIcons.gears,
    title: 'DEVOPS &\nAUTOMATION',
    isHighlighted: false,
    modalTitle: 'Continuous Delivery',
    description: 'Automating the deployment pipeline to ensure every release is tested and stable. I manage the journey from local code to the App Store.',
    bullets: [
      'CI/CD: GitHub Actions & GitLab Pipelines',
      'Distribution: Firebase App Distribution',
      'Builds: Automated .aab & APK generation',
      'Version Control: Advanced Git & GitHub Flow'
    ],
  ),
  _Service(
    icon: FontAwesomeIcons.vial,
    title: 'TESTING &\nQUALITY',
    isHighlighted: false,
    modalTitle: 'Quality Assurance',
    description: 'Ensuring software reliability through rigorous testing phases. I focus on catching bugs early to deliver a polished, crash-free user experience.',
    bullets: [
      'Unit Testing: Logic & business rule validation',
      'Widget Testing: UI component verification',
      'Static Analysis: Linting & code quality',
      'Debugging: Sentry & crashlytics monitoring'
    ],
  ),
  _Service(
    icon: FontAwesomeIcons.usersGear,
    title: 'PRODUCT\nLEADERSHIP',
    isHighlighted: false,
    modalTitle: 'Agile & Project Strategy',
    description: 'Managing the development lifecycle using modern methodologies. I help align technical execution with business goals and user needs.',
    bullets: [
      'Agile/Scrum: Jira & ClickUp management',
      'Documentation: PRDs & Technical writing',
      'System Design: Clean Architecture planning',
      'Collaboration: Cross-functional team alignment'
    ],
  ),
];

// ─── Main Section ─────────────────────────────────────────────────────────────

class ServicesSectionWidget extends StatefulWidget {
  const ServicesSectionWidget({super.key});
  @override State<ServicesSectionWidget> createState() => _ServicesSectionState();
}

class _ServicesSectionState extends State<ServicesSectionWidget>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic, reverseCurve: Curves.easeInCubic);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _ctrl.forward() : _ctrl.reverse();
  }

  void _openModal(_Service s) {
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
          child: _ServiceModal(service: s, animation: anim),
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
      padding: EdgeInsets.fromLTRB(hPad, 60, hPad, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(expanded: _expanded, onToggle: _toggle, isMobile: isMobile),
          SizedBox(height: isMobile ? 40 : 56),
          isMobile ? _mobileCards() : _desktopCards(context),
        ],
      ),
    );
  }

  Widget _desktopCards(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ScrollIndicatorColumn(),
        SizedBox(width: isTablet ? 20 : 40),
        Expanded(
          child: LayoutBuilder(builder: (context, c) {
            final cardW = (c.maxWidth - 32) / 3;
            final cardH = (MediaQuery.of(context).size.height * 0.38).clamp(260.0, 340.0);
            return Column(
              children: [
                _CardRow(services: _allServices.sublist(0,3), cardW: cardW, cardH: cardH, onTap: _openModal),
                AnimatedBuilder(
                  animation: _anim,
                  builder: (_, child) => ClipRect(
                    child: Align(heightFactor: _anim.value, alignment: Alignment.topCenter, child: child),
                  ),
                  child: Column(children: [
                    const SizedBox(height: 16),
                    _CardRow(services: _allServices.sublist(3,6), cardW: cardW, cardH: cardH, onTap: _openModal, slide: true, anim: _anim),
                  ]),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _mobileCards() {
    return Column(
      children: [
        ...List.generate(3, (i) => Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: _ServiceCard(service: _allServices[i], width: double.infinity, height: 220, onTap: () => _openModal(_allServices[i])),
        )),
        AnimatedBuilder(
          animation: _anim,
          builder: (_, child) => ClipRect(
            child: Align(heightFactor: _anim.value, alignment: Alignment.topCenter, child: child),
          ),
          child: Column(children: List.generate(3, (i) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _ServiceCard(service: _allServices[i+3], width: double.infinity, height: 220, onTap: () => _openModal(_allServices[i+3])),
          ))),
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
  const _Header({required this.expanded, required this.onToggle, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final btn = _AllServicesButton(expanded: expanded, onTap: onToggle);
    if (isMobile) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const _SectionLabel(), const SizedBox(height: 12),
        const _SectionTitle(), const SizedBox(height: 24),
        const _SectionDescription(), const SizedBox(height: 20),
        btn,
      ]);
    }
    // Desktop: label on top, then title on left | description + button on same row to the right
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const _SectionLabel(),
      const SizedBox(height: 14),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(),
          const SizedBox(width: 48),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(child: _SectionDescription()),
                const SizedBox(width: 28),
                btn,
              ],
            ),
          ),
        ],
      ),
    ]);
  }
}

// ─── Card Row ─────────────────────────────────────────────────────────────────

class _CardRow extends StatelessWidget {
  final List<_Service> services;
  final double cardW, cardH;
  final void Function(_Service) onTap;
  final bool slide;
  final Animation<double>? anim;
  const _CardRow({required this.services, required this.cardW, required this.cardH, required this.onTap, this.slide = false, this.anim});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(services.length, (i) {
        Widget card = _ServiceCard(service: services[i], width: cardW, height: cardH, onTap: () => onTap(services[i]));
        if (slide && anim != null) {
          card = AnimatedBuilder(animation: anim!, builder: (_, child) =>
              Transform.translate(offset: Offset(0, 28 * (1 - anim!.value)), child: child), child: card);
        }
        return Padding(padding: EdgeInsets.only(right: i < 2 ? 16 : 0), child: card);
      }),
    );
  }
}

// ─── Section Label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel();
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
    Container(width: 28, height: 1.2, color: Colors.black54),
    const SizedBox(width: 10),
    Text('MY Skills ?', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87, letterSpacing: 1.8)),
  ]);
}

// ─── Section Title ────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle();
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final fs = w < 600 ? 36.0 : w < 900 ? 44.0 : w < 1200 ? 52.0 : 62.0;
    return Text("WHAT I\nDO", style: GoogleFonts.dmSans(fontSize: fs, fontWeight: FontWeight.w800, color: Colors.black, height: 1.05, letterSpacing: -1.0));
  }
}

// ─── Section Description ──────────────────────────────────────────────────────

class _SectionDescription extends StatelessWidget {
  const _SectionDescription();
  @override
  Widget build(BuildContext context) => Text(
    'I leverage a diverse toolkit to build scalable applications. \nHere is the stack I use to bring digital products',
    style: GoogleFonts.dmSans(fontSize: 13.5, fontWeight: FontWeight.w400, color: Colors.black54, height: 1.7),
    maxLines: 3,
  );
}

// ─── All Services Button ──────────────────────────────────────────────────────

class _AllServicesButton extends StatefulWidget {
  final bool expanded;
  final VoidCallback onTap;
  const _AllServicesButton({required this.expanded, required this.onTap});
  @override State<_AllServicesButton> createState() => _AllServicesButtonState();
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
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        decoration: BoxDecoration(color: _hov ? const Color(0xFF333333) : Colors.black, borderRadius: BorderRadius.circular(50)),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: Text(
            widget.expanded ? 'CLOSE SKILLS' : 'ALL SKILLS',
            key: ValueKey(widget.expanded),
            style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 1.0),
          ),
        ),
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
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      RotatedBox(quarterTurns: 1, child: Text('SCROLL DOWN',
          style: GoogleFonts.dmSans(fontSize: 9, fontWeight: FontWeight.w600, color: Colors.black54, letterSpacing: 2.0))),
      const SizedBox(height: 12),
      Container(width: 1, height: 80, color: Colors.black26),
      const SizedBox(height: 16),
      const _DownArrowBtn(),
    ]),
  );
}

class _DownArrowBtn extends StatefulWidget {
  const _DownArrowBtn();
  @override State<_DownArrowBtn> createState() => _DownArrowBtnState();
}
class _DownArrowBtnState extends State<_DownArrowBtn> {
  bool _hov = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _hov = true),
    onExit: (_) => setState(() => _hov = false),
    cursor: SystemMouseCursors.click,
    child: GestureDetector(onTap: () {}, child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 44, height: 44,
      decoration: BoxDecoration(color: _hov ? const Color(0xFF333333) : Colors.black, shape: BoxShape.circle),
      child: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 22),
    )),
  );
}

// ─── Service Card ─────────────────────────────────────────────────────────────

class _ServiceCard extends StatefulWidget {
  final _Service service;
  final double width, height;
  final VoidCallback onTap;
  const _ServiceCard({required this.service, required this.width, required this.height, required this.onTap});
  @override State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 280));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    if (widget.service.isHighlighted) _ctrl.value = 1.0;
  }

  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _ctrl.forward(),
      onExit: (_) { if (!widget.service.isHighlighted) _ctrl.reverse(); },
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _anim,
          builder: (_, _) {
            final v = _anim.value;
            final bg   = Color.lerp(Colors.white, Colors.black, v)!;
            final fg   = Color.lerp(Colors.black, Colors.white, v)!;
            final fgs  = Color.lerp(Colors.black54, Colors.white70, v)!;
            final bord = Color.lerp(const Color(0xFFCCCCCC), Colors.black, v)!;
            return Container(
              width: widget.width == double.infinity ? null : widget.width,
              height: widget.height,
              decoration: BoxDecoration(color: bg, border: Border.all(color: bord, width: 1.2)),
              padding: const EdgeInsets.all(26),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                FaIcon(widget.service.icon, size: 32, color: fg),
                const Spacer(),
                Text(widget.service.title, style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w700, color: fg, height: 1.25, letterSpacing: 0.2)),
                const SizedBox(height: 16),
                Row(children: [
                  Text('READ MORE', style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w700, color: fgs, letterSpacing: 1.4)),
                  const SizedBox(width: 6),
                  Icon(Icons.arrow_forward_rounded, size: 12, color: fgs),
                ]),
              ]),
            );
          },
        ),
      ),
    );
  }
}

// ─── Glass Modal ──────────────────────────────────────────────────────────────

class _ServiceModal extends StatelessWidget {
  final _Service service;
  final Animation<double> animation;
  const _ServiceModal({required this.service, required this.animation});

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.of(context).size;
    final isMobile = sz.width < 600;

    return Stack(children: [
      // ── Full-screen blur backdrop (same technique as navbar) ──────────────
      Positioned.fill(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
              child: Container(
                // Very faint dark tint — content stays visible but blurred, like navbar
                color: Colors.black.withValues(alpha: 0.22),
              ),
            ),
          ),
        ),
      ),

      // ── Centered modal card ───────────────────────────────────────────────
      Center(
        child: ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: GestureDetector(
            onTap: () {}, // prevent backdrop tap bubbling through card
            child: Container(
              width: isMobile ? sz.width * 0.92 : (sz.width * 0.46).clamp(380.0, 580.0),
              constraints: BoxConstraints(maxHeight: sz.height * 0.84),
              margin: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                // NO white fill — pure frosted panel, content shows through blurred
                color: Colors.white.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.22),
                  width: 1.0,
                ),
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
                    // Second layer: barely-there overlay so text stays readable
                    color: Colors.white.withValues(alpha: 0.08),
                    child: _ModalContent(service: service, isMobile: isMobile),
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
  final _Service service;
  final bool isMobile;
  const _ModalContent({required this.service, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final pad = isMobile ? 24.0 : 40.0;
    return SingleChildScrollView(
      padding: EdgeInsets.all(pad),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        // Icon + close
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: Colors.white.withValues(alpha: 0.25), width: 1),
            ),
            child: Center(child: FaIcon(service.icon, size: 22, color: Colors.white)),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
                ),
                child: const Icon(Icons.close_rounded, size: 17, color: Colors.white),
              ),
            ),
          ),
        ]),

        SizedBox(height: isMobile ? 20 : 26),

        Text(service.modalTitle, style: GoogleFonts.dmSans(
          fontSize: isMobile ? 21 : 27, fontWeight: FontWeight.w800,
          color: Colors.white, height: 1.15, letterSpacing: -0.4,
        )),
        const SizedBox(height: 14),
        Container(height: 1, color: Colors.white.withValues(alpha: 0.2)),
        const SizedBox(height: 18),

        Text(service.description, style: GoogleFonts.dmSans(
          fontSize: isMobile ? 13.5 : 14.5,
          color: Colors.white.withValues(alpha: 0.82), height: 1.72,
        )),
        const SizedBox(height: 22),

        ...service.bullets.map((b) => Padding(
          padding: const EdgeInsets.only(bottom: 11),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 5, height: 5,
              margin: const EdgeInsets.only(top: 8, right: 12),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.7), shape: BoxShape.circle),
            ),
            Expanded(child: Text(b, style: GoogleFonts.dmSans(
              fontSize: isMobile ? 13 : 14, fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.88), height: 1.5,
            ))),
          ]),
        )),

        const SizedBox(height: 26),
        _ModalCta(),
      ]),
    );
  }
}

class _ModalCta extends StatefulWidget {
  @override State<_ModalCta> createState() => _ModalCtaState();
}
class _ModalCtaState extends State<_ModalCta> {
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
        width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: _hov ? Colors.white.withValues(alpha: 0.25) : Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 1),
        ),
        child: Center(child: Text('GET IN TOUCH', style: GoogleFonts.dmSans(
          fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 1.2,
        ))),
      ),
    ),
  );
}