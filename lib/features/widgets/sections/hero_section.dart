import 'dart:math';

import 'package:codepriest_portfolio/widget/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive.dart';
import 'dart:async';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  String displayedName = '';
  final String fullName = 'Uchenna Ndukwe';
  int currentIndex = 0;
  Timer? typingTimer;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    // Start typing effect after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      startTypingEffect();
    });
  }

  void startTypingEffect() {
    typingTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (currentIndex < fullName.length) {
        setState(() {
          displayedName = fullName.substring(0, currentIndex + 1);
          currentIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    typingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height - 80,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.getResponsiveValue(
          context,
          mobile: 20,
          tablet: 40,
          web: 80,
        ),
        vertical: Responsive.getResponsiveValue(
          context,
          mobile: 40,
          tablet: 60,
          web: 80,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: isMobile || isTablet
              ? _buildMobileLayout()
              : _buildWebLayout(),
        ),
      ),
    );
  }

  Widget _buildWebLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 5,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: _buildContent(),
          ),
        ),
        const SizedBox(width: 80),
        Expanded(flex: 5, child: _buildIllustration()),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        _buildIllustration(),
        const SizedBox(height: 40),
        _buildContent(),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildContent() {
    return FadeTransition(
      opacity: _fadeController,
      child: Column(
        crossAxisAlignment: Responsive.isMobile(context)
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Welcome badge
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
            child: const AppTextRegular('Welcome To my World!', fontSize: 16),
          ),

          const SizedBox(height: 24),

          // Greeting
          AppTextMedium(
            'Hello, I\' am',
            fontSize: Responsive.getResponsiveValue(
              context,
              mobile: 20,
              tablet: 28,
              web: 32,
            ),
            textAlign: Responsive.isMobile(context)
                ? TextAlign.center
                : TextAlign.start,
          ),

          const SizedBox(height: 8),

          // Name with typing effect
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: Responsive.isMobile(context)
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Flexible(
                  child: AppTextBold(
                    displayedName,
                    fontSize: Responsive.getResponsiveValue(
                      context,
                      mobile: 36,
                      tablet: 48,
                      web: 56,
                    ),
                    textAlign: Responsive.isMobile(context)
                        ? TextAlign.center
                        : TextAlign.start,
                  ),
                ),
                if (currentIndex < fullName.length)
                  Container(
                    width: 4,
                    height: Responsive.getResponsiveValue(
                      context,
                      mobile: 36,
                      tablet: 48,
                      web: 56,
                    ),
                    margin: const EdgeInsets.only(left: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accentPurple,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Role with pulsing effect
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_pulseController.value * 0.05),
                child: ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColors.purpleGradient.createShader(bounds),
                  child: AppTextMedium(
                    'Flutter Developer',
                    fontSize: Responsive.getResponsiveValue(
                      context,
                      mobile: 20,
                      tablet: 28,
                      web: 32,
                    ),
                    color: AppColors.white,
                    textAlign: Responsive.isMobile(context)
                        ? TextAlign.center
                        : TextAlign.start,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Description
          Column(
            crossAxisAlignment: Responsive.isMobile(context)
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              AppTextRegular(
                'I craft thoughtful digital experiences that blend clarity, beauty',
                fontSize: Responsive.getResponsiveValue(
                  context,
                  mobile: 14,
                  tablet: 16,
                  web: 18,
                ),
                textAlign: Responsive.isMobile(context)
                    ? TextAlign.center
                    : TextAlign.start,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 8),
              AppTextRegular(
                'I turn ideas into intuitive interfaces that feel effortless to explore.',
                fontSize: Responsive.getResponsiveValue(
                  context,
                  mobile: 14,
                  tablet: 16,
                  web: 18,
                ),
                textAlign: Responsive.isMobile(context)
                    ? TextAlign.center
                    : TextAlign.start,
                color: AppColors.textSecondary,
              ),
            ],
          ),

          const SizedBox(height: 40),

          // CTA Button
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  gradient: AppColors.purpleGradient,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentPurple.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: AppTextRegular(
                  'Explore My Portfolio',
                  fontSize: Responsive.getResponsiveValue(
                    context,
                    mobile: 14,
                    tablet: 16,
                    web: 18,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 60),

          // Tools section
          _buildToolsSection(),
        ],
      ),
    );
  }

  Widget _buildToolsSection() {
    return Column(
      crossAxisAlignment: Responsive.isMobile(context)
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        AppTextRegular(
          'Tools I use to bring ideas to life',
          fontSize: Responsive.getResponsiveValue(
            context,
            mobile: 14,
            tablet: 16,
            web: 18,
          ),
          color: AppColors.textSecondary,
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 24,
          runSpacing: 16,
          alignment: Responsive.isMobile(context)
              ? WrapAlignment.center
              : WrapAlignment.start,
          children: [
            _buildToolItem('/svg/vscode.svg', 'VSCode'),
            _buildToolItem('/svg/figma.svg', 'Figma'),
            _buildToolItem('/svg/claude.svg', 'Claude'),
          ],
        ),
      ],
    );
  }

  Widget _buildToolItem(String svgPath, String name) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          svgPath,
          width: Responsive.getResponsiveValue(
            context,
            mobile: 20,
            tablet: 22,
            web: 24,
          ),
          height: Responsive.getResponsiveValue(
            context,
            mobile: 20,
            tablet: 22,
            web: 24,
          ),
          // colorFilter: const ColorFilter.mode(
          //   AppColors.accentPurple,
          //   BlendMode.srcIn,
          // ),
        ),
        const SizedBox(width: 8),
        AppTextRegular(
          name,
          fontSize: Responsive.getResponsiveValue(
            context,
            mobile: 14,
            tablet: 15,
            web: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildIllustration() {
    return Center(
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, sin(_pulseController.value * 2 * pi) * 10),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: Responsive.getResponsiveValue(
                  context,
                  mobile: 280,
                  tablet: 350,
                  web: 450,
                ),
                maxHeight: Responsive.getResponsiveValue(
                  context,
                  mobile: 280,
                  tablet: 350,
                  web: 450,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Glow effect
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.accentPurple.withValues(alpha: 0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  // Illustration placeholder - replace with your actual illustration/image
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      gradient: AppColors.purpleGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.person,
                      size: Responsive.getResponsiveValue(
                        context,
                        mobile: 140,
                        tablet: 180,
                        web: 220,
                      ),
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
