import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:particles_flutter/engine.dart';
import 'package:particles_flutter/interactions.dart';
import 'package:particles_flutter/physics.dart';

import '../../core/constants/responsive_helper.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _typeController;
  late AnimationController _explodeController;
  late AnimationController _slideController;

  static const String fullName = "UCHENNA NDUKWE";
  bool showTypewriter = true;
  bool showExplosion = false;
  bool isSplashFinished = false;

  late List<Particle> backgroundParticles;
  final List<ExplosionParticle> explosionParticles = [];
  final Random rng = Random();

  @override
  void initState() {
    super.initState();
    backgroundParticles = _createBackgroundParticles();

    _typeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );

    _explodeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _typeController.forward();
    });

    _typeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          setState(() {
            showTypewriter = false;
            showExplosion = true;
          });
          _generateExplosionParticles();
          _explodeController.forward();
        }
      }
    });

    _explodeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          _slideController.forward().then((_) {
            if (mounted) setState(() => isSplashFinished = true);
          });
        }
      }
    });

    _explodeController.addListener(() => setState(() {}));
  }

  List<Particle> _createBackgroundParticles() {
    return List.generate(
      70,
      (index) => CircularParticle(
        radius: rng.nextDouble() * 5 + 1.5,
        color: Colors.black.withOpacity(0.07 + rng.nextDouble() * 0.10),
        velocity: Offset(
          (rng.nextDouble() - 0.5) * 30,
          (rng.nextDouble() - 0.5) * 30,
        ),
      ),
    );
  }

  void _generateExplosionParticles() {
    explosionParticles.clear();
    final size = MediaQuery.of(context).size;
    final centerX = size.width / 2;
    final centerY = size.height / 2 - 20;

    for (int i = 0; i < 600; i++) {
      final angle = rng.nextDouble() * 2 * pi;
      final speed = 2.0 + rng.nextDouble() * 5.0;
      explosionParticles.add(
        ExplosionParticle(
          position: Offset(
            centerX + (rng.nextDouble() - 0.5) * 80,
            centerY + (rng.nextDouble() - 0.5) * 40,
          ),
          velocity: Offset(cos(angle) * speed, sin(angle) * speed - 1.2),
          radius: rng.nextDouble() * 3.5 + 1.0,
          color: Colors.black.withOpacity(0.7 + rng.nextDouble() * 0.3),
        ),
      );
    }
  }

  @override
  void dispose() {
    _typeController.dispose();
    _explodeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isSplashFinished) return const HomeScreen();

    final size = MediaQuery.of(context).size;
    final fontSize = ResponsiveHelper.getHeroTitleFontSize(context) * 0.78;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Splash Layer
          Container(
            color: Colors.white,
            child: Stack(
              children: [
                Particles(
                  particles: backgroundParticles,
                  height: size.height,
                  width: size.width,
                  connectDots: true,
                  boundType: BoundType.WrapAround,
                  interaction: ParticleInteraction(),
                  particlePhysics: ParticlePhysics(),
                ),
                if (showTypewriter)
                  Center(
                    child: DefaultTextStyle(
                      style: GoogleFonts.dmSans(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        letterSpacing: -1.1,
                      ),
                      child: AnimatedTextKit(
                        isRepeatingAnimation: false,
                        animatedTexts: [
                          TypewriterAnimatedText(
                            fullName,
                            speed: const Duration(milliseconds: 75),
                            cursor: '_',
                          ),
                        ],
                      ),
                    ),
                  ),
                if (showExplosion || _explodeController.isAnimating)
                  IgnorePointer(
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: _ExplosionPainter(
                        particles: explosionParticles,
                        time: _explodeController.value,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Home Screen slides FROM BOTTOM TO TOP
          SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0, 1), // Start from bottom
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _slideController,
                    curve: Curves.easeInOutCubicEmphasized,
                  ),
                ),
            child: const HomeScreen(),
          ),
        ],
      ),
    );
  }
}

// ==================== Explosion Classes (unchanged) ====================
class ExplosionParticle {
  final Offset position;
  final Offset velocity;
  final double radius;
  final Color color;
  ExplosionParticle({
    required this.position,
    required this.velocity,
    required this.radius,
    required this.color,
  });
}

class _ExplosionPainter extends CustomPainter {
  final List<ExplosionParticle> particles;
  final double time;
  _ExplosionPainter({required this.particles, required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final progress = time.clamp(0.0, 1.0);
    if (progress >= 1.0) return;

    for (final p in particles) {
      final opacity = (1 - progress).clamp(0.0, 1.0);
      final eased = Curves.decelerate.transform(progress);
      final px = p.position.dx + p.velocity.dx * eased * 140;
      final py =
          p.position.dy + p.velocity.dy * eased * 140 + eased * eased * 220;
      paint.color = p.color.withOpacity(opacity * 0.92);
      canvas.drawCircle(Offset(px, py), p.radius * (1 - progress * 0.5), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ExplosionPainter oldDelegate) => true;
}
