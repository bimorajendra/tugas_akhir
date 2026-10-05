import 'package:flutter/material.dart';
import 'package:gizilens/features/dashboard/presentation/widgets/dashboard_empty_state.dart';
import 'package:gizilens/features/dashboard/presentation/widgets/dashboard_shimmer_skeleton.dart';
import 'package:gizilens/features/dashboard/presentation/widgets/food_record_card.dart';
import 'package:gizilens/features/dashboard/presentation/widgets/today_food_list.dart';

class HomeDashboardScreen extends StatelessWidget {
  final bool isLoading;
  final List<FoodRecordItem> foodRecords;
  final VoidCallback? onRecordFood;

  const HomeDashboardScreen({
    super.key,
    this.isLoading = false,
    this.foodRecords = const [],
    this.onRecordFood,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Halo, Teman Gizi',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Berikut ringkasan gizimu hari ini.',
                style: TextStyle(fontSize: 14, color: Color(0xFF475569)),
              ),
              const SizedBox(height: 20),
              if (isLoading)
                const DashboardShimmerSkeleton()
              else if (foodRecords.isEmpty)
                DashboardEmptyState(
                  onRecordFood:
                      onRecordFood ??
                      () => Navigator.of(context).pushNamed('/capture'),
                )
              else
                TodayFoodList(items: foodRecords),
            ],
          ),
        ),
      ),
    );
  }
}
