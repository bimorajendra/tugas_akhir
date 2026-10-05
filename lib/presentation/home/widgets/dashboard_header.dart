import 'package:flutter/material.dart';
import 'package:gizilens/core/theme/app_colors.dart';
import 'package:gizilens/core/theme/app_spacing.dart';
import 'package:gizilens/core/theme/app_typography.dart';

class DashboardHeader extends StatelessWidget {
  final String userName;
  final VoidCallback? onNotificationTap;

  const DashboardHeader({
    super.key,
    required this.userName,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final trimmedName = userName.trim();
    final initial = trimmedName.isEmpty ? 'G' : trimmedName[0].toUpperCase();

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Halo, $userName', style: AppTypography.headingLg),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Berikut ringkasan gizimu hari ini.',
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
        if (onNotificationTap != null)
          IconButton(
            tooltip: 'Notifikasi',
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.foreground,
              size: 24,
            ),
            onPressed: onNotificationTap,
          )
        else
          Semantics(
            image: true,
            label: 'Profil $userName',
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFBBF7D0)),
              ),
              alignment: Alignment.center,
              child: Text(
                initial,
                style: AppTypography.headingMd.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
