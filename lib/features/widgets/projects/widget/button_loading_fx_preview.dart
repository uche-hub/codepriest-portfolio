// Drop this widget in place of Image.asset(study.imagePath, ...)
// inside _CaseImage when study.title == 'Button Loading FX'

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Use in _CaseImage ──────────────────────────────────────────────────────
// Replace the Image.asset + errorBuilder block with:
//   child: study.title == 'Button Loading FX'
//       ? const ButtonLoadingFXPreview()
//       : Image.asset(study.imagePath, ...)

class ButtonLoadingFXPreview extends StatefulWidget {
  const ButtonLoadingFXPreview({super.key});

  @override
  State<ButtonLoadingFXPreview> createState() => _ButtonLoadingFXPreviewState();
}

class _ButtonLoadingFXPreviewState extends State<ButtonLoadingFXPreview>
    with TickerProviderStateMixin {
  bool _btn1Loading = false;
  bool _btn2Loading = false;

  late final AnimationController _spinCtrl;
  late final AnimationController _dot1Ctrl;
  late final AnimationController _dot2Ctrl;
  late final AnimationController _dot3Ctrl;

  @override
  void initState() {
    super.initState();

    _spinCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _dot1Ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _dot2Ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _dot3Ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _startLoop();
  }

  void _startLoop() async {
    while (mounted) {
      // — Button 1: spinner cycle —
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;
      setState(() => _btn1Loading = true);
      _spinCtrl.repeat();

      await Future.delayed(const Duration(milliseconds: 1600));
      if (!mounted) return;
      setState(() => _btn1Loading = false);
      _spinCtrl.stop();
      _spinCtrl.reset();

      await Future.delayed(const Duration(milliseconds: 600));

      // — Button 2: dot-bounce cycle —
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      setState(() => _btn2Loading = true);
      _dot1Ctrl.repeat(reverse: true);
      await Future.delayed(const Duration(milliseconds: 100));
      _dot2Ctrl.repeat(reverse: true);
      await Future.delayed(const Duration(milliseconds: 100));
      _dot3Ctrl.repeat(reverse: true);

      await Future.delayed(const Duration(milliseconds: 1600));
      if (!mounted) return;
      setState(() => _btn2Loading = false);
      _dot1Ctrl.stop(); _dot1Ctrl.reset();
      _dot2Ctrl.stop(); _dot2Ctrl.reset();
      _dot3Ctrl.stop(); _dot3Ctrl.reset();

      await Future.delayed(const Duration(milliseconds: 800));
    }
  }

  @override
  void dispose() {
    _spinCtrl.dispose();
    _dot1Ctrl.dispose();
    _dot2Ctrl.dispose();
    _dot3Ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A1A1A),
      height: 340,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'LIVE PREVIEW',
              style: GoogleFonts.dmSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.4,
                color: Colors.white.withOpacity(0.28),
              ),
            ),
            const SizedBox(height: 24),
            _SpinnerButton(loading: _btn1Loading, spinCtrl: _spinCtrl),
            const SizedBox(height: 16),
            _DotBounceButton(
              loading: _btn2Loading,
              dot1: _dot1Ctrl,
              dot2: _dot2Ctrl,
              dot3: _dot3Ctrl,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Spinner Button ─────────────────────────────────────────────────────────

class _SpinnerButton extends StatelessWidget {
  final bool loading;
  final AnimationController spinCtrl;

  const _SpinnerButton({required this.loading, required this.spinCtrl});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 160,
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFF1A4FD6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedOpacity(
            opacity: loading ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Text(
              'Submit',
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: loading ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: RotationTransition(
              turns: spinCtrl,
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  backgroundColor: Colors.white.withOpacity(0.3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Dot-Bounce Button ──────────────────────────────────────────────────────

class _DotBounceButton extends StatelessWidget {
  final bool loading;
  final AnimationController dot1, dot2, dot3;

  const _DotBounceButton({
    required this.loading,
    required this.dot1,
    required this.dot2,
    required this.dot3,
  });

  Widget _dot(AnimationController ctrl) {
    final anim = Tween<double>(begin: 0, end: -5).animate(
      CurvedAnimation(parent: ctrl, curve: Curves.easeInOut),
    );
    return AnimatedBuilder(
      animation: anim,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, anim.value),
        child: Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 160,
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFF0F6E56),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedOpacity(
            opacity: loading ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Text(
              'Processing',
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: loading ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dot(dot1),
                const SizedBox(width: 5),
                _dot(dot2),
                const SizedBox(width: 5),
                _dot(dot3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}