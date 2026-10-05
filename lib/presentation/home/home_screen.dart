import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gizilens/core/theme/app_colors.dart';
import 'package:gizilens/core/theme/app_spacing.dart';
import 'package:gizilens/core/widgets/entrance_motion.dart';
import 'package:gizilens/domain/models/nutrition_feedback.dart';
import 'package:gizilens/presentation/home/widgets/dashboard_header.dart';
import 'package:gizilens/presentation/home/widgets/date_context_bar.dart';
import 'package:gizilens/presentation/home/widgets/daily_energy_card.dart';
import 'package:gizilens/presentation/home/widgets/macro_summary_card.dart';
import 'package:gizilens/presentation/home/widgets/nutrition_feedback_card.dart';
import 'package:gizilens/presentation/home/widgets/nutrient_status_chip.dart';
import 'package:gizilens/presentation/home/providers/nutrition_feedback_provider.dart';
import 'package:gizilens/features/dashboard/presentation/widgets/dashboard_empty_state.dart';
import 'package:gizilens/features/dashboard/presentation/widgets/dashboard_shimmer_skeleton.dart';
import 'package:gizilens/features/dashboard/presentation/widgets/food_record_card.dart';
import 'package:gizilens/features/dashboard/presentation/widgets/today_food_list.dart';

class HomeScreen extends ConsumerWidget {
  final String userName;
  final bool isLoading;
  final List<FoodRecordItem> foodRecords;
  final VoidCallback? onRecordFood;

  const HomeScreen({
    super.key,
    this.userName = 'Pengguna',
    this.isLoading = false,
    this.foodRecords = const [],
    this.onRecordFood,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedback = ref.watch(nutritionFeedbackProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenHorizontal,
                vertical: AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EntranceMotion(
                    key: const ValueKey('home-header-motion'),
                    child: DashboardHeader(userName: userName),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  EntranceMotion(
                    key: const ValueKey('home-date-motion'),
                    delay: const Duration(milliseconds: 70),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const DateContextBar(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.xs),
                            child: TextButton.icon(
                              onPressed: () =>
                                  Navigator.of(context).pushNamed('/history'),
                              icon: const Icon(Icons.history_rounded, size: 18),
                              label: const Text('Riwayat konsumsi'),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.accent,
                                minimumSize: const Size(48, 44),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                ),
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  EntranceMotion(
                    key: const ValueKey('home-energy-motion'),
                    delay: const Duration(milliseconds: 140),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ringkasan gizimu hari ini',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Pantau energi dan keseimbangan nutrisimu.',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.mutedForeground),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        const DailyEnergyCard(),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  EntranceMotion(
                    key: const ValueKey('home-macros-motion'),
                    delay: const Duration(milliseconds: 230),
                    child: MacroSummaryCard(
                      onDetailsTap: () =>
                          Navigator.of(context).pushNamed('/nutrition/detail'),
                    ),
                  ),
                  if (feedback.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.lg),
                    EntranceMotion(
                      key: const ValueKey('home-feedback-motion'),
                      delay: const Duration(milliseconds: 320),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NutritionFeedbackCard(
                            feedback: feedback.first,
                            onDetailTap: () => Navigator.of(
                              context,
                            ).pushNamed('/nutrition/detail'),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          NutrientStatusChip(
                            status: NutrientStatus.approachingLimit,
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  EntranceMotion(
                    key: const ValueKey('home-food-motion'),
                    delay: const Duration(milliseconds: 390),
                    child: isLoading
                        ? const DashboardShimmerSkeleton()
                        : foodRecords.isEmpty
                        ? DashboardEmptyState(
                            onRecordFood:
                                onRecordFood ??
                                () =>
                                    Navigator.of(context).pushNamed('/capture'),
                          )
                        : TodayFoodList(
                            items: foodRecords,
                            onViewAllTap: () =>
                                Navigator.of(context).pushNamed('/history'),
                          ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
