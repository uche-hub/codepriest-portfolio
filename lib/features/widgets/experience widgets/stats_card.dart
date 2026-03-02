import 'package:codepriest_portfolio/widget/app_texts.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive.dart';

class StatsCard extends StatefulWidget {
  const StatsCard({super.key});

  @override
  State<StatsCard> createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    // Start animation after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Transform.translate(
      offset: Offset(
        0,
        Responsive.getResponsiveValue(
          context,
          mobile: 30,
          tablet: 35,
          web: 40,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.getResponsiveValue(
                context,
                mobile: 20,
                tablet: 40,
                web: 60,
              ),
              vertical: Responsive.getResponsiveValue(
                context,
                mobile: 24,
                tablet: 32,
                web: 40,
              ),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.white.withOpacity(0.08),
                  AppColors.white.withOpacity(0.04),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.white.withOpacity(0.15),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentPurple.withOpacity(0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: isMobile ? _buildMobileStats() : _buildWebStats(),
          ),
        ),
      ),
    );
  }

  Widget _buildWebStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(150, '+', 'Happy Clients'),
        _buildDivider(),
        _buildStatItem(98, '%', 'Client Satisfaction'),
        _buildDivider(),
        _buildStatItem(120, '+', 'Projects Completed'),
      ],
    );
  }

  Widget _buildMobileStats() {
    return Column(
      children: [
        _buildStatItem(150, '+', 'Happy Clients'),
        const SizedBox(height: 24),
        _buildStatItem(98, '%', 'Client Satisfaction'),
        const SizedBox(height: 24),
        _buildStatItem(120, '+', 'Projects Completed'),
      ],
    );
  }

  Widget _buildStatItem(int targetValue, String suffix, String label) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final currentValue = (_animation.value * targetValue).round();

        return Column(
          children: [
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  AppColors.white,
                  AppColors.white.withOpacity(0.9),
                ],
              ).createShader(bounds),
              child: AppTextBold(
                '$currentValue$suffix',
                fontSize: Responsive.getResponsiveValue(
                  context,
                  mobile: 32,
                  tablet: 40,
                  web: 48,
                ),
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 8),
            AppTextRegular(
              label,
              fontSize: Responsive.getResponsiveValue(
                context,
                mobile: 14,
                tablet: 15,
                web: 16,
              ),
              color: AppColors.textSecondary.withOpacity(0.9),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 60,
      width: 1.5,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            AppColors.white.withOpacity(0.2),
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}