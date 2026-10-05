import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gizilens/domain/models/nutrition_summary.dart';
import 'package:gizilens/presentation/home/providers/selected_date_provider.dart';

final nutritionSummaryProvider = Provider<NutritionSummary>((ref) {
  final selected = ref.watch(selectedDateProvider);
  final now = DateTime.now();
  final isToday = selected.year == now.year && selected.month == now.month && selected.day == now.day;
  return isToday
      ? const NutritionSummary(energyConsumed: 1540, energyTarget: 2100, energyStatusText: 'Cukup sejauh ini', macros: [
          MacroNutrientItem(name: 'Protein', consumed: 62, target: 75),
          MacroNutrientItem(name: 'Karbohidrat', consumed: 195, target: 260),
          MacroNutrientItem(name: 'Lemak', consumed: 48, target: 65),
        ])
      : const NutritionSummary(energyConsumed: 1820, energyTarget: 2100, energyStatusText: 'Mendekati target', macros: [
          MacroNutrientItem(name: 'Protein', consumed: 68, target: 75),
          MacroNutrientItem(name: 'Karbohidrat', consumed: 245, target: 280),
          MacroNutrientItem(name: 'Lemak', consumed: 58, target: 65),
        ]);
});
