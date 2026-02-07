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
  final ScrollController _scrollController = ScrollController();
  int _currentNavIndex = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleNavTap(String section) {
    // Handle navigation to different sections
    // For now, just log it
    debugPrint('Navigating to: $section');
  }

  void _handleBottomNavTap(int index) {
    setState(() {
      _currentNavIndex = index;
    });
    // Handle navigation based on index
  }

  void _handleDownloadCV() {
    final downloadProvider = context.read<DownloadProvider>();
    downloadProvider.downloadCV();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

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
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: const Column(
                  children: [
                    HeroSection(),
                    SkillsSection(),
                    // WorksSection(),
                    // FAQSection(),
                    // ReviewSection(),
                    // FooterSection(),
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
