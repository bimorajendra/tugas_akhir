import 'package:flutter/material.dart';
import 'package:gizilens/core/theme/app_colors.dart';
import 'package:gizilens/core/theme/app_spacing.dart';
import 'package:gizilens/core/theme/app_typography.dart';

class ProfileTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final String suffixText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final TextInputType keyboardType;
  final Key? inputKey;

  const ProfileTextField({super.key, required this.label, required this.suffixText, this.hintText, this.controller, this.onChanged, this.errorText, this.keyboardType = TextInputType.number, this.inputKey});

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AppTypography.label),
      const SizedBox(height: AppSpacing.xs),
      Container(
        height: 52,
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppRadius.roundedMd, border: Border.all(color: hasError ? AppColors.destructive : AppColors.border)),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Row(children: [
          Expanded(child: TextField(key: inputKey, controller: controller, onChanged: onChanged, keyboardType: keyboardType, style: AppTypography.bodyLg, decoration: InputDecoration(hintText: hintText, hintStyle: AppTypography.bodyLg.copyWith(color: AppColors.mutedForeground), border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero))),
          Text(suffixText, style: AppTypography.bodyMd.copyWith(color: AppColors.mutedForeground, fontWeight: FontWeight.w500)),
        ]),
      ),
      if (hasError) ...[const SizedBox(height: AppSpacing.xs), Text(errorText!, style: AppTypography.caption.copyWith(color: AppColors.destructive))],
    ]);
  }
}
