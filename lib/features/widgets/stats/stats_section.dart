// lib/features/home/widgets/stats_section_widget.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/constants/responsive_helper.dart';

class _Stat {
  final FaIconData icon;
  final int value;
  final String suffix;
  final String label;
  const _Stat({
    required this.icon,
    required this.value,
    required this.suffix,
    required this.label,
  });
}

const _stats = [
  _Stat(
    icon: FontAwesomeIcons.clipboardCheck,
    value: 2450,
    suffix: '',
    label: 'Project Completed Done',
  ),
  _Stat(
    icon: FontAwesomeIcons.handshake,
    value: 1085,
    suffix: '',
    label: 'Satisfied Clients',
  ),
  _Stat(
    icon: FontAwesomeIcons.peopleGroup,
    value: 7,
    suffix: '0',
    label: 'My Team Members',
  ),
  _Stat(
    icon: FontAwesomeIcons.globe,
    value: 2790,
    suffix: '',
    label: 'World Wide Customer',
  ),
];

class StatsSectionWidget extends StatefulWidget {
  const StatsSectionWidget({super.key});
  @override
  State<StatsSectionWidget> createState() => _StatsSectionState();
}

class _StatsSectionState extends State<StatsSectionWidget> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final hPad = ResponsiveHelper.getHorizontalPadding(context);
    final isMobile = ResponsiveHelper.isMobile(context);

    return VisibilityDetectorWrapper(
      onVisible: () {
        if (!_visible) setState(() => _visible = true);
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: hPad),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Color(0xFFDDDDDD), width: 1),
              bottom: BorderSide(color: Color(0xFFDDDDDD), width: 1),
            ),
          ),
          child: isMobile ? _buildMobile(context) : _buildDesktop(context),
        ),
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: List.generate(_stats.length, (i) {
          final isLast = i == _stats.length - 1;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _StatCell(stat: _stats[i], animate: _visible),
                ),
                if (!isLast)
                  Container(width: 1, color: const Color(0xFFDDDDDD)),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMobile(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCell(stat: _stats[0], animate: _visible),
            ),
            Container(width: 1, height: 160, color: const Color(0xFFDDDDDD)),
            Expanded(
              child: _StatCell(stat: _stats[1], animate: _visible),
            ),
          ],
        ),
        Container(
          width: double.infinity,
          height: 1,
          color: const Color(0xFFDDDDDD),
        ),
        Row(
          children: [
            Expanded(
              child: _StatCell(stat: _stats[2], animate: _visible),
            ),
            Container(width: 1, height: 160, color: const Color(0xFFDDDDDD)),
            Expanded(
              child: _StatCell(stat: _stats[3], animate: _visible),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCell extends StatefulWidget {
  final _Stat stat;
  final bool animate;
  const _StatCell({required this.stat, required this.animate});
  @override
  State<_StatCell> createState() => _StatCellState();
}

class _StatCellState extends State<_StatCell>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutQuart);
  }

  @override
  void didUpdateWidget(_StatCell old) {
    super.didUpdateWidget(old);
    if (widget.animate && !old.animate) _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final numSize = isMobile ? 32.0 : 48.0;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: isMobile ? 28 : 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FaIcon(
            widget.stat.icon,
            size: isMobile ? 28 : 36,
            color: Colors.black87,
          ),
          SizedBox(height: isMobile ? 16 : 20),
          AnimatedBuilder(
            animation: _anim,
            builder: (_, _) {
              final val = (widget.stat.value * _anim.value).round();
              final display = widget.stat.suffix == '0' ? '0$val' : '$val';
              return Text(
                display,
                style: GoogleFonts.dmSans(
                  fontSize: numSize,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  height: 1.0,
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Text(
            widget.stat.label,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// Lightweight visibility trigger using NotificationListener + LayoutBuilder
class VisibilityDetectorWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback onVisible;
  const VisibilityDetectorWrapper({
    required this.child,
    required this.onVisible,
    super.key,
  });
  @override
  State<VisibilityDetectorWrapper> createState() => _VDWState();
}

class _VDWState extends State<VisibilityDetectorWrapper> {
  bool _fired = false;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      child: Builder(
        builder: (ctx) {
          if (!_fired) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _checkVisible(ctx);
            });
          }
          return widget.child;
        },
      ),
    );
  }

  void _checkVisible(BuildContext ctx) {
    if (_fired) return;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;
    final pos = box.localToGlobal(Offset.zero);
    final screen = MediaQuery.of(ctx).size.height;
    if (pos.dy < screen * 1.1) {
      _fired = true;
      widget.onVisible();
    }
  }
}
