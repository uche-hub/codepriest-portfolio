import 'package:codepriest_portfolio/features/widgets/experience%20widgets/experience_card.dart';
import 'package:codepriest_portfolio/features/widgets/experience%20widgets/stats_card.dart';
import 'package:codepriest_portfolio/widget/app_texts.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive.dart';

class ExperienceSection extends StatefulWidget {
  const ExperienceSection({super.key});

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.cardBackground.withOpacity(0.5),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: AppColors.accentPurple.withOpacity(0.2),
                width: 1,
              ),
            ),
            padding: EdgeInsets.all(
              Responsive.getResponsiveValue(
                context,
                mobile: 24,
                tablet: 40,
                web: 60,
              ),
            ),
            child: Column(
              children: [
                // Main content
                isMobile || isTablet
                    ? _buildMobileLayout()
                    : _buildWebLayout(),

                SizedBox(
                  height: Responsive.getResponsiveValue(
                    context,
                    mobile: 20,
                    tablet: 25,
                    web: 30,
                  ),
                ),

                // Stats card at bottom (will overlap the border)
                const StatsCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWebLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side - Header and avatars
        Expanded(
          flex: 5,
          child: _buildLeftContent(),
        ),
        const SizedBox(width: 60),
        // Right side - Scrollable experience cards
        Expanded(
          flex: 5,
          child: _buildExperienceCards(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildLeftContent(),
        const SizedBox(height: 40),
        _buildExperienceCards(),
      ],
    );
  }

  Widget _buildLeftContent() {
    final isMobile = Responsive.isMobile(context);

    return Column(
      crossAxisAlignment: isMobile 
          ? CrossAxisAlignment.center 
          : CrossAxisAlignment.start,
      children: [
        // Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.purple20,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: AppColors.accentPurple.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: AppTextRegular(
            'Experience',
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
          'What My Colleagues',
          fontSize: Responsive.getResponsiveValue(
            context,
            mobile: 28,
            tablet: 36,
            web: 44,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
        ),
        const SizedBox(height: 8),
        AppTextBold(
          'Says about me',
          fontSize: Responsive.getResponsiveValue(
            context,
            mobile: 28,
            tablet: 36,
            web: 44,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
        ),

        const SizedBox(height: 16),

        // Subtitle
        AppTextRegular(
          'Here What My lovely Colleagues Says about me',
          fontSize: Responsive.getResponsiveValue(
            context,
            mobile: 14,
            tablet: 15,
            web: 16,
          ),
          color: AppColors.textSecondary,
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
        ),

        const SizedBox(height: 32),

        // Avatar stack
        _buildAvatarStack(),

        const SizedBox(height: 32),

        // CTA Button
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              // Handle share experience action
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.white.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: AppTextRegular(
                'Share Your Experience',
                fontSize: 16,
                color: AppColors.primaryDark,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarStack() {
    // Placeholder avatar URLs - replace with actual images
    final avatars = List.generate(5, (index) => 'assets/images/avatar_${index + 1}.png');

    return Row(
      mainAxisAlignment: Responsive.isMobile(context) 
          ? MainAxisAlignment.center 
          : MainAxisAlignment.start,
      children: List.generate(
        avatars.length,
        (index) {
          return Transform.translate(
            offset: Offset(index == 0 ? 0 : -12.0 * index, 0),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primaryDark,
                  width: 3,
                ),
                image: DecorationImage(
                  image: AssetImage(avatars[index]),
                  fit: BoxFit.cover,
                  onError: (error, stackTrace) {},
                ),
                color: AppColors.secondaryDark,
              ),
              child: Center(
                child: Icon(
                  Icons.person,
                  color: AppColors.white.withOpacity(0.5),
                  size: 24,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildExperienceCards() {
    final experiences = _getExperiences();

    return SizedBox(
      height: Responsive.getResponsiveValue(
        context,
        mobile: 400,
        tablet: 450,
        web: 500,
      ),
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemCount: experiences.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ExperienceCard(
              experience: experiences[index],
            ),
          );
        },
      ),
    );
  }

  List<ExperienceItem> _getExperiences() {
    return [
      ExperienceItem(
        quote: 'Shahd is skilled in design, especially with clear requirements, and excels in Adobe XD, communication, and handling revisions.',
        name: 'Majed Khaled',
        position: 'Product Manager',
        company: 'Tech Corp',
        avatarPath: 'assets/images/majed.png',
      ),
      ExperienceItem(
        quote: 'Outstanding developer with exceptional problem-solving skills. Always delivers high-quality work on time.',
        name: 'Sarah Johnson',
        position: 'Senior Developer',
        company: 'StartupX',
        avatarPath: 'assets/images/sarah.png',
      ),
      ExperienceItem(
        quote: 'A fantastic team player who brings creative solutions to complex challenges. Highly recommended!',
        name: 'Michael Chen',
        position: 'Tech Lead',
        company: 'Innovation Labs',
        avatarPath: 'assets/images/michael.png',
      ),
    ];
  }
}

class ExperienceItem {
  final String quote;
  final String name;
  final String position;
  final String company;
  final String avatarPath;

  ExperienceItem({
    required this.quote,
    required this.name,
    required this.position,
    required this.company,
    required this.avatarPath,
  });
}