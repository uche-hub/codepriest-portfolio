// lib/features/home/widgets/value_proposition_widget.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../core/constants/responsive_helper.dart';

// ─── Data ─────────────────────────────────────────────────────────────────────

class _ValueCard {
  final String number;
  final String outcome;
  final String how;
  final List<String> pills;
  final bool wide;

  const _ValueCard({
    required this.number,
    required this.outcome,
    required this.how,
    required this.pills,
    this.wide = false,
  });
}

const _cards = [
  _ValueCard(
    number: '01',
    outcome: 'Scalable app architecture',
    how: 'State stays predictable as your product grows — no spaghetti, no costly rewrites six months in.',
    pills: ['BLoC', 'Provider', 'Clean Architecture', 'Riverpod'],
  ),
  _ValueCard(
    number: '02',
    outcome: 'Real-time, secure backends',
    how: 'Live data, auth flows, and APIs that connect reliably without compromising security.',
    pills: ['Firebase', 'Supabase', 'REST / GraphQL'],
  ),
  _ValueCard(
    number: '03',
    outcome: 'Apps that feel fast',
    how: 'Smooth 60fps UX, lean builds, and reduced load times — performance your users actually feel.',
    pills: ['Performance tuning', 'Widget profiling', 'Build optimisation'],
  ),
  _ValueCard(
    number: '04',
    outcome: 'Ship with confidence',
    how: 'Automated pipelines mean fewer production surprises and faster, safer release cycles.',
    pills: ['CI/CD', 'GitHub Actions', 'Automated testing'],
  ),
  _ValueCard(
    number: '05',
    outcome: 'Full native device access',
    how: 'Camera, biometrics, Bluetooth, sensors — if the device can do it, the app can too, without sacrificing the cross-platform advantage.',
    pills: ['Platform Channels', 'iOS SDKs', 'Android SDKs', 'Native Integration'],
  ),
  _ValueCard(
    number: '06',
    outcome: 'Testing & Quality',
    how: 'Ensuring software reliability through rigorous testing. I focus on catching bugs early to deliver a polished, crash-free user experience.',
    pills: ['Unit Testing', 'Widget Testing', 'Static Analysis', 'Crashlytics'],
  ),
];

const _stats = [
  ('6',  'Years in software'),
  ('4',  'Years Flutter'),
  ('2',  'Platforms, one codebase'),
];

// ─── Main Widget ──────────────────────────────────────────────────────────────

class ValuePropositionWidget extends StatefulWidget {
  const ValuePropositionWidget({super.key});

  @override
  State<ValuePropositionWidget> createState() => _ValuePropositionWidgetState();
}

class _ValuePropositionWidgetState extends State<ValuePropositionWidget>
    with SingleTickerProviderStateMixin {
  bool _visible = false;
  late AnimationController _ctrl;

  // Staggered animations per block
  late Animation<double> _eyebrowAnim;
  late Animation<double> _headlineAnim;
  late Animation<double> _bodyAnim;
  late Animation<double> _gridAnim;
  late Animation<double> _statsAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    Animation<double> _interval(double s, double e) => CurvedAnimation(
      parent: _ctrl,
      curve: Interval(s, e, curve: Curves.easeOutCubic),
    );

    _eyebrowAnim  = _interval(0.00, 0.30);
    _headlineAnim = _interval(0.10, 0.42);
    _bodyAnim     = _interval(0.20, 0.52);
    _gridAnim     = _interval(0.32, 0.72);
    _statsAnim    = _interval(0.55, 0.90);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _fadeSlide(Animation<double> anim, Widget child) => FadeTransition(
    opacity: anim,
    child: SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.12),
        end: Offset.zero,
      ).animate(anim),
      child: child,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final hPad    = ResponsiveHelper.getHorizontalPadding(context);
    final isMob   = ResponsiveHelper.isMobile(context);

    return VisibilityDetector(
      key: const Key('value-prop-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.08 && !_visible) {
          setState(() => _visible = true);
          _ctrl.forward();
        }
      },
      child: Container(
        //color: const Color(0xFFFAF9F7),
        padding: EdgeInsets.fromLTRB(hPad, 80, hPad, 80),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 780),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Eyebrow ───────────────────────────────────────────────────
              _fadeSlide(_eyebrowAnim, const _Eyebrow()),
              const SizedBox(height: 24),

              // ── Headline ──────────────────────────────────────────────────
              _fadeSlide(_headlineAnim, _Headline(isMobile: isMob)),
              const SizedBox(height: 20),

              // ── Body copy ─────────────────────────────────────────────────
              _fadeSlide(_bodyAnim, const _BodyCopy()),
              const SizedBox(height: 32),

              // ── Rule ──────────────────────────────────────────────────────
              _fadeSlide(_bodyAnim,
                Container(height: 1, color: Colors.black.withOpacity(0.08)),
              ),
              const SizedBox(height: 32),

              // ── Value grid ────────────────────────────────────────────────
              _fadeSlide(_gridAnim, _ValueGrid(isMobile: isMob)),
              const SizedBox(height: 32),

              // ── Experience bar ────────────────────────────────────────────
              _fadeSlide(_statsAnim, const _ExpBar()),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Eyebrow ──────────────────────────────────────────────────────────────────

class _Eyebrow extends StatelessWidget {
  const _Eyebrow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 24, height: 1, color: const Color(0xFF1A4FD6)),
        const SizedBox(width: 8),
        Text(
          'Skill Sets',
          style: GoogleFonts.dmSans(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1 * 11,
            color: const Color(0xFF1A4FD6),
          ),
        ),
      ],
    );
  }
}

// ─── Headline ─────────────────────────────────────────────────────────────────

class _Headline extends StatelessWidget {
  final bool isMobile;
  const _Headline({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final fs = isMobile ? 28.0 : 40.0;
    return RichText(
      text: TextSpan(
        style: GoogleFonts.dmSans(
          fontSize: fs,
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
    );
  }
}

// ─── Body Copy ────────────────────────────────────────────────────────────────

class _BodyCopy extends StatelessWidget {
  const _BodyCopy();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 560),
      child: Text(
        'From a single codebase, I deliver iOS and Android apps with real-time backends, smooth performance, and the reliability that keeps users coming back — and engineering teams sane.',
        style: GoogleFonts.dmSans(
          fontSize: 16,
          fontWeight: FontWeight.w300,
          color: const Color(0xFF4A4A4A),
          height: 1.8,
        ),
      ),
    );
  }
}

// ─── Value Grid ───────────────────────────────────────────────────────────────

class _ValueGrid extends StatelessWidget {
  final bool isMobile;
  const _ValueGrid({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    // Cards 01–04: 2-col grid; card 05: full width below
    final regular = _cards.where((c) => !c.wide).toList();
    final wide    = _cards.where((c) => c.wide).toList();

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black.withOpacity(0.08)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // 2-col grid (or 1-col on mobile)
            isMobile
                ? Column(
              children: regular.asMap().entries.map((e) => _CardTile(
                card: e.value,
                showBottomBorder: true,
              )).toList(),
            )
                : _TwoColGrid(cards: regular),

            // Wide card(s)
            ...wide.map((c) => _CardTile(card: c, wide: true, showBottomBorder: false)),
          ],
        ),
      ),
    );
  }
}

class _TwoColGrid extends StatelessWidget {
  final List<_ValueCard> cards;
  const _TwoColGrid({required this.cards});

  @override
  Widget build(BuildContext context) {
    // Pair up cards into rows of 2
    final rows = <List<_ValueCard>>[];
    for (int i = 0; i < cards.length; i += 2) {
      rows.add([
        cards[i],
        if (i + 1 < cards.length) cards[i + 1],
      ]);
    }

    return Column(
      children: rows.asMap().entries.map((rowEntry) {
        final row     = rowEntry.value;
        final isLast  = rowEntry.key == rows.length - 1;
        return Container(
          decoration: BoxDecoration(
            border: isLast
                ? null
                : Border(bottom: BorderSide(color: Colors.black.withOpacity(0.08))),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _CardTile(card: row[0], showBottomBorder: false)),
                if (row.length > 1) ...[
                  Container(width: 1, color: Colors.black.withOpacity(0.08)),
                  Expanded(child: _CardTile(card: row[1], showBottomBorder: false)),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─── Card Tile ────────────────────────────────────────────────────────────────

class _CardTile extends StatefulWidget {
  final _ValueCard card;
  final bool wide;
  final bool showBottomBorder;
  const _CardTile({
    required this.card,
    this.wide = false,
    required this.showBottomBorder,
  });

  @override
  State<_CardTile> createState() => _CardTileState();
}

class _CardTileState extends State<_CardTile> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    final isMob = ResponsiveHelper.isMobile(context);

    final content = MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit:  (_) => setState(() => _hov = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        color: _hov ? Colors.white : const Color(0xFFFAF9F7),
        padding: const EdgeInsets.all(24),
        child: widget.wide && !isMob
            ? _wideContent()
            : _normalContent(),
      ),
    );

    if (widget.showBottomBorder) {
      return Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.black.withOpacity(0.08)),
          ),
        ),
        child: content,
      );
    }
    return content;
  }

  Widget _normalContent() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _cardNumber(),
      const SizedBox(height: 12),
      _outcome(),
      const SizedBox(height: 8),
      _how(),
      const SizedBox(height: 16),
      _pillRow(),
    ],
  );

  Widget _wideContent() => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cardNumber(),
            const SizedBox(height: 12),
            _outcome(),
            const SizedBox(height: 8),
            _how(),
          ],
        ),
      ),
      const SizedBox(width: 24),
      Container(width: 1, color: Colors.black.withOpacity(0.08)),
      const SizedBox(width: 24),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: _pillRow(),
        ),
      ),
    ],
  );

  Widget _cardNumber() => Text(
    widget.card.number,
    style: GoogleFonts.dmSerifDisplay(
      fontSize: 11,
      color: const Color(0xFF8A8A8A),
      letterSpacing: 0.05 * 11,
    ),
  );

  Widget _outcome() => Text(
    widget.card.outcome,
    style: GoogleFonts.dmSans(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF0F0F0F),
      height: 1.3,
    ),
  );

  Widget _how() => Text(
    widget.card.how,
    style: GoogleFonts.dmSans(
      fontSize: 13,
      fontWeight: FontWeight.w300,
      color: const Color(0xFF4A4A4A),
      height: 1.65,
    ),
  );

  Widget _pillRow() => Wrap(
    spacing: 5,
    runSpacing: 5,
    children: widget.card.pills.map((p) => _Pill(label: p, hovered: _hov)).toList(),
  );
}

// ─── Pill ─────────────────────────────────────────────────────────────────────

class _Pill extends StatelessWidget {
  final String label;
  final bool hovered;
  const _Pill({required this.label, required this.hovered});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: hovered
            ? const Color(0xFFDCE6F8)
            : const Color(0xFFE8EEFB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: hovered
              ? const Color(0xFF1A4FD6).withOpacity(0.35)
              : const Color(0xFF1A4FD6).withOpacity(0.20),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF1A4FD6),
          letterSpacing: 0.01 * 11,
        ),
      ),
    );
  }
}

// ─── Experience Bar ───────────────────────────────────────────────────────────

class _ExpBar extends StatelessWidget {
  const _ExpBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.black.withOpacity(0.08))),
      ),
      child: Wrap(
        spacing: 0,
        runSpacing: 16,
        children: [
          for (int i = 0; i < _stats.length; i++) ...[
            _StatItem(num: _stats[i].$1, label: _stats[i].$2),
            if (i < _stats.length - 1)
              Container(
                width: 1,
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                color: Colors.black.withOpacity(0.08),
              ),
          ],
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String num;
  final String label;
  const _StatItem({required this.num, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          num,
          style: GoogleFonts.dmSerifDisplay(
            fontSize: 28,
            color: const Color(0xFF0F0F0F),
            height: 1,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w300,
            color: const Color(0xFF8A8A8A),
          ),
        ),
      ],
    );
  }
}