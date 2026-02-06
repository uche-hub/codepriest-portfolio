import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryDark = Color(0xFF090D33);
  static const Color primaryPurple = Color(0xFF43127B);
  static const Color accentPurple = Color(0xFF4C18C1);
  static const Color secondaryDark = Color(0xFF202342);
  static const Color white = Color(0xFFFFFFFF);

  // Gradient Colors
  static const LinearGradient purpleGradient = LinearGradient(
    colors: [primaryPurple, accentPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [primaryDark, secondaryDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Additional UI Colors
  static const Color textPrimary = white;
  static const Color textSecondary = Color(0xFFB8B8D1);
  static const Color border = Color(0xFF4C18C1);
  static const Color cardBackground = Color(0xFF0F1229);

  // Opacity variants
  static Color white10 = white.withValues(alpha: 0.1);
  static Color white20 = white.withValues(alpha: 0.2);
  static Color white30 = white.withValues(alpha: 0.3);
  static Color white50 = white.withValues(alpha: 0.5);
  static Color white70 = white.withValues(alpha: 0.7);
  static Color purple10 = accentPurple.withValues(alpha: 0.1);
  static Color purple20 = accentPurple.withValues(alpha: 0.2);
  static Color purple30 = accentPurple.withValues(alpha: 0.3);
}
