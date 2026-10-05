import 'package:flutter/material.dart';
import 'package:gizilens/core/theme/app_spacing.dart';
import 'package:gizilens/core/theme/app_typography.dart';
import 'package:gizilens/domain/models/nutrition_feedback.dart';

class NutrientStatusChip extends StatelessWidget {
  final NutrientStatus status;
  final bool isCompact;

  const NutrientStatusChip({super.key, required this.status, this.isCompact = false});

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: isCompact ? AppSpacing.xs : AppSpacing.sm, vertical: isCompact ? 2 : AppSpacing.xs),
        decoration: BoxDecoration(color: status.backgroundColor, borderRadius: BorderRadius.circular(9999), border: Border.all(color: status.borderColor)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(status.icon, size: isCompact ? 12 : 14, color: status.foregroundColor),
          const SizedBox(width: AppSpacing.xs),
          Text(status.label, style: AppTypography.caption.copyWith(color: status.foregroundColor, fontWeight: FontWeight.w600)),
        ]),
      );
}
