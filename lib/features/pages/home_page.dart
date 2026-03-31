import 'dart:ui';
import 'dart:async';
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
import '../widgets/values/value_proposition_widget.dart';

class HomeScreen extends StatefulWidget {
  final String? initialSection;
  const HomeScreen({super.key, this.initialSection});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isScrolling = false;
  Timer? _stopTimer;

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

  // Logic to detect scroll start and stop
  void _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (!_isScrolling) {
        setState(() {
          _isScrolling = true;
        });
      }

      // Reset the timer every time a scroll update happens
      _stopTimer?.cancel();
      _stopTimer = Timer(const Duration(milliseconds: 1000), () {
        if (mounted) {
          setState(() {
            _isScrolling = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _stopTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scrollProvider = context.watch<ScrollProvider>();
    final width = MediaQuery.of(context).size.width;
    final isMobileOrTablet = width < 1100;

    final ScrollPhysics physics = isMobileOrTablet
        ? const ClampingScrollPhysics()
        : const _DesktopSmoothPhysics();

    return Scaffold(
      backgroundColor: Colors.white,
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          _onScrollNotification(notification);
          return false;
        },
        child: Stack(
          children: [
            // 1. Main scrollable content
            ScrollConfiguration(
              behavior: _PortfolioScrollBehavior(
                isMobileOrTablet: isMobileOrTablet,
              ),
              child: CustomScrollView(
                controller: scrollProvider.scrollController,
                physics: physics,
                slivers: [
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverToBoxAdapter(
                    key: scrollProvider.heroKey,
                    child: const HeroSectionWidget(),
                  ),
                  const SliverToBoxAdapter(child: SocialBarWidget()),
                  // const SliverToBoxAdapter(
                  //   // key: scrollProvider.projectsKey,
                  //   child: const ValuePropositionWidget(),
                  // ),
                  SliverToBoxAdapter(
                    key: scrollProvider.skillKey,
                    child: const ServicesSectionWidget(),
                  ),
                  SliverToBoxAdapter(
                    key: scrollProvider.experienceKey,
                    child: const ExperienceSectionWidget(),
                  ),
                  SliverToBoxAdapter(
                    key: scrollProvider.projectsKey,
                    child: const CaseStudySectionWidget(),
                  ),

                  SliverToBoxAdapter(
                    key: scrollProvider.contactKey,
                    child: const ContactSectionWidget(),
                  ),
                  const SliverToBoxAdapter(child: FooterWidget()),
                  const SliverToBoxAdapter(child: SizedBox.shrink()),
                ],
              ),
            ),

            // 2. Sticky Navbar
            Positioned(top: 0, left: 0, right: 0, child: const NavbarWidget()),

            // 3. Conditional Glass Blur at Bottom
            _BottomGlassBlur(isVisible: _isScrolling),
          ],
        ),
      ),
    );
  }
}

// ─── Animated Bottom Glass Blur Widget ───────────────────────────────────────

class _BottomGlassBlur extends StatelessWidget {
  final bool isVisible;
  const _BottomGlassBlur({required this.isVisible});

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      bottom: isVisible ? 0 : -60, // smaller hide distance
      left: 0,
      right: 0,
      height: 60, // much shorter → only top edge feel
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 700),
        opacity: isVisible ? 0.70 : 0.0, // softer max opacity
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 10.0,
              sigmaY: 10.0,
            ), // reduced blur intensity
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.5, 1.0],
                  colors: [
                    Colors.white.withOpacity(
                      0.0,
                    ), // fully transparent at very top
                    Colors.white.withOpacity(0.12), // gentle middle
                    Colors.white.withOpacity(
                      0.28,
                    ), // slightly stronger at bottom
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Desktop smooth scroll physics ──────────────────────────────────────────

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
  SpringDescription get spring =>
      const SpringDescription(mass: 30, stiffness: 120, damping: 1);
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
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
