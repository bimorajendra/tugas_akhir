import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.light(
          primary: AppColors.accent,
          onPrimary: AppColors.onAccent,
          surface: AppColors.surface,
          onSurface: AppColors.foreground,
          error: AppColors.destructive,
          onError: Colors.white,
        ),
        dividerColor: AppColors.border,
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: false,
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.foreground,
          titleTextStyle: AppTypography.headingMd,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        cardTheme: CardThemeData(
          color: AppColors.surface,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.roundedLg,
            side: const BorderSide(color: AppColors.border),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.onAccent,
            textStyle: AppTypography.button,
            minimumSize: const Size.fromHeight(48),
            shape: const RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.foreground,
            textStyle: AppTypography.button.copyWith(color: AppColors.foreground),
            minimumSize: const Size.fromHeight(48),
            side: const BorderSide(color: AppColors.border),
            shape: const RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          ),
        ),
      );
}
