import 'package:flutter/material.dart';
import 'package:gizilens/core/theme/app_colors.dart';
import 'package:gizilens/core/theme/app_spacing.dart';

class AnalysisFailureView extends StatelessWidget {
  const AnalysisFailureView({super.key, this.onRetake, this.onPickGallery});

  final VoidCallback? onRetake;
  final VoidCallback? onPickGallery;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xl,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: AppColors.muted,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(
                  Icons.search_off_rounded,
                  size: 40,
                  color: AppColors.mutedForeground,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Makanan belum dapat dikenali',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Coba ambil ulang dengan seluruh ompreng terlihat jelas dan pencahayaan yang cukup.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.mutedForeground,
                ),
              ),
              if (onRetake != null || onPickGallery != null) ...[
                const SizedBox(height: AppSpacing.lg),
                if (onRetake != null)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onRetake,
                      icon: const Icon(Icons.refresh_rounded, size: 20),
                      label: const Text('Ambil Ulang'),
                    ),
                  ),
                if (onRetake != null && onPickGallery != null)
                  const SizedBox(height: AppSpacing.sm),
                if (onPickGallery != null)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: onPickGallery,
                      icon: const Icon(Icons.photo_library_outlined, size: 20),
                      label: const Text('Pilih dari Galeri'),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
