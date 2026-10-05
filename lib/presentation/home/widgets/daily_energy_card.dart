import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gizilens/core/theme/app_colors.dart';
import 'package:gizilens/core/theme/app_spacing.dart';
import 'package:gizilens/core/theme/app_typography.dart';
import 'package:gizilens/presentation/home/providers/nutrition_summary_provider.dart';

class DailyEnergyCard extends ConsumerWidget {
  const DailyEnergyCard({super.key});

  String _format(double value) {
    final whole = value.round();
    if (whole < 1000) return whole.toString();
    return '${whole ~/ 1000}.${(whole % 1000).toString().padLeft(3, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(nutritionSummaryProvider);
    final hasTarget = summary.energyTarget != null && summary.energyTarget! > 0;
    final percentage = summary.energyPercentage;
    final progress = summary.energyProgressFraction;
    final remaining = hasTarget
        ? summary.energyTarget! - summary.energyConsumed
        : null;

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF064E3B), AppColors.accent],
        ),
        borderRadius: AppRadius.roundedXl,
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.18),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned(right: -56, top: -78, child: _EnergyGlow(size: 190)),
          const Positioned(
            left: -72,
            bottom: -115,
            child: _EnergyGlow(size: 190),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: AppRadius.roundedMd,
                      ),
                      child: const Icon(
                        Icons.local_fire_department_rounded,
                        color: Color(0xFFA7F3D0),
                        size: 21,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Energi',
                            style: AppTypography.headingMd.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Target harian',
                            style: AppTypography.caption.copyWith(
                              color: Colors.white.withValues(alpha: 0.72),
                              letterSpacing: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (percentage != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          borderRadius: AppRadius.roundedFull,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.16),
                          ),
                        ),
                        child: Text(
                          '$percentage% tercapai',
                          style: AppTypography.bodySm.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    else
                      Text(
                        'Target belum tersedia',
                        style: AppTypography.bodySm.copyWith(
                          color: Colors.white.withValues(alpha: 0.76),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 420;
                    return Row(
                      children: [
                        Expanded(
                          child: _ConsumedEnergy(
                            value: _format(summary.energyConsumed),
                            unit: summary.energyUnit,
                            target: hasTarget
                                ? _format(summary.energyTarget!)
                                : null,
                          ),
                        ),
                        if (isWide && remaining != null) ...[
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: _RemainingEnergy(
                              value: _format(remaining.abs()),
                              isOverTarget: remaining < 0,
                              unit: summary.energyUnit,
                            ),
                          ),
                        ],
                        const SizedBox(width: AppSpacing.md),
                        _EnergyProgressRing(
                          progress: progress,
                          percentage: percentage,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome_rounded,
                      color: Color(0xFFA7F3D0),
                      size: 17,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        summary.energyStatusText,
                        style: AppTypography.bodySm.copyWith(
                          color: Colors.white.withValues(alpha: 0.88),
                        ),
                      ),
                    ),
                    if (MediaQuery.sizeOf(context).width < 420 &&
                        remaining != null)
                      Text(
                        remaining >= 0
                            ? '${_format(remaining)} ${summary.energyUnit} tersisa'
                            : '${_format(remaining.abs())} ${summary.energyUnit} di atas target',
                        style: AppTypography.caption.copyWith(
                          color: const Color(0xFFA7F3D0),
                          letterSpacing: 0,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConsumedEnergy extends StatelessWidget {
  final String value;
  final String unit;
  final String? target;

  const _ConsumedEnergy({required this.value, required this.unit, this.target});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'SUDAH DIKONSUMSI',
        style: AppTypography.caption.copyWith(
          color: Colors.white.withValues(alpha: 0.68),
          letterSpacing: 0.8,
        ),
      ),
      const SizedBox(height: AppSpacing.xs),
      Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                target == null ? '$value $unit' : value,
                style: AppTypography.display.copyWith(
                  color: Colors.white,
                  fontSize: 34,
                  height: 1.08,
                ),
              ),
            ),
          ),
          if (target != null) ...[
            const SizedBox(width: AppSpacing.xs),
            Text(
              unit,
              style: AppTypography.bodySm.copyWith(
                color: Colors.white.withValues(alpha: 0.82),
              ),
            ),
          ],
        ],
      ),
      const SizedBox(height: AppSpacing.xs),
      Text(
        target == null ? 'Target harian belum tersedia' : 'dari $target $unit',
        style: AppTypography.bodySm.copyWith(
          color: Colors.white.withValues(alpha: 0.76),
        ),
      ),
    ],
  );
}

class _RemainingEnergy extends StatelessWidget {
  final String value;
  final bool isOverTarget;
  final String unit;

  const _RemainingEnergy({
    required this.value,
    required this.isOverTarget,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        isOverTarget ? 'DI ATAS TARGET' : 'SISA TARGET',
        style: AppTypography.caption.copyWith(
          color: Colors.white.withValues(alpha: 0.68),
          letterSpacing: 0.8,
        ),
      ),
      const SizedBox(height: AppSpacing.xs),
      FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(
          '$value $unit',
          style: AppTypography.headingLg.copyWith(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
      const SizedBox(height: AppSpacing.xs),
      Text(
        isOverTarget ? 'di atas asupan harian' : 'untuk hari ini',
        style: AppTypography.bodySm.copyWith(
          color: Colors.white.withValues(alpha: 0.76),
        ),
      ),
    ],
  );
}

class _EnergyProgressRing extends StatelessWidget {
  final double progress;
  final int? percentage;

  const _EnergyProgressRing({required this.progress, required this.percentage});

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Progres target energi harian',
    value: percentage == null ? 'Target belum tersedia' : '$percentage persen',
    child: ExcludeSemantics(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: progress),
        duration: MediaQuery.of(context).disableAnimations
            ? Duration.zero
            : const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
        builder: (context, animatedProgress, _) => SizedBox(
          width: 92,
          height: 92,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: animatedProgress,
                strokeWidth: 7,
                strokeCap: StrokeCap.round,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                valueColor: const AlwaysStoppedAnimation(Color(0xFFA7F3D0)),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      percentage == null ? '—' : '$percentage%',
                      style: AppTypography.headingMd.copyWith(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      percentage == null ? 'target' : 'tercapai',
                      style: AppTypography.caption.copyWith(
                        color: Colors.white.withValues(alpha: 0.74),
                        fontSize: 9,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _EnergyGlow extends StatelessWidget {
  final double size;

  const _EnergyGlow({required this.size});

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.045),
      shape: BoxShape.circle,
    ),
  );
}
