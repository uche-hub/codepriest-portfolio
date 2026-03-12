// lib/features/home/widgets/testimonials_section_widget.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/responsive_helper.dart';

class _Testimonial {
  final String quote;
  final String name;
  final String role;
  final String imagePath;
  final Color imageBg;
  const _Testimonial({required this.quote, required this.name, required this.role, required this.imagePath, required this.imageBg});
}

const _testimonials = [
  _Testimonial(
    quote: '"I just wanted to share a quick note and let you know that you guys do a really good job."',
    name: 'Rohan Sing', role: 'Project Manager, Airflow Tech Inc',
    imagePath: 'assets/images/client1.png', imageBg: Color(0xFFD0D0D0),
  ),
  _Testimonial(
    quote: '"Working with Uchenna was an absolute pleasure. The designs exceeded our expectations and shipped on time."',
    name: 'Amara Osei', role: 'CEO, Horizon Ventures',
    imagePath: 'assets/images/client2.png', imageBg: Color(0xFFCCDDEE),
  ),
  _Testimonial(
    quote: '"The attention to detail and user-first thinking transformed our product. Retention went up 35% in a month."',
    name: 'Lena Fischer', role: 'Head of Product, Pipefy',
    imagePath: 'assets/images/client3.png', imageBg: Color(0xFFE8E0D5),
  ),
  _Testimonial(
    quote: '"Truly one of the best designers I\'ve worked with. Creative, fast, and communicates really well under pressure."',
    name: 'James Okafor', role: 'CTO, Kuda Bank',
    imagePath: 'assets/images/client4.png', imageBg: Color(0xFFDDEEDD),
  ),
];

class TestimonialsSectionWidget extends StatefulWidget {
  const TestimonialsSectionWidget({super.key});
  @override State<TestimonialsSectionWidget> createState() => _TestimonialsState();
}

class _TestimonialsState extends State<TestimonialsSectionWidget> {
  final PageController _pc = PageController();
  int _current = 0;

  @override void dispose() { _pc.dispose(); super.dispose(); }

  void _goTo(int i) { _pc.animateToPage(i, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut); }

  @override
  Widget build(BuildContext context) {
    final hPad = ResponsiveHelper.getHorizontalPadding(context);
    final isMobile = ResponsiveHelper.isMobile(context);
    final screenH = MediaQuery.of(context).size.height;
    final cardH = isMobile ? 520.0 : (screenH * 0.72).clamp(480.0, 640.0);

    return Container(
      color: Colors.white,
      child: Column(children: [
        SizedBox(
          height: cardH,
          child: PageView.builder(
            controller: _pc,
            onPageChanged: (i) => setState(() => _current = i),
            itemCount: _testimonials.length,
            itemBuilder: (_, i) => _TestimonialCard(
              t: _testimonials[i], hPad: hPad, isMobile: isMobile, cardH: cardH,
            ),
          ),
        ),
        // Dot indicators
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(_testimonials.length, (i) {
              final active = i == _current;
              return GestureDetector(
                onTap: () => _goTo(i),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOut,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: active ? 28 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active ? Colors.black : Colors.black26,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ]),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final _Testimonial t;
  final double hPad, cardH;
  final bool isMobile;
  const _TestimonialCard({required this.t, required this.hPad, required this.isMobile, required this.cardH});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(hPad, 40, hPad, 24),
      child: isMobile ? _buildMobile() : _buildDesktop(),
    );
  }

  Widget _buildDesktop() {
    return Stack(children: [
      // Top-right X mark
      Positioned(top: 0, right: 0, child: const _XMark()),
      // Bottom-left worm waves
      Positioned(bottom: 20, left: 0, child: const _WormWaves()),

      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Label
        _FeedbackLabel(),
        const SizedBox(height: 28),
        // Big quote
        Expanded(child: _QuoteText(quote: t.quote)),
        // Bottom row: author info + star image
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          _AuthorInfo(t: t),
          const Spacer(),
          _StarImage(t: t, size: 220),
        ]),
      ]),
    ]);
  }

  Widget _buildMobile() {
    return Stack(children: [
      Positioned(top: 0, right: 0, child: const _XMark()),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _FeedbackLabel(),
        const SizedBox(height: 20),
        _QuoteText(quote: t.quote),
        const Spacer(),
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Expanded(child: _AuthorInfo(t: t)),
          const SizedBox(width: 16),
          _StarImage(t: t, size: 140),
        ]),
        const SizedBox(height: 8),
        const _WormWaves(),
      ]),
    ]);
  }
}

class _FeedbackLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('CLIENT FEEDBACK', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 2.0, color: Colors.black87)),
      const SizedBox(height: 4),
      Container(width: 120, height: 1.2, color: Colors.black),
    ]);
  }
}

class _QuoteText extends StatelessWidget {
  final String quote;
  const _QuoteText({required this.quote});
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final fs = w < 600 ? 22.0 : w < 900 ? 30.0 : w < 1200 ? 38.0 : 46.0;
    return Text(quote, style: GoogleFonts.dmSans(fontSize: fs, fontWeight: FontWeight.w800, color: Colors.black, height: 1.25, letterSpacing: -0.5));
  }
}

class _AuthorInfo extends StatelessWidget {
  final _Testimonial t;
  const _AuthorInfo({required this.t});
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      Text(t.name, style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black)),
      const SizedBox(height: 4),
      Text(t.role, style: GoogleFonts.dmSans(fontSize: 13, color: Colors.black54)),
      const SizedBox(height: 12),
      CustomPaint(size: const Size(160, 24), painter: _WormLinePainter()),
    ]);
  }
}

class _WormLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final amp = size.height * 0.35;
    final waveLen = size.width / 5;
    path.moveTo(0, size.height / 2);
    for (double x = 0; x < size.width; x += waveLen) {
      path.cubicTo(x + waveLen * 0.3, size.height / 2 - amp, x + waveLen * 0.7, size.height / 2 + amp, x + waveLen, size.height / 2);
    }
    canvas.drawPath(path, Paint()..color = Colors.black..strokeWidth = 1.8..style = PaintingStyle.stroke..strokeCap = StrokeCap.round);
  }
  @override bool shouldRepaint(_) => false;
}

class _WormWaves extends StatelessWidget {
  const _WormWaves();
  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(120, 36), painter: _ThreeWavesPainter());
  }
}

class _ThreeWavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    for (int row = 0; row < 3; row++) {
      final y = size.height * (row + 1) / 4;
      final path = Path();
      final amp = 4.0;
      final waveLen = size.width / 4;
      path.moveTo(0, y);
      for (double x = 0; x < size.width; x += waveLen) {
        path.cubicTo(x + waveLen * 0.3, y - amp, x + waveLen * 0.7, y + amp, x + waveLen, y);
      }
      canvas.drawPath(path, Paint()..color = Colors.black.withValues(alpha: 0.28)..strokeWidth = 1.4..style = PaintingStyle.stroke..strokeCap = StrokeCap.round);
    }
  }
  @override bool shouldRepaint(_) => false;
}

class _XMark extends StatelessWidget {
  const _XMark();
  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(42, 42), painter: _XMarkPainter());
  }
}

class _XMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black..strokeWidth = 2.2..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    final pad = size.width * 0.1;
    // Draw X as two crossing lines with rounded ends — like the screenshot
    canvas.drawLine(Offset(pad, pad), Offset(size.width - pad, size.height - pad), paint);
    canvas.drawLine(Offset(size.width - pad, pad), Offset(pad, size.height - pad), paint);
  }
  @override bool shouldRepaint(_) => false;
}

class _StarImage extends StatelessWidget {
  final _Testimonial t;
  final double size;
  const _StarImage({required this.t, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipPath(
        clipper: _StarClipper(),
        child: Image.asset(
          t.imagePath,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Container(
            color: t.imageBg,
            child: Center(child: Icon(Icons.person, size: size * 0.4, color: Colors.white54)),
          ),
        ),
      ),
    );
  }
}

class _StarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final cx = size.width / 2, cy = size.height / 2;
    final outer = size.width * 0.5, inner = size.width * 0.21;
    const points = 6;
    final path = Path();
    for (int i = 0; i < points * 2; i++) {
      final r = i.isEven ? outer : inner;
      final angle = (i * pi / points) - pi / 2;
      final x = cx + r * cos(angle), y = cy + r * sin(angle);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    return path;
  }
  @override bool shouldReclip(_) => false;
}