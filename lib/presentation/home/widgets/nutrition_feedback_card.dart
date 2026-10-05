import 'package:flutter/material.dart';
import 'package:gizilens/core/theme/app_colors.dart';
import 'package:gizilens/core/theme/app_spacing.dart';
import 'package:gizilens/core/theme/app_typography.dart';
import 'package:gizilens/domain/models/nutrition_feedback.dart';

class NutritionFeedbackCard extends StatelessWidget {
  final NutritionFeedback feedback;
  final VoidCallback? onDetailTap;

  const NutritionFeedbackCard({super.key, required this.feedback, this.onDetailTap});

  Color get _borderColor => switch (feedback.severity) {
        FeedbackSeverity.warning => const Color(0xFFFDE68A),
        FeedbackSeverity.critical => const Color(0xFFFECACA),
        FeedbackSeverity.positive => const Color(0xFFBBF7D0),
        FeedbackSeverity.info => AppColors.border,
      };
  Color get _backgroundColor => switch (feedback.severity) {
        FeedbackSeverity.warning => const Color(0xFFFFFDF5),
        FeedbackSeverity.critical => const Color(0xFFFFF5F5),
        FeedbackSeverity.positive => const Color(0xFFF8FDF9),
        FeedbackSeverity.info => AppColors.surface,
      };
  IconData get _icon => switch (feedback.severity) {
        FeedbackSeverity.warning => Icons.warning_amber_rounded,
        FeedbackSeverity.critical => Icons.error_outline_rounded,
        FeedbackSeverity.positive => Icons.check_circle_outline_rounded,
        FeedbackSeverity.info => Icons.info_outline_rounded,
      };
  Color get _iconColor => switch (feedback.severity) {
        FeedbackSeverity.warning => AppColors.warning,
        FeedbackSeverity.critical => AppColors.destructive,
        FeedbackSeverity.positive => AppColors.success,
        FeedbackSeverity.info => AppColors.accent,
      };

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(color: _backgroundColor, borderRadius: AppRadius.roundedLg, border: Border.all(color: _borderColor)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(padding: const EdgeInsets.all(AppSpacing.xs), decoration: BoxDecoration(color: _iconColor.withValues(alpha: 0.12), shape: BoxShape.circle), child: Icon(_icon, size: 18, color: _iconColor)),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(feedback.title, style: AppTypography.headingMd.copyWith(fontSize: 15)), const SizedBox(height: 2), Text(feedback.message, style: AppTypography.bodySm.copyWith(fontWeight: FontWeight.w400))])),
          ]),
          if (onDetailTap != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Align(alignment: Alignment.centerRight, child: TextButton(onPressed: onDetailTap, style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xs), minimumSize: const Size(44, 44)), child: Row(mainAxisSize: MainAxisSize.min, children: [Text('Lihat detail', style: AppTypography.bodySm.copyWith(color: AppColors.accent, fontWeight: FontWeight.w600)), const SizedBox(width: 2), const Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.accent)]))),
          ],
        ]),
      );
}
