import 'package:flutter/material.dart';
import 'package:gizilens/core/theme/app_colors.dart';
import 'package:gizilens/core/theme/app_spacing.dart';

class DateChip extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  const DateChip({
    super.key,
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  static const _dayNames = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final dayName = _dayNames[date.weekday - 1];
    final label = isToday
        ? 'Hari ini, $dayName ${date.day}'
        : '$dayName ${date.day}';
    final foreground = isSelected ? AppColors.onAccent : AppColors.foreground;

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: Material(
        color: isSelected ? AppColors.accent : AppColors.surface,
        borderRadius: AppRadius.roundedMd,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.roundedMd,
          child: Container(
            width: 60,
            height: 84 * textScale,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              borderRadius: AppRadius.roundedMd,
              border: Border.all(
                color: isSelected ? AppColors.accent : AppColors.border,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dayName,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? AppColors.onAccent
                        : AppColors.mutedForeground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${date.day}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  isToday ? 'Hari ini' : ' ',
                  maxLines: 1,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
