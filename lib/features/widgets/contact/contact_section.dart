// lib/features/home/widgets/contact_section_widget.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/responsive_helper.dart';
import '../../../core/utils/emailjs_service.dart';
import '../../../core/utils/firebase_mail_service.dart';

// ─── Send status ──────────────────────────────────────────────────────────────

enum _SendStatus { idle, sending, success, error }

// ─── Main Widget ──────────────────────────────────────────────────────────────

class ContactSectionWidget extends StatefulWidget {
  const ContactSectionWidget({super.key});
  @override
  State<ContactSectionWidget> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSectionWidget> {
  final _nameCtrl    = TextEditingController();
  final _emailCtrl   = TextEditingController();
  final _companyCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  final _selectedTopics = <String>{};
  _SendStatus _status   = _SendStatus.idle;
  String? _errorMsg;

  static const _topics = [
    'Mobile App', 'Website Design', 'Branding',
    'Webflow development', 'App design', 'Graphic design', 'Wordpress',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _companyCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    // Validation Logic
    if (_nameCtrl.text.trim().isEmpty) {
      setState(() { _status = _SendStatus.error; _errorMsg = 'Please enter your name.'; });
      return;
    }
    final emailRx = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRx.hasMatch(_emailCtrl.text.trim())) {
      setState(() { _status = _SendStatus.error; _errorMsg = 'Please enter a valid email address.'; });
      return;
    }
    if (_selectedTopics.isEmpty) {
      setState(() { _status = _SendStatus.error; _errorMsg = 'Please select at least one topic.'; });
      return;
    }

    setState(() { _status = _SendStatus.sending; _errorMsg = null; });

    // UPDATED: Call FirebaseMailService instead of EmailJS
    final error = await FirebaseMailService.send(
      name:    _nameCtrl.text.trim(),
      email:   _emailCtrl.text.trim(),
      company: _companyCtrl.text.trim(),
      topics:  _selectedTopics.join(', '),
      message: _messageCtrl.text.trim(),
    );

    if (!mounted) return;

    if (error == null) {
      setState(() { _status = _SendStatus.success; _errorMsg = null; });
      _nameCtrl.clear(); _emailCtrl.clear();
      _companyCtrl.clear(); _messageCtrl.clear();
      _selectedTopics.clear();
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) setState(() => _status = _SendStatus.idle);
      });
    } else {
      setState(() { _status = _SendStatus.error; _errorMsg = error; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hPad     = ResponsiveHelper.getHorizontalPadding(context);
    final isMobile = ResponsiveHelper.isMobile(context);
    final w        = MediaQuery.of(context).size.width;

    return Container(
      key: const Key('contact'),
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(hPad, 80, hPad, 80),
      child: Column(children: [
        _ContactHeading(isMobile: isMobile, w: w),
        const SizedBox(height: 12),
        Text(
          'Have a nice works? reach out and let\'s chat.',
          textAlign: TextAlign.center,
          style: GoogleFonts.dmSans(fontSize: 14, color: Colors.black45, height: 1.6),
        ),
        const SizedBox(height: 48),

        isMobile ? _buildMobileForm() : _buildDesktopForm(),

        // Status messages
        if (_status == _SendStatus.success) ...[
          const SizedBox(height: 24),
          _StatusBanner(
            message: '✓  Message sent! I\'ll get back to you within 24 hours.',
            isError: false,
          ),
        ],
        if (_status == _SendStatus.error && _errorMsg != null) ...[
          const SizedBox(height: 24),
          _StatusBanner(message: _errorMsg!, isError: true),
        ],
      ]),
    );
  }

  Widget _buildDesktopForm() {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(child: _FormBody(
        nameCtrl: _nameCtrl, emailCtrl: _emailCtrl,
        companyCtrl: _companyCtrl, messageCtrl: _messageCtrl,
        selectedTopics: _selectedTopics, topics: _topics,
        onTopicToggle: (t) => setState(() =>
        _selectedTopics.contains(t) ? _selectedTopics.remove(t) : _selectedTopics.add(t)),
        onSend: _send, status: _status,
      )),
      const SizedBox(width: 40),
      const Padding(padding: EdgeInsets.only(top: 8), child: _ContactDotGrid()),
    ]);
  }

  Widget _buildMobileForm() {
    return _FormBody(
      nameCtrl: _nameCtrl, emailCtrl: _emailCtrl,
      companyCtrl: _companyCtrl, messageCtrl: _messageCtrl,
      selectedTopics: _selectedTopics, topics: _topics,
      onTopicToggle: (t) => setState(() =>
      _selectedTopics.contains(t) ? _selectedTopics.remove(t) : _selectedTopics.add(t)),
      onSend: _send, status: _status,
    );
  }
}

// ─── Heading ──────────────────────────────────────────────────────────────────

class _ContactHeading extends StatelessWidget {
  final bool isMobile;
  final double w;
  const _ContactHeading({required this.isMobile, required this.w});

  @override
  Widget build(BuildContext context) {
    final fs = w < 600 ? 30.0 : w < 900 ? 38.0 : w < 1200 ? 48.0 : 58.0;
    return Column(children: [
      Wrap(alignment: WrapAlignment.center, children: [
        Text('Say Hi! ', style: GoogleFonts.dmSans(fontSize: fs, fontWeight: FontWeight.w800, color: Colors.black38, height: 1.15)),
        Text('and tell me about', style: GoogleFonts.dmSans(fontSize: fs, fontWeight: FontWeight.w800, color: Colors.black, height: 1.15)),
      ]),
      Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
        CustomPaint(size: Size(isMobile ? 80 : 130, 22), painter: _ArrowPainter()),
        const SizedBox(width: 14),
        Text('your idea', style: GoogleFonts.dmSans(fontSize: fs, fontWeight: FontWeight.w800, color: Colors.black, height: 1.15)),
      ]),
    ]);
  }
}

class _ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.black..strokeWidth = 2.0..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    final y = size.height / 2;
    canvas.drawLine(Offset(0, y), Offset(size.width - 12, y), p);
    canvas.drawLine(Offset(size.width - 12, y), Offset(size.width - 24, y - 8), p);
    canvas.drawLine(Offset(size.width - 12, y), Offset(size.width - 24, y + 8), p);
  }
  @override bool shouldRepaint(_) => false;
}

// ─── Form Body ────────────────────────────────────────────────────────────────

class _FormBody extends StatefulWidget {
  final TextEditingController nameCtrl, emailCtrl, companyCtrl, messageCtrl;
  final Set<String> selectedTopics;
  final List<String> topics;
  final void Function(String) onTopicToggle;
  final VoidCallback onSend;
  final _SendStatus status;

  const _FormBody({
    super.key,
    required this.nameCtrl, required this.emailCtrl,
    required this.companyCtrl, required this.messageCtrl,
    required this.selectedTopics, required this.topics,
    required this.onTopicToggle, required this.onSend, required this.status,
  });

  @override State<_FormBody> createState() => _FormBodyState();
}

class _FormBodyState extends State<_FormBody> {
  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      // Name + Email
      isMobile
          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _FieldLabel('Name:*'),
        const SizedBox(height: 6),
        _FormTextField(ctrl: widget.nameCtrl, hint: 'Hello...'),
        const SizedBox(height: 28),
        _FieldLabel('Email:*'),
        const SizedBox(height: 6),
        _FormTextField(ctrl: widget.emailCtrl, hint: 'Where can I reply', keyboardType: TextInputType.emailAddress),
      ])
          : Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _FieldLabel('Name:*'),
          const SizedBox(height: 6),
          _FormTextField(ctrl: widget.nameCtrl, hint: 'Hello...'),
        ])),
        const SizedBox(width: 32),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _FieldLabel('Email.*'),
          const SizedBox(height: 6),
          _FormTextField(ctrl: widget.emailCtrl, hint: 'Where can I reply', keyboardType: TextInputType.emailAddress),
        ])),
      ]),

      // Company
      const SizedBox(height: 32),
      _FieldLabel('Company name'),
      const SizedBox(height: 6),
      _FormTextField(ctrl: widget.companyCtrl, hint: 'Your company or website?'),

      // Message
      const SizedBox(height: 32),
      _FieldLabel('Message'),
      const SizedBox(height: 6),
      _FormTextField(ctrl: widget.messageCtrl, hint: 'Tell me more about your project...', maxLines: 3),

      // Topics
      const SizedBox(height: 36),
      _FieldLabel("What's in your mind?*"),
      const SizedBox(height: 14),
      Wrap(
        spacing: 10,
        runSpacing: 10,
        children: widget.topics.map((t) => _TopicChip(
          label: t,
          selected: widget.selectedTopics.contains(t),
          onTap: () => widget.onTopicToggle(t),
        )).toList(),
      ),

      // Send
      const SizedBox(height: 40),
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Row(mainAxisSize: MainAxisSize.min, children: [
            CustomPaint(size: const Size(36, 44), painter: _WormArrowPainter()),
            const SizedBox(width: 8),
            _SendButton(onTap: widget.onSend, status: widget.status),
          ]),
          const SizedBox(height: 10),
          Text("I'll get back to you within 24 hours",
              style: GoogleFonts.dmSans(fontSize: 12, color: Colors.black38)),
        ]),
      ]),
    ]);
  }
}

// ─── Field Label ──────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87));
}

// ─── Text Field ───────────────────────────────────────────────────────────────

class _FormTextField extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;
  const _FormTextField({required this.ctrl, required this.hint, this.maxLines = 1, this.keyboardType});

  @override
  Widget build(BuildContext context) => TextField(
    controller: ctrl,
    maxLines: maxLines,
    keyboardType: keyboardType,
    style: GoogleFonts.dmSans(fontSize: 14, color: Colors.black87),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.dmSans(fontSize: 14, color: Colors.black26),
      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFCCCCCC), width: 1.2)),
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1.5)),
      border: const UnderlineInputBorder(),
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      filled: false,
    ),
  );
}

// ─── Topic Chip ───────────────────────────────────────────────────────────────

class _TopicChip extends StatefulWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TopicChip({required this.label, required this.selected, required this.onTap});
  @override State<_TopicChip> createState() => _TopicChipState();
}

class _TopicChipState extends State<_TopicChip> {
  bool _hov = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _hov = true),
    onExit:  (_) => setState(() => _hov = false),
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: widget.selected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: widget.selected ? Colors.black : Colors.black45, width: 1.2),
        ),
        child: Text(widget.label, style: GoogleFonts.dmSans(
          fontSize: 13, fontWeight: FontWeight.w500,
          color: widget.selected ? Colors.white : (_hov ? Colors.black : Colors.black87),
        )),
      ),
    ),
  );
}

// ─── Worm Arrow Painter ───────────────────────────────────────────────────────

class _WormArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.black..strokeWidth = 2.2..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final path = Path();
    path.moveTo(size.width * 0.5, 0);
    path.cubicTo(size.width * 1.1, size.height * 0.2, size.width * -0.1, size.height * 0.6, size.width * 0.4, size.height * 0.9);
    canvas.drawPath(path, p);
    final tip = Offset(size.width * 0.4, size.height * 0.9);
    canvas.drawLine(tip, Offset(tip.dx - 9, tip.dy - 11), p);
    canvas.drawLine(tip, Offset(tip.dx + 9,  tip.dy - 7),  p);
  }
  @override bool shouldRepaint(_) => false;
}

// ─── Send Button ──────────────────────────────────────────────────────────────

class _SendButton extends StatefulWidget {
  final VoidCallback onTap;
  final _SendStatus status;
  const _SendButton({required this.onTap, required this.status});
  @override State<_SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<_SendButton> {
  bool _hov = false;
  @override
  Widget build(BuildContext context) {
    final sending = widget.status == _SendStatus.sending;
    final success = widget.status == _SendStatus.success;
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit:  (_) => setState(() => _hov = false),
      cursor: sending ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: sending ? null : widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
          decoration: BoxDecoration(
            color: success
                ? const Color(0xFF1A7A3C)
                : (_hov && !sending ? const Color(0xFF222222) : Colors.black),
            borderRadius: BorderRadius.circular(50),
          ),
          child: sending
              ? const SizedBox(width: 20, height: 20,
              child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white))
              : success
              ? Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.check_rounded, size: 16, color: Colors.white),
            const SizedBox(width: 6),
            Text('Sent!', style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
          ])
              : Text('Send Me', style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
        ),
      ),
    );
  }
}

// ─── Status Banner ────────────────────────────────────────────────────────────

class _StatusBanner extends StatelessWidget {
  final String message;
  final bool isError;
  const _StatusBanner({required this.message, required this.isError});
  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    decoration: BoxDecoration(
      color: isError ? const Color(0xFFFFF0F0) : const Color(0xFFF0FFF4),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: isError ? const Color(0xFFFFCDD2) : const Color(0xFFC8E6C9), width: 1),
    ),
    child: Text(message, style: GoogleFonts.dmSans(
      fontSize: 13, fontWeight: FontWeight.w500,
      color: isError ? const Color(0xFFB71C1C) : const Color(0xFF1B5E20),
    )),
  );
}

// ─── Dot Grid ─────────────────────────────────────────────────────────────────

class _ContactDotGrid extends StatelessWidget {
  const _ContactDotGrid();
  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: const Size(80, 80), painter: _ContactDotPainter());
}

class _ContactDotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const cols = 6, rows = 6;
    final cw = size.width / cols, ch = size.height / rows;
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final dist = sqrt(pow(c - cols / 2 + 0.5, 2) + pow(r - rows / 2 + 0.5, 2));
        final maxD = sqrt(pow(cols / 2.0, 2) + pow(rows / 2.0, 2));
        final opacity = (1.0 - dist / maxD * 0.7).clamp(0.1, 0.7);
        final radius  = (2.0 - dist * 0.15).clamp(0.7, 2.0);
        canvas.drawCircle(
          Offset(c * cw + cw / 2, r * ch + ch / 2), radius,
          Paint()
            ..color = Colors.black.withOpacity(opacity)
            ..maskFilter = dist > 2 ? const MaskFilter.blur(BlurStyle.normal, 0.8) : null,
        );
      }
    }
  }
  @override bool shouldRepaint(_) => false;
}