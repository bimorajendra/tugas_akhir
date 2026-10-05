import 'package:flutter/material.dart';
import 'package:gizilens/core/theme/app_colors.dart';
import 'package:gizilens/core/theme/app_spacing.dart';

class DetectedFoodItem {
  const DetectedFoodItem({
    required this.id,
    required this.name,
    required this.portion,
    required this.portionUnit,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.dynamicNutrients,
  });

  final String id;
  final String name;
  final double portion;
  final String portionUnit;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final Map<String, String>? dynamicNutrients;

  DetectedFoodItem copyWith({
    String? id,
    String? name,
    double? portion,
    String? portionUnit,
    int? calories,
    double? protein,
    double? carbs,
    double? fat,
    Map<String, String>? dynamicNutrients,
  }) {
    return DetectedFoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      portion: portion ?? this.portion,
      portionUnit: portionUnit ?? this.portionUnit,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      dynamicNutrients: dynamicNutrients ?? this.dynamicNutrients,
    );
  }
}

class FoodItemCard extends StatelessWidget {
  const FoodItemCard({super.key, required this.item, this.onEditPortion});

  final DetectedFoodItem item;
  final ValueChanged<DetectedFoodItem>? onEditPortion;

  String _formatPortion(double value) => value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toString();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nutrients = item.dynamicNutrients;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name, style: theme.textTheme.titleMedium),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '${_formatPortion(item.portion)} ${item.portionUnit}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Container(
                  constraints: const BoxConstraints(minHeight: 32),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.muted,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${item.calories} kkal',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                _MacroValue(label: 'Protein', value: item.protein),
                _MacroValue(label: 'Karbohidrat', value: item.carbs),
                _MacroValue(label: 'Lemak', value: item.fat),
              ],
            ),
            if (nutrients != null && nutrients.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: nutrients.entries
                    .map(
                      (entry) =>
                          _NutrientChip(label: entry.key, value: entry.value),
                    )
                    .toList(growable: false),
              ),
            ],
            if (onEditPortion != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  key: Key('edit_portion_${item.id}'),
                  onPressed: () => onEditPortion!(item),
                  icon: const Icon(Icons.tune_rounded, size: 18),
                  label: const Text('Ubah Porsi'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MacroValue extends StatelessWidget {
  const _MacroValue({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      constraints: const BoxConstraints(minHeight: 36),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.muted,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text.rich(
        TextSpan(
          style: theme.textTheme.bodySmall,
          children: [
            TextSpan(
              text: '$label ',
              style: const TextStyle(
                color: AppColors.mutedForeground,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: '${value.toStringAsFixed(1)} g',
              style: const TextStyle(
                color: AppColors.foreground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NutrientChip extends StatelessWidget {
  const _NutrientChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 32),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        '$label: $value',
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: AppColors.mutedForeground),
      ),
    );
  }
}
