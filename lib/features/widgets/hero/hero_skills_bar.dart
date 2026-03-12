// lib/features/home/widgets/skills_ticker_widget.dart

import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/responsive_helper.dart';

class SkillsTickerWidget extends StatefulWidget {
  const SkillsTickerWidget({super.key});

  @override
  State<SkillsTickerWidget> createState() => _SkillsTickerWidgetState();
}

class _SkillsTickerWidgetState extends State<SkillsTickerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  static const _skills = AppConstants.skills;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = ResponsiveHelper.getSkillBarFontSize(context);
    final barHeight = ResponsiveHelper.isMobile(context) ? 44.0 : 54.0;

    return Container(
      height: barHeight,
      color: Colors.black,
      child: ClipRect(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return CustomPaint(
              painter: _TickerPainter(
                progress: _animation.value,
                skills: _skills,
                fontSize: fontSize,
              ),
              child: const SizedBox.expand(),
            );
          },
        ),
      ),
    );
  }
}

class _TickerPainter extends CustomPainter {
  final double progress;
  final List<String> skills;
  final double fontSize;

  _TickerPainter({
    required this.progress,
    required this.skills,
    required this.fontSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final textPainters = <TextPainter>[];
    final starPainters = <TextPainter>[];

    final textStyle = TextStyle(
      fontFamily: 'DM Sans',
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      color: Colors.white,
      letterSpacing: 1.5,
    );

    final starStyle = TextStyle(
      fontSize: fontSize * 1.2,
      color: Colors.white.withValues(alpha: 0.8),
      fontWeight: FontWeight.w300,
    );

    double itemWidth = 0;
    for (final skill in skills) {
      final tp = TextPainter(
        text: TextSpan(text: skill, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainters.add(tp);

      final sp = TextPainter(
        text: TextSpan(text: ' ✦ ', style: starStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      starPainters.add(sp);

      itemWidth += tp.width + sp.width;
    }

    // Total width of one cycle
    final totalWidth = itemWidth;
    final offset = -(progress * totalWidth);

    // Draw 3 cycles to fill the screen
    for (int cycle = 0; cycle < 4; cycle++) {
      double x = offset + cycle * totalWidth;
      for (int i = 0; i < skills.length; i++) {
        final tp = textPainters[i];
        final sp = starPainters[i];
        final y = (size.height - tp.height) / 2;
        final sy = (size.height - sp.height) / 2;

        tp.paint(canvas, Offset(x, y));
        x += tp.width;
        sp.paint(canvas, Offset(x, sy));
        x += sp.width;
      }
    }
  }

  @override
  bool shouldRepaint(_TickerPainter oldDelegate) =>
      oldDelegate.progress != progress;
}