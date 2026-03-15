import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/scroll_provider.dart';
import '../widgets/contact/contact_section.dart';
import '../widgets/experience/experience_section.dart';
import '../widgets/footer/footer_section.dart';
import '../widgets/hero/hero_section.dart';
import '../widgets/navbar/portfolio_navbar.dart';
import '../widgets/projects/projects_section.dart';
import '../widgets/serviceSection/services_section_widget.dart';
import '../widgets/socialsBar/social_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  final String? initialSection;
  const HomeScreen({super.key, this.initialSection});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.initialSection != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final sp = context.read<ScrollProvider>();
        sp.scrollToSection(widget.initialSection!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scrollProvider = context.watch<ScrollProvider>();
    final width = MediaQuery.of(context).size.width;
    final isMobileOrTablet = width < 1100;

    // Mobile/tablet: ClampingScrollPhysics = native smooth touch,
    //   hard-stops at both ends — no endless scroll above navbar or below footer
    // Desktop: custom spring for nice mouse-wheel feel
    final ScrollPhysics physics = isMobileOrTablet
        ? const ClampingScrollPhysics()
        : const _DesktopSmoothPhysics();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main scrollable content
          ScrollConfiguration(
            behavior: _PortfolioScrollBehavior(isMobileOrTablet: isMobileOrTablet),
            child: CustomScrollView(
              controller: scrollProvider.scrollController,
              physics: physics,
              slivers: [
                // Transparent space for navbar overlap
                const SliverToBoxAdapter(child: SizedBox(height: 100)),

                // Hero section
                SliverToBoxAdapter(
                  key: scrollProvider.heroKey,
                  child: const HeroSectionWidget(),
                ),

                // Social bar — sits flush under the hero ticker
                const SliverToBoxAdapter(
                  child: SocialBarWidget(),
                ),

                // Services section
                SliverToBoxAdapter(
                  key: scrollProvider.skillKey,
                  child: const ServicesSectionWidget(),
                ),

                // Experience section
                SliverToBoxAdapter(
                  key: scrollProvider.experienceKey,
                  child: const ExperienceSectionWidget(),
                ),

                // Case Study section
                SliverToBoxAdapter(
                  key: scrollProvider.projectsKey,
                  child: const CaseStudySectionWidget(),
                ),

                // Testimonials
                // const SliverToBoxAdapter(
                //   child: TestimonialsSectionWidget(),
                // ),
                //
                // // Stats
                // const SliverToBoxAdapter(
                //   child: StatsSectionWidget(),
                // ),

                // Contact
                SliverToBoxAdapter(
                  key: scrollProvider.contactKey,
                  child: const ContactSectionWidget(),
                ),

                // Footer
                const SliverToBoxAdapter(
                  child: FooterWidget(),
                ),

                // Hard bottom boundary — footer stays flush, nothing to scroll into
                const SliverToBoxAdapter(child: SizedBox.shrink()),
              ],
            ),
          ),

          // Sticky Navbar overlaid on top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: const NavbarWidget(),
          ),
        ],
      ),
    );
  }
}

// ─── Desktop smooth scroll physics (mouse wheel) ──────────────────────────────

class _DesktopSmoothPhysics extends ScrollPhysics {
  const _DesktopSmoothPhysics({super.parent});

  @override
  _DesktopSmoothPhysics applyTo(ScrollPhysics? ancestor) {
    return _DesktopSmoothPhysics(parent: buildParent(ancestor));
  }

  @override
  double get minFlingVelocity => 200;

  @override
  double get maxFlingVelocity => 6000;

  @override
  SpringDescription get spring => const SpringDescription(
    mass: 30,
    stiffness: 120,
    damping: 1,
  );
}

// ─── Scroll behavior ──────────────────────────────────────────────────────────

class _PortfolioScrollBehavior extends ScrollBehavior {
  final bool isMobileOrTablet;
  const _PortfolioScrollBehavior({required this.isMobileOrTablet});

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return isMobileOrTablet
        ? const ClampingScrollPhysics()
        : const _DesktopSmoothPhysics();
  }

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
  };

  @override
  Widget buildScrollbar(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child; // Hide scrollbar
  }
}