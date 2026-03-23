// lib/features/widgets/hero/hero_skills_bar.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Data ─────────────────────────────────────────────────────────────────────

class _Skill {
  final String name;
  final _SkillType type;
  const _Skill(this.name, this.type);
}

enum _SkillType { featured, primary, normal }

const _row1 = [
  _Skill('Flutter',            _SkillType.featured),
  _Skill('Dart',               _SkillType.primary),
  _Skill('BLoC',               _SkillType.primary),
  _Skill('Provider',           _SkillType.primary),
  _Skill('Firebase',           _SkillType.featured),
  _Skill('Supabase',           _SkillType.primary),
  _Skill('iOS',                _SkillType.primary),
  _Skill('Android',            _SkillType.primary),
  _Skill('Clean Architecture', _SkillType.primary),
  _Skill('REST APIs',          _SkillType.primary),
  _Skill('GraphQL',            _SkillType.primary),
];

const _row2 = [
  _Skill('CI/CD',              _SkillType.primary),
  _Skill('GitHub Actions',     _SkillType.primary),
  _Skill('Git',                _SkillType.primary),
  _Skill('Platform Channels',  _SkillType.featured),
  _Skill('Performance tuning', _SkillType.primary),
  _Skill('Widget profiling',   _SkillType.primary),
  _Skill('Native integration', _SkillType.primary),
  _Skill('Automated testing',  _SkillType.primary),
  _Skill('Real-time systems',  _SkillType.featured),
  _Skill('State management',   _SkillType.primary),
];

// ─── Colors ───────────────────────────────────────────────────────────────────

const _bg         = Color(0xFF0A0A0A);
const _textMuted  = Color(0xFF6B6B6B);
const _textBright = Color(0xFFF0EDE8);
const _accent     = Color(0xFF4F7DF5);
const _rule       = Color(0x12FFFFFF);

// ─── Snowflake particle ────────────────────────────────────────────────────────

class _Flake {
  double x;      // 0..1 normalized
  double y;      // 0..1 normalized
  double size;
  double speed;  // normalized per second
  double drift;  // horizontal drift per second (normalized)
  double opacity;

  _Flake({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.drift,
    required this.opacity,
  });
}

// ─── Main Widget ──────────────────────────────────────────────────────────────

class SkillsTickerWidget extends StatefulWidget {
  const SkillsTickerWidget({super.key});

  @override
  State<SkillsTickerWidget> createState() => _SkillsTickerWidgetState();
}

class _SkillsTickerWidgetState extends State<SkillsTickerWidget>
    with TickerProviderStateMixin {
  late AnimationController _ctrl1;
  late AnimationController _ctrl2;
  late AnimationController _snowCtrl;
  late Animation<double>   _anim1;
  late Animation<double>   _anim2;

  final _rng    = Random(42);
  final _flakes = <_Flake>[];
  static const _flakeCount = 55;

  @override
  void initState() {
    super.initState();

    // Marquee controllers
    _ctrl1 = AnimationController(vsync: this, duration: const Duration(seconds: 28))..repeat();
    _ctrl2 = AnimationController(vsync: this, duration: const Duration(seconds: 22))..repeat();
    _anim1 = Tween<double>(begin: 0, end: 1).animate(_ctrl1);
    _anim2 = Tween<double>(begin: 0, end: 1).animate(_ctrl2);

    // Snow controller — drives delta time via value 0→1 in 60s, repeat
    _snowCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 60))..repeat();

    // Seed flakes at random positions
    for (int i = 0; i < _flakeCount; i++) {
      _flakes.add(_Flake(
        x:       _rng.nextDouble(),
        y:       _rng.nextDouble(),          // start scattered, not just from top
        size:    _rng.nextDouble() * 2.5 + 0.8,
        speed:   _rng.nextDouble() * 0.018 + 0.006,
        drift:   (_rng.nextDouble() - 0.5) * 0.008,
        opacity: _rng.nextDouble() * 0.35 + 0.08,
      ));
    }
  }

  @override
  void dispose() {
    _ctrl1.dispose();
    _ctrl2.dispose();
    _snowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _bg,
      child: Stack(
        children: [

          // ── Snowfall layer ─────────────────────────────────────────────
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _snowCtrl,
              builder: (_, __) {
                // Advance each flake
                for (final f in _flakes) {
                  f.y += f.speed;
                  f.x += f.drift;
                  if (f.y > 1.05) {
                    f.y = -0.05;
                    f.x = _rng.nextDouble();
                  }
                  if (f.x < 0) f.x = 1.0;
                  if (f.x > 1) f.x = 0.0;
                }
                return CustomPaint(
                  painter: _SnowPainter(flakes: List.unmodifiable(_flakes)),
                );
              },
            ),
          ),

          // ── Ticker content ────────────────────────────────────────────
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(height: 1, color: _rule),

              // Label
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: _rule)),
                ),
                child: Text(
                  'CORE SKILLS',
                  style: GoogleFonts.dmSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.12 * 10,
                    color: _textBright.withOpacity(0.6),
                  ),
                ),
              ),

              // Row 1 — scrolls left
              _MarqueeRow(
                skills:    _row1,
                animation: _anim1,
                direction: _ScrollDirection.left,
              ),

              Container(height: 1, color: _rule),

              // Row 2 — scrolls right
              _MarqueeRow(
                skills:    _row2,
                animation: _anim2,
                direction: _ScrollDirection.right,
              ),

              Container(height: 1, color: _rule),

              // Footer label
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: _rule)),
                ),
                child: Text(
                  '5 yrs software · 3 yrs Flutter · iOS & Android',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.dmSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.12 * 10,
                    color: _textBright.withOpacity(0.6),
                  ),
                ),
              ),

              Container(height: 1, color: _rule),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Snow Painter ─────────────────────────────────────────────────────────────

class _SnowPainter extends CustomPainter {
  final List<_Flake> flakes;
  const _SnowPainter({required this.flakes});

  @override
  void paint(Canvas canvas, Size size) {
    for (final f in flakes) {
      final paint = Paint()
        ..color = Colors.white.withOpacity(f.opacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(f.x * size.width, f.y * size.height),
        f.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_SnowPainter old) => true;
}

// ─── Marquee Row ──────────────────────────────────────────────────────────────

enum _ScrollDirection { left, right }

class _MarqueeRow extends StatefulWidget {
  final List<_Skill>      skills;
  final Animation<double> animation;
  final _ScrollDirection  direction;

  const _MarqueeRow({
    required this.skills,
    required this.animation,
    required this.direction,
  });

  @override
  State<_MarqueeRow> createState() => _MarqueeRowState();
}

class _MarqueeRowState extends State<_MarqueeRow> {
  bool _paused = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _paused = true),
      onExit:  (_) => setState(() => _paused = false),
      child: SizedBox(
        height: 48,
        child: AnimatedBuilder(
          animation: widget.animation,
          builder: (_, __) => _MarqueeTrack(
            skills:    widget.skills,
            progress:  widget.animation.value,
            direction: widget.direction,
            paused:    _paused,
          ),
        ),
      ),
    );
  }
}

// ─── Marquee Track ────────────────────────────────────────────────────────────

class _MarqueeTrack extends StatelessWidget {
  final List<_Skill>     skills;
  final double           progress;
  final _ScrollDirection direction;
  final bool             paused;

  const _MarqueeTrack({
    required this.skills,
    required this.progress,
    required this.direction,
    required this.paused,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      return ClipRect(
        child: Stack(
          children: [
            _ScrollingSkills(
              skills:    skills,
              progress:  progress,
              direction: direction,
              viewWidth: w,
            ),
            // Left fade
            Positioned(
              left: 0, top: 0, bottom: 0, width: 80,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [_bg, Color(0x000A0A0A)]),
                ),
              ),
            ),
            // Right fade
            Positioned(
              right: 0, top: 0, bottom: 0, width: 80,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0x000A0A0A), _bg]),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ─── Scrolling Skills ─────────────────────────────────────────────────────────

class _ScrollingSkills extends StatelessWidget {
  final List<_Skill>     skills;
  final double           progress;
  final _ScrollDirection direction;
  final double           viewWidth;

  const _ScrollingSkills({
    required this.skills,
    required this.progress,
    required this.direction,
    required this.viewWidth,
  });

  @override
  Widget build(BuildContext context) {
    final doubled = [...skills, ...skills];

    double oneSetWidth = 0;
    for (final skill in skills) {
      oneSetWidth += _skillItemWidth(skill.name);
    }

    final raw    = progress * oneSetWidth;
    final offset = direction == _ScrollDirection.left
        ? -raw
        : -(oneSetWidth - raw);

    return OverflowBox(
      alignment: Alignment.centerLeft,
      minWidth:  0,
      maxWidth:  double.infinity,
      child: Transform.translate(
        offset: Offset(offset, 0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: doubled.map((s) => _SkillItem(skill: s)).toList(),
        ),
      ),
    );
  }

  double _skillItemWidth(String name) =>
      name.length * 8.0 + 56 + 16 + 15;
}

// ─── Skill Item ───────────────────────────────────────────────────────────────

class _SkillItem extends StatefulWidget {
  final _Skill skill;
  const _SkillItem({required this.skill});

  @override
  State<_SkillItem> createState() => _SkillItemState();
}

class _SkillItemState extends State<_SkillItem> {
  bool _hov = false;

  Color get _dotColor {
    if (_hov) return _accent;
    switch (widget.skill.type) {
      case _SkillType.featured: return _accent;
      case _SkillType.primary:  return _textBright;
      case _SkillType.normal:   return _textMuted;
    }
  }

  Color get _textColor {
    if (_hov) return _textBright;
    switch (widget.skill.type) {
      case _SkillType.featured: return _accent;
      case _SkillType.primary:  return _textBright;
      case _SkillType.normal:   return _textMuted;
    }
  }

  FontWeight get _fontWeight {
    switch (widget.skill.type) {
      case _SkillType.featured: return FontWeight.w500;
      case _SkillType.primary:  return FontWeight.w500;
      case _SkillType.normal:   return FontWeight.w400;
    }
  }

  double get _fontSize {
    switch (widget.skill.type) {
      case _SkillType.featured: return 14;
      case _SkillType.primary:  return 14;
      case _SkillType.normal:   return 13;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit:  (_) => setState(() => _hov = false),
      cursor: SystemMouseCursors.basic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: _hov ? _accent.withOpacity(0.12) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 5, height: 5,
              decoration: BoxDecoration(color: _dotColor, shape: BoxShape.circle),
            ),
            const SizedBox(width: 10),
            Text(
              widget.skill.name,
              style: GoogleFonts.dmSans(
                fontSize: _fontSize,
                fontWeight: _fontWeight,
                color: _textColor,
                letterSpacing: 0.02 * _fontSize,
              ),
            ),
            const SizedBox(width: 28),
            Container(width: 1, height: 16, color: _rule),
          ],
        ),
      ),
    );
  }
}