import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  const AppTypography._();

  static TextStyle get display => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 28, fontWeight: FontWeight.w700, height: 1.2,
        letterSpacing: -0.56, color: AppColors.foreground,
      );
  static TextStyle get headingLg => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 22, fontWeight: FontWeight.w600, height: 1.25,
        letterSpacing: -0.33, color: AppColors.foreground,
      );
  static TextStyle get headingMd => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 17, fontWeight: FontWeight.w600, height: 1.3,
        letterSpacing: -0.17, color: AppColors.foreground,
      );
  static TextStyle get bodyLg => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 15, fontWeight: FontWeight.w400, height: 1.5,
        color: AppColors.foreground,
      );
  static TextStyle get bodyMd => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 14, fontWeight: FontWeight.w400, height: 1.5,
        color: AppColors.foreground,
      );
  static TextStyle get bodySm => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 12, fontWeight: FontWeight.w500, height: 1.4,
        color: AppColors.mutedForeground,
      );
  static TextStyle get caption => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 11, fontWeight: FontWeight.w600, height: 1.3,
        letterSpacing: 0.22, color: AppColors.mutedForeground,
      );
  static TextStyle get label => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 13, fontWeight: FontWeight.w600, height: 1.3,
        color: AppColors.foreground,
      );
  static TextStyle get button => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 14, fontWeight: FontWeight.w600, height: 1.0,
        letterSpacing: 0.14, color: AppColors.onAccent,
      );
}
