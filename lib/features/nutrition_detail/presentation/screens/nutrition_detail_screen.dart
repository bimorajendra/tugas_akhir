import 'package:flutter/material.dart';
import 'package:gizilens/core/theme/app_colors.dart';
import 'package:gizilens/core/theme/app_spacing.dart';
import 'package:gizilens/features/nutrition_detail/presentation/widgets/nutrient_breakdown_item.dart';

class NutritionDetailScreen extends StatelessWidget {
  final List<NutrientData>? nutrients;

  const NutritionDetailScreen({super.key, this.nutrients});

  static const List<NutrientData> defaultNutrients = [
    NutrientData(
      name: 'Karbohidrat',
      value: 195,
      unit: 'g',
      target: 280,
      status: NutrientStatus.adequate,
      feedback: 'Asupan karbohidrat mencukupi kebutuhan energi harianmu.',
      isMacro: true,
    ),
    NutrientData(
      name: 'Protein',
      value: 58,
      unit: 'g',
      target: 75,
      status: NutrientStatus.low,
      feedback: 'Asupan protein masih di bawah target harian.',
      isMacro: true,
    ),
    NutrientData(
      name: 'Lemak Total',
      value: 46,
      unit: 'g',
      target: 65,
      status: NutrientStatus.adequate,
      isMacro: true,
    ),
    NutrientData(
      name: 'Serat Pangan',
      value: 14,
      unit: 'g',
      target: 30,
      status: NutrientStatus.low,
      feedback:
          'Tingkatkan konsumsi sayur dan buah untuk memenuhi target serat.',
      isMacro: true,
    ),
    NutrientData(
      name: 'Natrium',
      value: 1740,
      unit: 'mg',
      target: 2000,
      status: NutrientStatus.approachingLimit,
      feedback:
          'Asupan natrium hari ini sudah mendekati batas harian 2.000 mg.',
    ),
    NutrientData(
      name: 'Kalsium',
      value: 650,
      unit: 'mg',
      target: 1000,
      status: NutrientStatus.adequate,
    ),
    NutrientData(
      name: 'Zat Besi',
      value: 12,
      unit: 'mg',
      target: 18,
      status: NutrientStatus.adequate,
    ),
    NutrientData(
      name: 'Vitamin B12',
      value: 2.1,
      unit: 'µg',
      status: NutrientStatus.noTarget,
    ),
    NutrientData(
      name: 'Kalium',
      value: 2100,
      unit: 'mg',
      target: 4700,
      status: NutrientStatus.low,
    ),
  ];

  static int _priority(NutrientStatus status) => switch (status) {
    NutrientStatus.approachingLimit => 0,
    NutrientStatus.excessive => 1,
    NutrientStatus.low => 2,
    NutrientStatus.adequate => 3,
    NutrientStatus.noTarget => 4,
  };

  List<NutrientData> _sorted(Iterable<NutrientData> items) =>
      items.toList()..sort((a, b) {
        final priority = _priority(a.status).compareTo(_priority(b.status));
        return priority == 0 ? a.name.compareTo(b.name) : priority;
      });

  @override
  Widget build(BuildContext context) {
    final data = nutrients ?? defaultNutrients;
    final macros = _sorted(data.where((item) => item.isMacro));
    final micros = _sorted(data.where((item) => !item.isMacro));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detail Nutrisi'),
        leading: const Tooltip(message: 'Kembali', child: BackButton()),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.border),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenHorizontal,
                AppSpacing.lg,
                AppSpacing.screenHorizontal,
                AppSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _EnergySummaryCard(),
                  const SizedBox(height: AppSpacing.lg),
                  _SectionHeading(title: 'Makronutrien'),
                  const SizedBox(height: AppSpacing.sm),
                  if (macros.isEmpty)
                    const _SectionEmptyState(
                      label: 'Belum ada data makronutrien.',
                    ),
                  for (final nutrient in macros)
                    NutrientBreakdownItem(nutrient: nutrient),
                  const SizedBox(height: AppSpacing.md),
                  const _SectionHeading(title: 'Mikronutrien'),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Nutrisi dengan perhatian diprioritaskan di urutan atas.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  if (micros.isEmpty)
                    const _SectionEmptyState(
                      label: 'Belum ada data mikronutrien.',
                    ),
                  for (final nutrient in micros)
                    NutrientBreakdownItem(nutrient: nutrient),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EnergySummaryCard extends StatelessWidget {
  const _EnergySummaryCard();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: AppRadius.roundedLg,
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Ringkasan Energi',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.mutedForeground,
                ),
              ),
            ),
            Text(
              '73% tercapai',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '1.540',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.foreground,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              '/ 2.100 kkal',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.mutedForeground),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Semantics(
          label: 'Energi harian tercapai 73 persen',
          child: ClipRRect(
            borderRadius: AppRadius.roundedFull,
            child: LinearProgressIndicator(
              value: 0.73,
              minHeight: 8,
              backgroundColor: AppColors.muted,
              valueColor: AlwaysStoppedAnimation(AppColors.accent),
            ),
          ),
        ),
      ],
    ),
  );
}

class _SectionHeading extends StatelessWidget {
  final String title;
  const _SectionHeading({required this.title});

  @override
  Widget build(BuildContext context) => Text(
    title,
    style: Theme.of(context).textTheme.titleMedium?.copyWith(
      color: AppColors.foreground,
      fontWeight: FontWeight.w700,
    ),
  );
}

class _SectionEmptyState extends StatelessWidget {
  final String label;
  const _SectionEmptyState({required this.label});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
    child: Text(
      label,
      style: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(color: AppColors.mutedForeground),
    ),
  );
}
