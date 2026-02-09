import 'package:codepriest_portfolio/features/widgets/skill_widgets/section_header.dart';
import 'package:codepriest_portfolio/features/widgets/work%20widget/work_card.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/responsive.dart';

class WorksSection extends StatelessWidget {
  const WorksSection({super.key});

  @override
  Widget build(BuildContext context) {
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
                badge: 'My Work',
                title: 'Showcasing My',
                subtitle: 'Best Work',
              ),

              SizedBox(
                height: Responsive.getResponsiveValue(
                  context,
                  mobile: 40,
                  tablet: 60,
                  web: 80,
                ),
              ),

              // Works Grid
              _buildWorksGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorksGrid(BuildContext context) {
    final works = _getWorks();
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    // Determine grid columns based on screen size
    final crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 2);

    // Constrain the grid width on desktop to make cards smaller
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: Responsive.getResponsiveValue(
            context,
            mobile: double.infinity,
            tablet: double.infinity,
            web: 1100, // Limit width on desktop for smaller cards
          ),
        ),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: Responsive.getResponsiveValue(
              context,
              mobile: 20,
              tablet: 30,
              web: 40,
            ),
            mainAxisSpacing: Responsive.getResponsiveValue(
              context,
              mobile: 20,
              tablet: 30,
              web: 40,
            ),
            childAspectRatio: Responsive.getResponsiveValue(
              context,
              mobile: 0.85,
              tablet: 0.88,
              web: 0.92, // Increased from 1.0 to make cards less tall
            ),
          ),
          itemCount: works.length,
          itemBuilder: (context, index) {
            return WorkCard(work: works[index]);
          },
        ),
      ),
    );
  }

  List<WorkItem> _getWorks() {
    return [
      WorkItem(
        title: 'Novelle',
        subtitle: 'E-commerce App Design',
        imagePath: '/images/1.jpg',
        tags: ['App Design', 'App Design'],
        category: 'App Design',
      ),
      WorkItem(
        title: 'Maal Tracker',
        subtitle: 'E-commerce App Design',
        imagePath: '/images/3.jpg',
        tags: ['App Design'],
        category: 'App Design',
      ),
      WorkItem(
        title: 'Intenda',
        subtitle: 'E-commerce App Design',
        imagePath: '/images/2.jpg',
        tags: ['App Design'],
        category: 'App Design',
      ),
      WorkItem(
        title: 'Shelf',
        subtitle: 'E-commerce App Design',
        imagePath: '/images/4.jpg',
        tags: ['App Design', 'App Design'],
        category: 'App Design',
      ),
    ];
  }
}

class WorkItem {
  final String title;
  final String subtitle;
  final String imagePath;
  final List<String> tags;
  final String category;

  WorkItem({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.tags,
    required this.category,
  });
}
