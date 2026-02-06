import 'package:codepriest_portfolio/widget/app_texts.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive.dart';

class AppNavBar extends StatefulWidget {
  final Function(String)? onNavItemTap;
  final VoidCallback? onDownloadCV;

  const AppNavBar({super.key, this.onNavItemTap, this.onDownloadCV});

  @override
  State<AppNavBar> createState() => _AppNavBarState();
}

class _AppNavBarState extends State<AppNavBar> {
  String? hoveredItem;

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: _buildMobileNav(context),
      tablet: _buildMobileNav(context),
      web: _buildWebNav(context),
    );
  }

  Widget _buildWebNav(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.primaryDark.withValues(alpha: 0.95),
        border: Border(bottom: BorderSide(color: AppColors.white10, width: 1)),
      ),
      child: ResponsiveWrapper(
        child: ResponsivePadding(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_buildLogo(), _buildNavItems(), _buildDownloadButton()],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileNav(BuildContext context) {
    // Top bar with logo and download button
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.primaryDark.withValues(alpha: 0.95),
        border: Border(bottom: BorderSide(color: AppColors.white10, width: 1)),
      ),
      child: ResponsivePadding(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_buildLogo(), _buildDownloadButton()],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: AppColors.purpleGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text(
              'S',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItems() {
    final items = ['Home', 'Service', 'Works', 'FAQ', 'Review'];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: items.map((item) => _buildNavItem(item)).toList(),
    );
  }

  Widget _buildNavItem(String title) {
    final isHovered = hoveredItem == title;

    return MouseRegion(
      onEnter: (_) => setState(() => hoveredItem = title),
      onExit: (_) => setState(() => hoveredItem = null),
      child: GestureDetector(
        onTap: () => widget.onNavItemTap?.call(title.toLowerCase()),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: isHovered ? AppColors.purple20 : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isHovered ? AppColors.accentPurple : Colors.transparent,
              width: 1,
            ),
          ),
          child: AppTextRegular(
            title,
            color: isHovered ? AppColors.white : AppColors.textSecondary,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onDownloadCV,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.accentPurple, width: 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppTextRegular('Download CV', fontSize: 16),
              const SizedBox(width: 8),
              Icon(Icons.download, color: AppColors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class MobileBottomNav extends StatefulWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const MobileBottomNav({super.key, this.currentIndex = 0, this.onTap});

  @override
  State<MobileBottomNav> createState() => _MobileBottomNavState();
}

class _MobileBottomNavState extends State<MobileBottomNav> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.primaryDark.withValues(alpha: 0.95),
        border: Border(top: BorderSide(color: AppColors.white10, width: 1)),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentPurple.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBottomNavItem(Icons.home, 'Home', 0),
          _buildBottomNavItem(Icons.design_services, 'Service', 1),
          _buildBottomNavItem(Icons.work, 'Works', 2),
          _buildBottomNavItem(Icons.help, 'FAQ', 3),
          _buildBottomNavItem(Icons.rate_review, 'Review', 4),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, int index) {
    final isActive = widget.currentIndex == index;

    return GestureDetector(
      onTap: () => widget.onTap?.call(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive
                  ? AppColors.accentPurple
                  : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            AppTextRegular(
              label,
              fontSize: 12,
              color: isActive ? AppColors.white : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
