import 'package:codepriest_portfolio/widget/app_texts.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/responsive.dart';

class SectionHeader extends StatelessWidget {
  final String badge;
  final String title;
  final String? subtitle;

  const SectionHeader({
    super.key,
    required this.badge,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.purple20,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: AppColors.accentPurple.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: AppTextRegular(
            badge,
            fontSize: Responsive.getResponsiveValue(
              context,
              mobile: 14,
              tablet: 15,
              web: 16,
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Title
        AppTextBold(
          title,
          fontSize: Responsive.getResponsiveValue(
            context,
            mobile: 32,
            tablet: 42,
            web: 48,
          ),
          textAlign: TextAlign.center,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          AppTextBold(
            subtitle!,
            fontSize: Responsive.getResponsiveValue(
              context,
              mobile: 32,
              tablet: 42,
              web: 48,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
