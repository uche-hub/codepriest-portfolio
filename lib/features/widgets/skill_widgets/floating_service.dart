import 'package:codepriest_portfolio/widget/app_texts.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive.dart';

class FloatingServiceCard extends StatefulWidget {
  final String title;
  final int serviceNumber;
  final int index;

  const FloatingServiceCard({
    super.key,
    required this.title,
    required this.serviceNumber,
    required this.index,
  });

  @override
  State<FloatingServiceCard> createState() => _FloatingServiceCardState();
}

class _FloatingServiceCardState extends State<FloatingServiceCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: Matrix4.translationValues(
          isHovered ? 10 : 0,
          isHovered ? -5 : 0,
          0,
        ),
        margin: EdgeInsets.only(
          left: widget.index.isEven ? 0 : 80,
          right: widget.index.isEven ? 80 : 0,
        ),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryPurple.withValues(alpha: 0.8),
              AppColors.accentPurple.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.accentPurple.withValues(alpha: 0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentPurple.withValues(
                alpha: isHovered ? 0.4 : 0.2,
              ),
              blurRadius: isHovered ? 30 : 20,
              offset: Offset(0, isHovered ? 15 : 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextRegular(
              'Service ${widget.serviceNumber}',
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 8),
            AppTextMedium(
              widget.title,
              fontSize: Responsive.getResponsiveValue(
                context,
                mobile: 18,
                tablet: 20,
                web: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
