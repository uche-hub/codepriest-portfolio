import 'package:codepriest_portfolio/widget/app_texts.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive.dart';

class SkillsCategory extends StatelessWidget {
  final String title;
  final List<String> skills;
  final Color color;

  const SkillsCategory({
    super.key,
    required this.title,
    required this.skills,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      padding: EdgeInsets.all(
        Responsive.getResponsiveValue(context, mobile: 20, tablet: 30, web: 40),
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextBold(
            title,
            fontSize: Responsive.getResponsiveValue(
              context,
              mobile: 20,
              tablet: 24,
              web: 28,
            ),
            color: color,
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: isMobile ? 8 : 40,
            runSpacing: 16,
            children: skills.map((skill) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  AppTextRegular(
                    skill,
                    fontSize: Responsive.getResponsiveValue(
                      context,
                      mobile: 14,
                      tablet: 15,
                      web: 16,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
