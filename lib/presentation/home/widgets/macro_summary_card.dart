import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gizilens/core/theme/app_colors.dart';
import 'package:gizilens/core/theme/app_spacing.dart';
import 'package:gizilens/core/theme/app_typography.dart';
import 'package:gizilens/domain/models/nutrition_summary.dart';
import 'package:gizilens/presentation/home/providers/nutrition_summary_provider.dart';

class MacroSummaryCard extends ConsumerWidget {
  final VoidCallback? onDetailsTap;

  const MacroSummaryCard({super.key, this.onDetailsTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final macros = ref.watch(nutritionSummaryProvider).macros;
    if (macros.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Makronutrien', style: AppTypography.headingMd),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Komposisi asupanmu hari ini',
                    style: AppTypography.bodySm,
                  ),
                ],
              ),
            ),
            if (onDetailsTap != null)
              TextButton.icon(
                onPressed: onDetailsTap,
                icon: const Icon(Icons.arrow_outward_rounded, size: 16),
                label: const Text('Rincian'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.accent,
                  minimumSize: const Size(44, 44),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  textStyle: AppTypography.bodySm.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            else
              Text('${macros.length} nutrisi', style: AppTypography.caption),
          ],
        ),
        const SizedBox(height: AppSpacing.sm + 2),
        Row(
          children: [
            for (final entry in macros.asMap().entries)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: entry.key == macros.length - 1 ? 0 : AppSpacing.sm,
                  ),
                  child: _MacroItemTile(item: entry.value),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _MacroItemTile extends StatelessWidget {
  final MacroNutrientItem item;

  const _MacroItemTile({required this.item});

  Color get _color {
    final name = item.name.toLowerCase();
    if (name.contains('protein')) return const Color(0xFF047857);
    if (name.contains('karbo')) return const Color(0xFF0284C7);
    if (name.contains('lemak')) return const Color(0xFFD97706);
    return AppColors.accent;
  }

  IconData get _icon {
    final name = item.name.toLowerCase();
    if (name.contains('protein')) return Icons.fitness_center_rounded;
    if (name.contains('karbo')) return Icons.grain_rounded;
    if (name.contains('lemak')) return Icons.water_drop_rounded;
    return Icons.eco_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final hasTarget = item.target != null && item.target! > 0;
    final targetText = item.target?.round();
    final valueText = hasTarget
        ? '${item.consumed.round()} / ${item.target!.round()} ${item.unit}'
        : '${item.consumed.round()} ${item.unit}';
    final percentage = item.percentage;
    final semantics = hasTarget
        ? '${item.name}, ${item.consumed.round()} gram dari target $targetText gram, ${percentage ?? 0} persen'
        : '${item.name}, target harian belum tersedia';

    return Semantics(
      label: semantics,
      container: true,
      excludeSemantics: true,
      child: Container(
        constraints: const BoxConstraints(minHeight: 116),
        padding: const EdgeInsets.all(AppSpacing.sm + 2),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.roundedLg,
          border: Border.all(color: _color.withValues(alpha: 0.16)),
          boxShadow: [
            BoxShadow(
              color: _color.withValues(alpha: 0.045),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: _color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_icon, size: 13, color: _color),
                ),
                const Spacer(),
                Text(
                  percentage == null ? '—' : '$percentage%',
                  style: AppTypography.caption.copyWith(
                    color: _color,
                    fontSize: 10,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            SizedBox(
              width: double.infinity,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  item.name,
                  maxLines: 1,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.foreground,
                    fontSize: 10.5,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                valueText,
                maxLines: 1,
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.foreground,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            ClipRRect(
              borderRadius: AppRadius.roundedFull,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: item.progressFraction),
                duration: MediaQuery.of(context).disableAnimations
                    ? Duration.zero
                    : const Duration(milliseconds: 850),
                curve: Curves.easeOutCubic,
                builder: (context, progress, _) => LinearProgressIndicator(
                  value: progress,
                  minHeight: 5,
                  backgroundColor: AppColors.muted,
                  valueColor: AlwaysStoppedAnimation(_color),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              percentage == null
                  ? 'Target belum tersedia'
                  : '$percentage% dari target',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.caption.copyWith(
                fontSize: 9.5,
                letterSpacing: 0,
                color: AppColors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
