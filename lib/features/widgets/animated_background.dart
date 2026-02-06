import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBackground({super.key, required this.child});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> particles = [];
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Generate particles
    for (int i = 0; i < 50; i++) {
      particles.add(
        Particle(
          x: random.nextDouble(),
          y: random.nextDouble(),
          size: random.nextDouble() * 4 + 1,
          speedX: (random.nextDouble() - 0.5) * 0.0005,
          speedY: random.nextDouble() * 0.0003 + 0.0001,
          opacity: random.nextDouble() * 0.5 + 0.3,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient Background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryDark,
                AppColors.secondaryDark,
                AppColors.primaryDark,
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
        ),
        // Radial gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topRight,
              radius: 1.5,
              colors: [
                AppColors.accentPurple.withValues(alpha: 0.15),
                Colors.transparent,
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.bottomLeft,
              radius: 1.5,
              colors: [
                AppColors.primaryPurple.withValues(alpha: 0.1),
                Colors.transparent,
              ],
            ),
          ),
        ),
        // Animated particles
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: ParticlePainter(particles, _controller.value),
              size: Size.infinite,
            );
          },
        ),
        // Content
        widget.child,
      ],
    );
  }
}

class Particle {
  double x;
  double y;
  final double size;
  final double speedX;
  final double speedY;
  final double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speedX,
    required this.speedY,
    required this.opacity,
  });

  void update() {
    x += speedX;
    y += speedY;

    // Wrap around screen
    if (x > 1.0) x = 0.0;
    if (x < 0.0) x = 1.0;
    if (y > 1.0) y = 0.0;
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      particle.update();

      final paint = Paint()
        ..color = AppColors.white.withValues(alpha: particle.opacity)
        ..style = PaintingStyle.fill;

      final position = Offset(
        particle.x * size.width,
        particle.y * size.height,
      );

      // Draw particle as a circle
      canvas.drawCircle(position, particle.size, paint);

      // Draw glow effect
      final glowPaint = Paint()
        ..color = AppColors.accentPurple.withValues(
          alpha: particle.opacity * 0.3,
        )
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawCircle(position, particle.size * 2, glowPaint);
    }

    // Draw connecting lines between nearby particles
    for (int i = 0; i < particles.length; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        final p1 = particles[i];
        final p2 = particles[j];

        final distance = sqrt(
          pow((p1.x - p2.x) * size.width, 2) +
              pow((p1.y - p2.y) * size.height, 2),
        );

        if (distance < 100) {
          final opacity = (1 - distance / 100) * 0.3;
          final linePaint = Paint()
            ..color = AppColors.accentPurple.withValues(alpha: opacity)
            ..strokeWidth = 0.5;

          canvas.drawLine(
            Offset(p1.x * size.width, p1.y * size.height),
            Offset(p2.x * size.width, p2.y * size.height),
            linePaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}
