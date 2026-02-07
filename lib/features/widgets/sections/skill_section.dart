import 'package:codepriest_portfolio/features/widgets/skill%20widgets/curved_line.dart';
import 'package:codepriest_portfolio/features/widgets/skill%20widgets/floating_service.dart';
import 'package:codepriest_portfolio/features/widgets/skill%20widgets/section_header.dart';
import 'package:codepriest_portfolio/features/widgets/skill%20widgets/skill_card.dart';
import 'package:codepriest_portfolio/features/widgets/skill%20widgets/skill_category.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.getResponsiveValue(
          context,
          mobile: 20,
          tablet: 40,
          web: 80,
        ),
        vertical: Responsive.getResponsiveValue(
          context,
          mobile: 60,
          tablet: 80,
          web: 100,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Column(
            children: [
              // Section Header
              const SectionHeader(
                badge: 'Skills',
                title: 'How I Can Improve',
                subtitle: 'Your Experience',
              ),

              SizedBox(
                height: Responsive.getResponsiveValue(
                  context,
                  mobile: 40,
                  tablet: 60,
                  web: 80,
                ),
              ),

              // Main Content
              isMobile || isTablet ? _buildMobileLayout() : _buildWebLayout(),

              SizedBox(
                height: Responsive.getResponsiveValue(
                  context,
                  mobile: 60,
                  tablet: 80,
                  web: 100,
                ),
              ),

              // Skills List Section
              _buildSkillsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWebLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side - Skills list
        Expanded(flex: 5, child: _buildSkillsListLeft()),
        const SizedBox(width: 80),
        // Right side - Connecting cards
        Expanded(flex: 5, child: _buildConnectingCards()),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildConnectingCards(),
        const SizedBox(height: 40),
        _buildSkillsListLeft(),
      ],
    );
  }

  Widget _buildSkillsListLeft() {
    final skills = _getSkillItems();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: skills.map((skill) {
        return SkillCard(
          icon: skill.icon,
          title: skill.title,
          description: skill.description,
        );
      }).toList(),
    );
  }

  Widget _buildConnectingCards() {
    final skills = _getSkillItems();

    return Column(
      children: [
        for (int i = 0; i < skills.length; i++) ...[
          FloatingServiceCard(
            title: skills[i].title,
            serviceNumber: i + 1,
            index: i,
          ),
          if (i < skills.length - 1) const CurvedConnectingLine(),
        ],
      ],
    );
  }

  Widget _buildSkillsList() {
    return Column(
      children: [
        // Tech Skills
        SkillsCategory(
          title: 'TECH SKILLS',
          skills: _getTechSkills(),
          color: AppColors.accentPurple,
        ),
        const SizedBox(height: 60),
        // Additional Skills
        SkillsCategory(
          title: 'ADDITIONAL SKILLS',
          skills: _getAdditionalSkills(),
          color: AppColors.primaryPurple,
        ),
      ],
    );
  }

  List<SkillItem> _getSkillItems() {
    return [
      SkillItem(
        icon: Icons.brush_outlined,
        title: 'UX/UI Design',
        description:
            'Designing intuitive, user-centered experiences that balance clarity, beauty, and functionality.',
      ),
      SkillItem(
        icon: Icons.widgets_outlined,
        title: 'Prototyping & Wireframing',
        description:
            'Creating clear wireframes and interactive prototypes that shape the structure of your product.',
      ),
      SkillItem(
        icon: Icons.web_outlined,
        title: 'Web Design',
        description:
            'I design modern, responsive websites that blend clarity, beauty, and a smooth user experience.',
      ),
      SkillItem(
        icon: Icons.phone_iphone_outlined,
        title: 'App Design',
        description:
            'Designing clean, intuitive mobile apps that offer a smooth and engaging user experience.',
      ),
    ];
  }

  List<String> _getTechSkills() {
    return [
      'Microsoft Suite software',
      'ReactJS',
      'Flutter',
      'Java',
      'HTML',
      'WordPress Developer',
      'CSS',
      'JavaScript',
      'BLoC',
      'Provider',
      'Riverpod',
      'Problem Solving',
    ];
  }

  List<String> _getAdditionalSkills() {
    return [
      'Graphics Design',
      'SEO (Search Engine Optimization)',
      'Social Media Marketing',
      'PPC (Pay-Per-Click) Advertising',
      'Copywriting and Creative Writing',
      'Digital Marketing',
      'Content Marketing',
      'Email Marketing',
      'Video Marketing',
    ];
  }
}

class SkillItem {
  final IconData icon;
  final String title;
  final String description;

  SkillItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}
