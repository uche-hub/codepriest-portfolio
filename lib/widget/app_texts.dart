import 'package:codepriest_portfolio/core/constants/app_colors.dart';
import 'package:codepriest_portfolio/core/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final Color? color;

  const AppText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style?.copyWith(color: color) ?? TextStyle(color: color),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

// Regular Text (16-32px)
class AppTextRegular extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? fontSize;

  const AppTextRegular(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final double size =
        fontSize ??
        Responsive.getResponsiveValue(context, mobile: 16, tablet: 20, web: 24);

    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: size,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.textPrimary,
        height: 1.5,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

// Medium Text (24-40px)
class AppTextMedium extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? fontSize;

  const AppTextMedium(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final double size =
        fontSize ??
        Responsive.getResponsiveValue(context, mobile: 24, tablet: 32, web: 40);

    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: size,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.textPrimary,
        height: 1.3,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

// Bold Text (40-64px)
class AppTextBold extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? fontSize;

  const AppTextBold(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final double size =
        fontSize ??
        Responsive.getResponsiveValue(context, mobile: 40, tablet: 52, web: 64);

    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.textPrimary,
        height: 1.2,
        letterSpacing: -0.5,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

// Utility text styles
class AppTextStyles {
  static TextStyle regular({
    double? fontSize,
    Color? color,
    FontWeight? fontWeight,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize ?? 16,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color ?? AppColors.textPrimary,
    );
  }

  static TextStyle medium({
    double? fontSize,
    Color? color,
    FontWeight? fontWeight,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize ?? 24,
      fontWeight: fontWeight ?? FontWeight.w500,
      color: color ?? AppColors.textPrimary,
    );
  }

  static TextStyle bold({
    double? fontSize,
    Color? color,
    FontWeight? fontWeight,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize ?? 40,
      fontWeight: fontWeight ?? FontWeight.w700,
      color: color ?? AppColors.textPrimary,
    );
  }
}
