import 'package:codepriest_portfolio/features/presentation/controllers/navigation_controllers.dart';
import 'package:codepriest_portfolio/features/presentation/providers/download_provider.dart';
import 'package:codepriest_portfolio/features/widgets/sections/hero_section.dart';
import 'package:codepriest_portfolio/features/widgets/sections/skill_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive.dart';
import 'widgets/animated_background.dart';
import 'widgets/app_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();
    // Add scroll listener after the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navController = context.read<NavigationController>();
      navController.scrollController.addListener(() {
        navController.updateActiveSection();
      });
    });
  }

  void _handleNavTap(String section) {
    // Navigation is now handled in the navbar itself via NavigationController
  }

  void _handleBottomNavTap(int index) {
    setState(() {
      _currentNavIndex = index;
    });

    // Map index to section name
    final sections = ['home', 'skills', 'works', 'faq', 'review'];
    if (index < sections.length) {
      final navController = context.read<NavigationController>();
      navController.scrollToSection(sections[index]);
    }
  }

  void _handleDownloadCV() {
    final downloadProvider = context.read<DownloadProvider>();
    downloadProvider.downloadCV();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final navController = context.watch<NavigationController>();

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: AnimatedBackground(
        child: Column(
          children: [
            // Sticky Navigation
            AppNavBar(
              onNavItemTap: _handleNavTap,
              onDownloadCV: _handleDownloadCV,
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                controller: navController.scrollController,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Hero Section with key
                    Container(
                      key: navController.homeKey,
                      child: const HeroSection(),
                    ),

                    // Skills Section with key
                    Container(
                      key: navController.skillsKey,
                      child: const SkillsSection(),
                    ),

                    // Placeholder for other sections
                    // Container(
                    //   key: navController.worksKey,
                    //   child: const WorksSection(),
                    // ),
                    // Container(
                    //   key: navController.faqKey,
                    //   child: const FAQSection(),
                    // ),
                    // Container(
                    //   key: navController.reviewKey,
                    //   child: const ReviewSection(),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation for Mobile/Tablet
      bottomNavigationBar: (isMobile || isTablet)
          ? MobileBottomNav(
              currentIndex: _currentNavIndex,
              onTap: _handleBottomNavTap,
            )
          : null,
    );
  }
}
