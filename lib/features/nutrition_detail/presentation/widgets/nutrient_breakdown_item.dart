import 'package:flutter/material.dart';
import 'package:gizilens/core/theme/app_colors.dart';
import 'package:gizilens/core/theme/app_spacing.dart';

enum NutrientStatus { low, adequate, approachingLimit, excessive, noTarget }

class NutrientData {
  final String? id;
  final String name;
  final double value;
  final String unit;
  final double? target;
  final double? _reportedPercentage;
  final NutrientStatus status;
  final String? feedback;
  final bool isMacro;

  const NutrientData({
    this.id,
    required this.name,
    required this.value,
    required this.unit,
    this.target,
    double? percentage,
    required this.status,
    this.feedback,
    this.isMacro = false,
  }) : _reportedPercentage = percentage;

  double? get percentage {
    if (target == null || target == 0) return null;
    return _reportedPercentage ?? (value / target!) * 100;
  }
}

class NutrientBreakdownItem extends StatelessWidget {
  final NutrientData nutrient;

  const NutrientBreakdownItem({super.key, required this.nutrient});

  Color get _statusColor => switch (nutrient.status) {
    NutrientStatus.low => AppColors.info,
    NutrientStatus.adequate => AppColors.success,
    NutrientStatus.approachingLimit => AppColors.warning,
    NutrientStatus.excessive => AppColors.destructive,
    NutrientStatus.noTarget => AppColors.statusBelumTersedia,
  };

  Color get _statusTextColor => AppColors.foreground;

  String get _statusLabel => switch (nutrient.status) {
    NutrientStatus.low => 'Rendah',
    NutrientStatus.adequate => 'Cukup',
    NutrientStatus.approachingLimit => 'Mendekati batas',
    NutrientStatus.excessive => 'Berlebih',
    NutrientStatus.noTarget => 'Target belum tersedia',
  };

  String _formatNumber(double value) => value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    final percent = nutrient.percentage;
    final amount = nutrient.target == null
        ? '${_formatNumber(nutrient.value)} ${nutrient.unit}'
        : '${_formatNumber(nutrient.value)} / ${_formatNumber(nutrient.target!)} ${nutrient.unit}';
    final safeFraction = percent == null || !percent.isFinite
        ? null
        : (percent / 100).clamp(0.0, 1.0).toDouble();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.roundedLg,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  nutrient.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Container(
                constraints: const BoxConstraints(minHeight: 28),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.12),
                  borderRadius: AppRadius.roundedFull,
                ),
                child: Text(
                  _statusLabel,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: _statusTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Text(
                  amount,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.mutedForeground,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (percent != null)
                Text(
                  '${percent.toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: _statusTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
          if (safeFraction != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Semantics(
              label: 'Progres ${nutrient.name}',
              value: '${percent!.toStringAsFixed(0)} persen',
              child: ExcludeSemantics(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: safeFraction),
                  duration: MediaQuery.of(context).disableAnimations
                      ? Duration.zero
                      : const Duration(milliseconds: 750),
                  curve: Curves.easeOutCubic,
                  builder: (context, progress, _) => ClipRRect(
                    borderRadius: AppRadius.roundedFull,
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 7,
                      backgroundColor: AppColors.muted,
                      valueColor: AlwaysStoppedAnimation(_statusColor),
                    ),
                  ),
                ),
              ),
            ),
          ],
          if (nutrient.feedback != null &&
              nutrient.feedback!.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: AppRadius.roundedMd,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: AppColors.mutedForeground,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      nutrient.feedback!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.foreground,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
