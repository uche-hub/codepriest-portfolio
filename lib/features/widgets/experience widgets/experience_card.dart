import 'package:codepriest_portfolio/features/widgets/sections/experience_section.dart';
import 'package:codepriest_portfolio/widget/app_texts.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive.dart';

class ExperienceCard extends StatelessWidget {
  final ExperienceItem experience;

  const ExperienceCard({
    super.key,
    required this.experience,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        Responsive.getResponsiveValue(
          context,
          mobile: 24,
          tablet: 32,
          web: 40,
        ),
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primaryPurple,
            AppColors.accentPurple,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentPurple.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Quote marks
          _buildQuoteMarks(),

          const SizedBox(height: 20),

          // Quote text
          Expanded(
            child: SingleChildScrollView(
              child: AppTextRegular(
                experience.quote,
                fontSize: Responsive.getResponsiveValue(
                  context,
                  mobile: 16,
                  tablet: 18,
                  web: 20,
                ),
                color: AppColors.white,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Author info
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppTextMedium(
                    experience.name,
                    fontSize: Responsive.getResponsiveValue(
                      context,
                      mobile: 16,
                      tablet: 18,
                      web: 20,
                    ),
                    color: AppColors.white,
                  ),
                  const SizedBox(height: 4),
                  AppTextRegular(
                    experience.position,
                    fontSize: Responsive.getResponsiveValue(
                      context,
                      mobile: 13,
                      tablet: 14,
                      web: 15,
                    ),
                    color: AppColors.white.withOpacity(0.8),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteMarks() {
    return Stack(
      children: [
        // First quote mark
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '"',
              style: TextStyle(
                fontSize: 32,
                color: AppColors.white.withOpacity(0.6),
                fontWeight: FontWeight.bold,
                height: 0.9,
              ),
            ),
          ),
        ),
        // Second quote mark (overlapping)
        Positioned(
          left: 25,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '"',
                style: TextStyle(
                  fontSize: 32,
                  color: AppColors.white.withOpacity(0.6),
                  fontWeight: FontWeight.bold,
                  height: 0.9,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}