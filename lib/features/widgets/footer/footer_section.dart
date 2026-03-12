// lib/features/home/widgets/footer_widget.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/responsive_helper.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  static const _socials = [
    ('Medium', 'https://medium.com/@ucj.justice'),
    ('LinkedIn', 'https://www.linkedin.com/in/uchenna-ndukwe-008953160/'),
    ('X', 'https://x.com/cpri3st?s=21'),
    ('GitHub',  'https://github.com/uche-hub'),
  ];

  @override
  Widget build(BuildContext context) {
    final hPad = ResponsiveHelper.getHorizontalPadding(context);
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(hPad, 40, hPad, 32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Star mark
        const _StarMark(size: 42),
        const SizedBox(height: 20),
        // Thin full-width line
        const Divider(color: Color(0xFFCCCCCC), thickness: 0.9, height: 1),
        const SizedBox(height: 20),
        // Bottom row
        isMobile ? _buildMobile() : _buildDesktop(),
      ]),
    );
  }

  Widget _buildDesktop() {
    return Row(
      children: [
        // Social links
        Row(children: _socials.map((s) {
          final isLast = s == _socials.last;
          return Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 28),
            child: _FooterLink(label: s.$1, url: s.$2),
          );
        }).toList()),
        const Spacer(),
        // Copyright
        Text('Uchenna | Personal portfolio©2026',
            style: GoogleFonts.dmSans(fontSize: 13, color: Colors.black54)),
      ],
    );
  }

  Widget _buildMobile() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Wrap(spacing: 24, runSpacing: 12, children: _socials.map((s) =>
          _FooterLink(label: s.$1, url: s.$2)).toList()),
      const SizedBox(height: 20),
      Text('Uchenna | Personal portfolio©2026',
          style: GoogleFonts.dmSans(fontSize: 12, color: Colors.black54)),
    ]);
  }
}

class _FooterLink extends StatefulWidget {
  final String label, url;
  const _FooterLink({required this.label, required this.url});
  @override State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hov = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _hov = true),
    onExit:  (_) => setState(() => _hov = false),
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTap: () => launchUrl(Uri.parse(widget.url)),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 160),
        opacity: _hov ? 0.5 : 1.0,
        child: Text(widget.label,
            style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87)),
      ),
    ),
  );
}

// Star mark (asterisk/snowflake shape from screenshot)
class _StarMark extends StatelessWidget {
  final double size;
  const _StarMark({required this.size});
  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size(size, size), painter: _StarMarkPainter());
}

class _StarMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2, cy = size.height / 2;
    final r = size.width * 0.45;
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // 6 arms like the X/snowflake in the screenshot
    const arms = 6;
    for (int i = 0; i < arms; i++) {
      final angle = (i / arms) * 2 * pi;
      canvas.drawLine(
        Offset(cx + r * 0.15 * cos(angle), cy + r * 0.15 * sin(angle)),
        Offset(cx + r * cos(angle), cy + r * sin(angle)),
        paint,
      );
    }
  }
  @override bool shouldRepaint(_) => false;
}