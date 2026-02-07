import 'package:codepriest_portfolio/widget/app_texts.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive.dart';

class SkillCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const SkillCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.purple20,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.accentPurple.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: AppColors.white,
              size: Responsive.getResponsiveValue(
                context,
                mobile: 24,
                tablet: 28,
                web: 32,
              ),
            ),
          ),
          const SizedBox(width: 20),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextMedium(
                  title,
                  fontSize: Responsive.getResponsiveValue(
                    context,
                    mobile: 20,
                    tablet: 24,
                    web: 28,
                  ),
                ),
                const SizedBox(height: 8),
                AppTextRegular(
                  description,
                  fontSize: Responsive.getResponsiveValue(
                    context,
                    mobile: 14,
                    tablet: 15,
                    web: 16,
                  ),
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
