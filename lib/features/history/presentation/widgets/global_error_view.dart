import 'package:flutter/material.dart';
import 'package:gizilens/core/theme/app_colors.dart';
import 'package:gizilens/core/theme/app_spacing.dart';

enum HistoryErrorType { offline, server }

class GlobalErrorView extends StatelessWidget {
  final HistoryErrorType type;
  final VoidCallback onRetry;

  const GlobalErrorView({super.key, required this.type, required this.onRetry});

  String get _title => switch (type) {
    HistoryErrorType.offline => 'Tidak ada koneksi internet',
    HistoryErrorType.server => 'Riwayat belum dapat dimuat',
  };

  String get _message => switch (type) {
    HistoryErrorType.offline =>
      'Periksa koneksi internetmu, lalu coba muat riwayat lagi.',
    HistoryErrorType.server =>
      'Layanan sedang mengalami gangguan. Catatanmu tetap aman, silakan coba lagi.',
  };

  IconData get _icon => type == HistoryErrorType.offline
      ? Icons.wifi_off_rounded
      : Icons.cloud_off_rounded;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.muted,
                shape: BoxShape.circle,
              ),
              child: Icon(_icon, color: AppColors.mutedForeground, size: 28),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              _title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.foreground,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              _message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.mutedForeground,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    ),
  );
}
