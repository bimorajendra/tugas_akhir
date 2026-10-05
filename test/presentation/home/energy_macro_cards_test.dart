import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizilens/core/theme/app_theme.dart';
import 'package:gizilens/domain/models/nutrition_summary.dart';
import 'package:gizilens/presentation/home/providers/nutrition_summary_provider.dart';
import 'package:gizilens/presentation/home/widgets/daily_energy_card.dart';
import 'package:gizilens/presentation/home/widgets/macro_summary_card.dart';

void main() {
  testWidgets('renders energy summary and progress', (tester) async {
    const summary = NutritionSummary(
      energyConsumed: 1540,
      energyTarget: 2100,
      energyStatusText: 'Cukup sejauh ini',
      macros: [
        MacroNutrientItem(name: 'Protein', consumed: 62, target: 75),
        MacroNutrientItem(name: 'Karbohidrat', consumed: 195, target: 260),
        MacroNutrientItem(name: 'Lemak', consumed: 48, target: 65),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [nutritionSummaryProvider.overrideWithValue(summary)],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: DailyEnergyCard()),
        ),
      ),
    );
    expect(find.text('Energi'), findsOneWidget);
    expect(find.textContaining('1.540'), findsOneWidget);
    expect(find.textContaining('2.100'), findsOneWidget);
    expect(find.text('73%'), findsOneWidget);
    expect(find.text('Cukup sejauh ini'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('handles missing energy target without fabricated percentage', (
    tester,
  ) async {
    const summary = NutritionSummary(
      energyConsumed: 800,
      energyTarget: null,
      energyStatusText: 'Target belum ditentukan',
      macros: [],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [nutritionSummaryProvider.overrideWithValue(summary)],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: DailyEnergyCard()),
        ),
      ),
    );
    expect(find.text('Energi'), findsOneWidget);
    expect(find.text('800 kkal'), findsOneWidget);
    expect(find.text('Target belum tersedia'), findsOneWidget);
    expect(find.text('Target belum ditentukan'), findsOneWidget);
  });

  testWidgets('renders all macros with progress and semantics', (tester) async {
    const summary = NutritionSummary(
      energyConsumed: 1540,
      energyTarget: 2100,
      energyStatusText: 'Cukup sejauh ini',
      macros: [
        MacroNutrientItem(name: 'Protein', consumed: 62, target: 75, unit: 'g'),
        MacroNutrientItem(
          name: 'Karbohidrat',
          consumed: 195,
          target: 260,
          unit: 'g',
        ),
        MacroNutrientItem(name: 'Lemak', consumed: 48, target: 65, unit: 'g'),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [nutritionSummaryProvider.overrideWithValue(summary)],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: MacroSummaryCard()),
        ),
      ),
    );
    expect(find.text('Protein'), findsOneWidget);
    expect(find.text('62 / 75 g'), findsOneWidget);
    expect(find.text('Karbohidrat'), findsOneWidget);
    expect(find.text('195 / 260 g'), findsOneWidget);
    expect(find.text('Lemak'), findsOneWidget);
    expect(find.text('48 / 65 g'), findsOneWidget);
    expect(
      find.bySemanticsLabel('Protein, 62 gram dari target 75 gram, 83 persen'),
      findsOneWidget,
    );
  });
}
