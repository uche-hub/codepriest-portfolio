import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class CurvedConnectingLine extends StatelessWidget {
  const CurvedConnectingLine({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: 100,
      child: CustomPaint(painter: CurvedLinePainter()),
    );
  }
}

class CurvedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.white.withValues(alpha: 0.6)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Start point (top center)
    path.moveTo(size.width / 2, 0);

    // Create S-curve using cubic bezier
    // Control points create the bent/curved effect
    final controlPoint1 = Offset(size.width * 0.3, size.height * 0.3);
    final controlPoint2 = Offset(size.width * 0.7, size.height * 0.6);
    final endPoint = Offset(size.width / 2, size.height);

    path.cubicTo(
      controlPoint1.dx,
      controlPoint1.dy,
      controlPoint2.dx,
      controlPoint2.dy,
      endPoint.dx,
      endPoint.dy,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CurvedLinePainter oldDelegate) => false;
}
