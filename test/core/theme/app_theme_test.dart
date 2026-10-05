import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizilens/core/theme/app_colors.dart';
import 'package:gizilens/core/theme/app_spacing.dart';
import 'package:gizilens/core/theme/app_theme.dart';
import 'package:gizilens/core/theme/app_typography.dart';

void main() {
  group('AppTheme & Design Tokens Tests', () {
    test('AppColors verifies emerald accent and semantic status palette', () {
      expect(AppColors.accent, const Color(0xFF047857));
      expect(AppColors.background, const Color(0xFFF8FAFC));
      expect(AppColors.surface, const Color(0xFFFFFFFF));
      expect(AppColors.border, const Color(0xFFE2E8F0));
      expect(AppColors.foreground, const Color(0xFF0F172A));
      expect(AppColors.mutedForeground, const Color(0xFF475569));
      expect(AppColors.statusCukup, const Color(0xFF16A34A));
      expect(AppColors.statusMendekatiBatas, const Color(0xFFD97706));
      expect(AppColors.statusBerlebih, const Color(0xFFDC2626));
      expect(AppColors.statusRendah, const Color(0xFF0284C7));
      expect(AppColors.statusBelumTersedia, const Color(0xFF94A3B8));
    });

    test('AppSpacing and AppRadius match the design scale', () {
      expect(AppSpacing.xs, 4.0);
      expect(AppSpacing.sm, 8.0);
      expect(AppSpacing.md, 16.0);
      expect(AppSpacing.lg, 24.0);
      expect(AppSpacing.xl, 32.0);
      expect(AppSpacing.xxl, 48.0);
      expect(AppSpacing.screenHorizontal, 20.0);
      expect(AppRadius.sm, 6.0);
      expect(AppRadius.md, 10.0);
      expect(AppRadius.lg, 16.0);
      expect(AppRadius.xl, 24.0);
      expect(AppRadius.full, 9999.0);
    });

    test('AppTypography provides Inter hierarchy styles', () {
      expect(AppTypography.display.fontSize, 28.0);
      expect(AppTypography.display.fontWeight, FontWeight.w700);
      expect(AppTypography.headingLg.fontSize, 22.0);
      expect(AppTypography.headingLg.fontWeight, FontWeight.w600);
      expect(AppTypography.headingMd.fontSize, 17.0);
      expect(AppTypography.headingMd.fontWeight, FontWeight.w600);
      expect(AppTypography.bodyMd.fontSize, 14.0);
      expect(AppTypography.bodyMd.fontWeight, FontWeight.w400);
      expect(AppTypography.button.fontSize, 14.0);
      expect(AppTypography.button.fontWeight, FontWeight.w600);
    });

    test('AppTheme produces configured ThemeData', () {
      final theme = AppTheme.lightTheme;
      expect(theme.scaffoldBackgroundColor, AppColors.background);
      expect(theme.colorScheme.primary, AppColors.accent);
      expect(theme.colorScheme.surface, AppColors.surface);
      expect(theme.dividerColor, AppColors.border);
    });
  });
}
