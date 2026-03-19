// lib/features/home/widgets/social_bar_widget.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/responsive_helper.dart';

class SocialBarWidget extends StatelessWidget {
  const SocialBarWidget({super.key});

  static const _socials = [
    _SocialItem(
      icon: FontAwesomeIcons.medium,
      label: 'Medium',
      url: 'https://medium.com/@ucj.justice',
    ),
    _SocialItem(
      icon: FontAwesomeIcons.linkedin,
      label: 'LinkedIn',
      url: 'https://www.linkedin.com/in/uchenna-ndukwe-008953160/',
    ),
    _SocialItem(
      icon: FontAwesomeIcons.xTwitter,
      url: 'https://x.com/cpri3st?s=21',
    ),
    _SocialItem(
      icon: FontAwesomeIcons.github,
      label: 'GitHub',
      url: 'https://github.com/uche-hub',
    ),
  ];

  static const _email = 'ucj.justice@gmail.com';
  static const _emailUrl = 'mailto:ucj.justice@gmail.com';

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final hPad = ResponsiveHelper.getHorizontalPadding(context);

    if (isMobile) return _MobileSocialBar(hPad: hPad);

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Short line before socials
          _Line(width: 80),
          const SizedBox(width: 24),

          // Social links
          ..._socials.map(
            (s) => Padding(
              padding: const EdgeInsets.only(right: 32),
              child: _SocialLink(item: s),
            ),
          ),

          // Long line after socials — expands to fill remaining space before email
          const SizedBox(width: 8),
          const Expanded(child: _Line()),
          const SizedBox(width: 24),

          // Email
          _EmailLink(email: _email, url: _emailUrl),
        ],
      ),
    );
  }
}

// ─── Mobile layout ────────────────────────────────────────────────────────────

class _MobileSocialBar extends StatelessWidget {
  final double hPad;
  const _MobileSocialBar({required this.hPad});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Socials row
          Wrap(
            spacing: 28,
            runSpacing: 16,
            children: SocialBarWidget._socials
                .map((s) => _SocialLink(item: s))
                .toList(),
          ),
          const SizedBox(height: 20),
          const Divider(color: Color(0xFFCCCCCC), thickness: 0.8),
          const SizedBox(height: 16),
          _EmailLink(
            email: SocialBarWidget._email,
            url: SocialBarWidget._emailUrl,
          ),
        ],
      ),
    );
  }
}

// ─── Social link item ─────────────────────────────────────────────────────────

class _SocialLink extends StatefulWidget {
  final _SocialItem item;
  const _SocialLink({required this.item});

  @override
  State<_SocialLink> createState() => _SocialLinkState();
}

class _SocialLinkState extends State<_SocialLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(widget.item.url)),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 160),
          opacity: _hovered ? 0.6 : 1.0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                widget.item.icon,
                size: 13,
                color: const Color(0xFF2A2A2A),
              ),
              const SizedBox(width: 8),
              Text(
                widget.item.label ?? '',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2A2A2A),
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Email link ───────────────────────────────────────────────────────────────

class _EmailLink extends StatefulWidget {
  final String email;
  final String url;
  const _EmailLink({required this.email, required this.url});

  @override
  State<_EmailLink> createState() => _EmailLinkState();
}

class _EmailLinkState extends State<_EmailLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(widget.url)),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 160),
          opacity: _hovered ? 0.6 : 1.0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.email_rounded,
                size: 15,
                color: Color(0xFF1A1A1A),
              ),
              const SizedBox(width: 8),
              Text(
                widget.email,
                style: GoogleFonts.dmSans(
                  fontSize: isMobile ? 11 : 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Thin line ────────────────────────────────────────────────────────────────

class _Line extends StatelessWidget {
  final double? width; // null = expand to fill (use inside Expanded)
  const _Line({this.width});

  @override
  Widget build(BuildContext context) {
    return Container(height: 0.8, width: width, color: const Color(0xFFBBBBBB));
  }
}

// ─── Data class ───────────────────────────────────────────────────────────────

class _SocialItem {
  final FaIconData icon;
  final String? label;
  final String url;
  const _SocialItem({required this.icon, this.label, required this.url});
}
