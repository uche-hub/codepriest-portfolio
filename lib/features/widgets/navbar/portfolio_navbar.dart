import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/responsive_helper.dart';
import '../../providers/scroll_provider.dart';

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScrollProvider>(
      builder: (context, sp, _) {
        final isScrolled = sp.scrollOffset > 60;
        final t = (sp.scrollOffset / 120.0).clamp(0.0, 1.0);
        final screenW = MediaQuery.of(context).size.width;
        final vPadBase = screenW < 600 ? 16.0 : screenW < 1100 ? 18.0 : 22.0;
        final vPad = lerpDouble(vPadBase, 8, t)!;
        final hPad = ResponsiveHelper.getHorizontalPadding(context);

        final targetBlur = isScrolled ? 18.0 : 0.0;

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: targetBlur, end: targetBlur),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          builder: (context, blur, _) {
            return ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: isScrolled ? 0.55 : 0.0),
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black.withValues(alpha: isScrolled ? 0.08 : 0.0),
                        width: 1,
                      ),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
                  child: LayoutBuilder(builder: (context, constraints) {
                    final w = constraints.maxWidth;
                    if (w < 600) return _MobileNav(scrollProvider: sp, t: t);
                    if (w < 1100) return _TabletNav(scrollProvider: sp, t: t);
                    return _DesktopNav(scrollProvider: sp, t: t);
                  }),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ─── Desktop ──────────────────────────────────────────────────────────────────

class _DesktopNav extends StatelessWidget {
  final ScrollProvider scrollProvider;
  final double t;
  const _DesktopNav({required this.scrollProvider, required this.t});

  @override
  Widget build(BuildContext context) {
    final linesOpacity = (1.0 - t * 1.6).clamp(0.0, 1.0);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Logo
        _LogoWidget(t: t),
        const SizedBox(width: 12),

        // Two diagonal lines — fade out on scroll
        Opacity(
          opacity: linesOpacity,
          child: const _DiagonalLines(),
        ),

        const Spacer(),

        // Nav links — always visible
        _NavLinks(scrollProvider: scrollProvider, t: t),
      ],
    );
  }
}

// ─── Mobile ───────────────────────────────────────────────────────────────────

class _MobileNav extends StatelessWidget {
  final ScrollProvider scrollProvider;
  final double t;
  const _MobileNav({required this.scrollProvider, required this.t});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _LogoWidget(t: t),
        _MobileMenuButton(scrollProvider: scrollProvider),
      ],
    );
  }
}

// ─── Tablet (600–1099px) ──────────────────────────────────────────────────────
// Logo left, compact links right — no descriptions, no diagonal lines.

class _TabletNav extends StatelessWidget {
  final ScrollProvider scrollProvider;
  final double t;
  const _TabletNav({required this.scrollProvider, required this.t});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _LogoWidget(t: t),
        const Spacer(),
        // Compact links — title + arrow only, no description block
        Row(
          children: AppConstants.navLinks.map((link) {
            final isLast = link == AppConstants.navLinks.last;
            return Padding(
              padding: EdgeInsets.only(right: isLast ? 0 : 28),
              child: _CompactNavLink(
                title: link['title']!,
                onTap: () {
                  final route = link['route']!.replaceFirst('/', '');
                  scrollProvider.scrollToSection(route);
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _CompactNavLink extends StatefulWidget {
  final String title;
  final VoidCallback onTap;
  const _CompactNavLink({required this.title, required this.onTap});

  @override
  State<_CompactNavLink> createState() => _CompactNavLinkState();
}

class _CompactNavLinkState extends State<_CompactNavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 3),
                Icon(Icons.arrow_outward, size: 12, color: Colors.black),
              ],
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 1,
              width: _hovered ? 70 : 0,
              color: Colors.black,
              margin: const EdgeInsets.only(top: 3),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Logo ─────────────────────────────────────────────────────────────────────

class _LogoWidget extends StatelessWidget {
  final double t;
  const _LogoWidget({required this.t});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final fontSize = isMobile
        ? lerpDouble(22, 17, t)!
        : lerpDouble(28, 21, t)!;
    final underlineW = isMobile
        ? lerpDouble(66, 51, t)!
        : lerpDouble(84, 63, t)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "it's me",
          style: GoogleFonts.dmSans(
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            letterSpacing: -0.5,
          ),
        ),
        Container(
          height: 2,
          width: underlineW,
          color: Colors.black,
          margin: const EdgeInsets.only(top: 3),
        ),
      ],
    );
  }
}

// ─── Two Diagonal Lines ───────────────────────────────────────────────────────
// Exactly as in the screenshot: two parallel lines angled ~25°, emerging from
// the very top of the viewport and cutting diagonally through the navbar area.
// Line 1 is shorter, line 2 is longer and slightly to its right.

class _DiagonalLines extends StatelessWidget {
  const _DiagonalLines();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 80,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Line 1 — shorter
          Positioned(
            top: -22,
            left: 4,
            child: Transform.rotate(
              angle: 0.38,
              alignment: Alignment.topCenter,
              child: Container(
                width: 1.5,
                height: 68,
                color: Colors.black,
              ),
            ),
          ),
          // Line 2 — longer, sits a bit to the right
          Positioned(
            top: -38,
            left: 22,
            child: Transform.rotate(
              angle: 0.38,
              alignment: Alignment.topCenter,
              child: Container(
                width: 1.5,
                height: 96,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Nav Links ────────────────────────────────────────────────────────────────

class _NavLinks extends StatelessWidget {
  final ScrollProvider scrollProvider;
  final double t;
  const _NavLinks({required this.scrollProvider, required this.t});

  @override
  Widget build(BuildContext context) {
    final links = AppConstants.navLinks;
    // Descriptions fade out fast as nav compresses
    final descOpacity = (1.0 - t * 2.2).clamp(0.0, 1.0);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: links.map((link) {
        final isLast = link == links.last;
        return Padding(
          padding: EdgeInsets.only(right: isLast ? 0 : 36),
          child: _NavLinkItem(
            title: link['title']!,
            description: link['description']!,
            descOpacity: descOpacity,
            onTap: () {
              final route = link['route']!.replaceFirst('/', '');
              scrollProvider.scrollToSection(route);
            },
          ),
        );
      }).toList(),
    );
  }
}

class _NavLinkItem extends StatefulWidget {
  final String title;
  final String description;
  final double descOpacity;
  final VoidCallback onTap;

  const _NavLinkItem({
    required this.title,
    required this.description,
    required this.descOpacity,
    required this.onTap,
  });

  @override
  State<_NavLinkItem> createState() => _NavLinkItemState();
}

class _NavLinkItemState extends State<_NavLinkItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Black line above each link
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 1,
              width: _hovered ? 95 : 80,
              color: Colors.black,
              margin: const EdgeInsets.only(bottom: 7),
            ),

            // Title + diagonal arrow
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(width: 4),
                AnimatedRotation(
                  turns: _hovered ? -0.04 : 0,
                  duration: const Duration(milliseconds: 180),
                  child: const Icon(
                    Icons.arrow_outward,
                    size: 13,
                    color: Colors.black,
                  ),
                ),
              ],
            ),

            // Description — collapses smoothly as nav shrinks
            if (widget.descOpacity > 0.01) ...[
              const SizedBox(height: 4),
              Opacity(
                opacity: widget.descOpacity,
                child: SizedBox(
                  width: 115,
                  child: Text(
                    widget.description,
                    style: GoogleFonts.dmSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Mobile Menu ──────────────────────────────────────────────────────────────

class _MobileMenuButton extends StatefulWidget {
  final ScrollProvider scrollProvider;
  const _MobileMenuButton({required this.scrollProvider});

  @override
  State<_MobileMenuButton> createState() => _MobileMenuButtonState();
}

class _MobileMenuButtonState extends State<_MobileMenuButton> {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => setState(() => _isOpen = !_isOpen),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              _isOpen ? Icons.close : Icons.menu,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
        if (_isOpen)
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: AppConstants.navLinks.map((link) {
                return GestureDetector(
                  onTap: () {
                    setState(() => _isOpen = false);
                    final route = link['route']!.replaceFirst('/', '');
                    widget.scrollProvider.scrollToSection(route);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Text(
                          link['title']!,
                          style: GoogleFonts.dmSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_outward, size: 14),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}