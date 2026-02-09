import 'package:codepriest_portfolio/features/widgets/sections/work_section.dart';
import 'package:codepriest_portfolio/widget/app_texts.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive.dart';

class WorkCard extends StatefulWidget {
  final WorkItem work;

  const WorkCard({super.key, required this.work});

  @override
  State<WorkCard> createState() => _WorkCardState();
}

class _WorkCardState extends State<WorkCard>
    with SingleTickerProviderStateMixin {
  bool isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => isHovered = true);
        _animationController.forward();
      },
      onExit: (_) {
        setState(() => isHovered = false);
        _animationController.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentPurple.withValues(
                      alpha: isHovered ? 0.3 : 0.1,
                    ),
                    blurRadius: isHovered ? 30 : 20,
                    offset: Offset(0, isHovered ? 15 : 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    // Main card content
                    _buildCardContent(),

                    // Purple U-shaped border overlay
                    Positioned.fill(
                      child: CustomPaint(
                        painter: PurpleUShapePainter(isHovered: isHovered),
                      ),
                    ),

                    // Arrow button overlay
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: _buildArrowButton(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image section
        Expanded(
          flex: 6,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              child: Image.asset(
                widget.work.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Placeholder when image not found
                  return Container(
                    color: AppColors.secondaryDark,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            size: 64,
                            color: AppColors.white.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 12),
                          AppTextRegular(
                            widget.work.title,
                            fontSize: 16,
                            color: AppColors.white.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 4),
                          AppTextRegular(
                            'Image: 800x600px',
                            fontSize: 12,
                            color: AppColors.white.withValues(alpha: 0.3),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),

        // Content section with gradient background
        Expanded(
          flex: 4,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryPurple, AppColors.accentPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: Responsive.getResponsiveValue(
                context,
                mobile: 16,
                tablet: 18,
                web: 20,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Tags
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: widget.work.tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.white.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: AppTextRegular(
                        tag,
                        fontSize: Responsive.getResponsiveValue(
                          context,
                          mobile: 11,
                          tablet: 12,
                          web: 13,
                        ),
                        color: AppColors.white,
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 8), // Reduced from 12
                // Title and subtitle
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextMedium(
                      widget.work.title,
                      fontSize: Responsive.getResponsiveValue(
                        context,
                        mobile: 20,
                        tablet: 22,
                        web: 24,
                      ),
                      color: AppColors.white,
                    ),
                    const SizedBox(height: 2), // Reduced from 4
                    AppTextRegular(
                      widget.work.subtitle,
                      fontSize: Responsive.getResponsiveValue(
                        context,
                        mobile: 13,
                        tablet: 14,
                        web: 15,
                      ),
                      color: AppColors.white.withValues(alpha: 0.8),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildArrowButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: isHovered ? 1.0 : 0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.white.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Icon(Icons.arrow_outward, color: AppColors.accentPurple, size: 24),
    );
  }
}

// Custom painter for purple U-shaped border
class PurpleUShapePainter extends CustomPainter {
  final bool isHovered;

  PurpleUShapePainter({required this.isHovered});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(0, 0),
        Offset(size.width, size.height),
        [
          AppColors.primaryPurple.withValues(alpha: isHovered ? 0.8 : 0.6),
          AppColors.accentPurple.withValues(alpha: isHovered ? 0.8 : 0.6),
        ],
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Start from top-left (with radius)
    const radius = 24.0;
    const _ = 4.0;

    // Top-left corner
    path.moveTo(0, radius);
    path.arcToPoint(
      const Offset(radius, 0),
      radius: const Radius.circular(radius),
      clockwise: true,
    );

    // Top edge - but stop before reaching the right
    path.lineTo(size.width - radius, 0);

    // Top-right corner
    path.arcToPoint(
      Offset(size.width, radius),
      radius: const Radius.circular(radius),
      clockwise: true,
    );

    // Right edge
    path.lineTo(size.width, size.height - radius);

    // Bottom-right corner
    path.arcToPoint(
      Offset(size.width - radius, size.height),
      radius: const Radius.circular(radius),
      clockwise: true,
    );

    // Bottom edge
    path.lineTo(radius, size.height);

    // Bottom-left corner
    path.arcToPoint(
      Offset(0, size.height - radius),
      radius: const Radius.circular(radius),
      clockwise: true,
    );

    // Left edge - complete the U shape
    path.lineTo(0, radius);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(PurpleUShapePainter oldDelegate) {
    return oldDelegate.isHovered != isHovered;
  }
}
