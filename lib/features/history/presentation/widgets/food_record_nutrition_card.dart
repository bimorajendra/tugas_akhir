import 'package:flutter/material.dart';
import 'package:gizilens/core/theme/app_colors.dart';
import 'package:gizilens/core/theme/app_spacing.dart';

class FoodRecordNutritionCard extends StatelessWidget {
  final double totalCalories;
  final double proteinGrams;
  final double carbsGrams;
  final double fatGrams;

  const FoodRecordNutritionCard({
    super.key,
    required this.totalCalories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
  });

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
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
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(
              child: Text(
                'Total Energi',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.mutedForeground,
                ),
              ),
            ),
            Text(
              totalCalories.toStringAsFixed(0),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              'kkal',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.mutedForeground,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        const Divider(height: 1, color: AppColors.border),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _MacroValue(
                label: 'Protein',
                value: proteinGrams,
                color: AppColors.info,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _MacroValue(
                label: 'Karbohidrat',
                value: carbsGrams,
                color: AppColors.warning,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _MacroValue(
                label: 'Lemak',
                value: fatGrams,
                color: AppColors.destructive,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _MacroValue extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _MacroValue({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.mutedForeground,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: AppSpacing.xs),
      Text(
        '${value.toStringAsFixed(1)}g',
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: AppColors.foreground,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}
