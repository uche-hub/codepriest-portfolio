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

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main scrollable content
          ScrollConfiguration(
            behavior: _SmoothScrollBehavior(),
            child: CustomScrollView(
              controller: scrollProvider.scrollController,
              physics: const _SmoothScrollPhysics(),
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

// ─── Custom Smooth Scroll Physics ─────────────────────────────────────────────

class _SmoothScrollPhysics extends ScrollPhysics {
  const _SmoothScrollPhysics({super.parent});

  @override
  _SmoothScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _SmoothScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double get minFlingVelocity => 200;

  @override
  double get maxFlingVelocity => 8000;

  @override
  SpringDescription get spring => const SpringDescription(
    mass: 80,
    stiffness: 100,
    damping: 1,
  );
}

class _SmoothScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const _SmoothScrollPhysics();
  }

  @override
  Widget buildScrollbar(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child; // Hide scrollbar
  }
}