import 'package:flutter/material.dart';
import 'package:gizilens/core/theme/app_colors.dart';
import 'package:gizilens/core/theme/app_spacing.dart';

void showSaveSuccessToast(
  BuildContext context, {
  String message = 'Konsumsi berhasil disimpan',
  String subtitle = 'Ringkasan harian telah diperbarui.',
  Duration duration = const Duration(seconds: 3),
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      backgroundColor: AppColors.foreground,
      elevation: 3,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadius.roundedLg,
        side: BorderSide(color: Color(0xFF1E293B)),
      ),
      duration: duration,
      content: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Color(0xFF4ADE80),
              size: 22,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(
                    color: AppColors.surface,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFFCBD5E1),
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
