import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizilens/features/nutrition_detail/presentation/screens/nutrition_detail_screen.dart';
import 'package:gizilens/features/nutrition_detail/presentation/widgets/nutrient_breakdown_item.dart';

void main() {
  group('NutritionDetailScreen', () {
    testWidgets(
      'renders energy summary and separate macro and micronutrient sections',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(home: NutritionDetailScreen()),
        );

        expect(find.text('Detail Nutrisi'), findsOneWidget);
        expect(find.text('Ringkasan Energi'), findsOneWidget);
        expect(find.text('Makronutrien'), findsOneWidget);
        expect(find.text('Mikronutrien'), findsOneWidget);
      },
    );

    testWidgets('shows contextual warning feedback for an approaching limit', (
      tester,
    ) async {
      const nutrients = [
        NutrientData(
          name: 'Natrium',
          value: 1740,
          unit: 'mg',
          target: 2000,
          status: NutrientStatus.approachingLimit,
          feedback:
              'Asupan natrium hari ini sudah mendekati batas harian 2.000 mg.',
          isMacro: false,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(home: NutritionDetailScreen(nutrients: nutrients)),
      );

      expect(find.text('Natrium'), findsOneWidget);
      expect(find.text('1740 / 2000 mg'), findsOneWidget);
      expect(find.text('Mendekati batas'), findsOneWidget);
      expect(
        find.text(
          'Asupan natrium hari ini sudah mendekati batas harian 2.000 mg.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('does not invent a percentage when a nutrient has no target', (
      tester,
    ) async {
      const nutrients = [
        NutrientData(
          name: 'Vitamin B12',
          value: 2.1,
          unit: 'µg',
          status: NutrientStatus.noTarget,
          isMacro: false,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(home: NutritionDetailScreen(nutrients: nutrients)),
      );

      expect(find.text('2.1 µg'), findsOneWidget);
      expect(find.text('Target belum tersedia'), findsOneWidget);
      expect(find.text('0%'), findsNothing);
      expect(
        find.byType(LinearProgressIndicator),
        findsOneWidget,
      ); // Energy only.
    });

    testWidgets('preserves zero as a real nutrient value', (tester) async {
      const nutrients = [
        NutrientData(
          name: 'Kolesterol',
          value: 0,
          unit: 'mg',
          target: 300,
          status: NutrientStatus.adequate,
          isMacro: false,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(home: NutritionDetailScreen(nutrients: nutrients)),
      );

      expect(find.text('0 / 300 mg'), findsOneWidget);
      expect(find.text('Cukup'), findsOneWidget);
    });

    testWidgets('prioritizes warning micronutrients before adequate ones', (
      tester,
    ) async {
      const nutrients = [
        NutrientData(
          name: 'Zat Besi',
          value: 12,
          unit: 'mg',
          target: 18,
          status: NutrientStatus.adequate,
          isMacro: false,
        ),
        NutrientData(
          name: 'Natrium',
          value: 1740,
          unit: 'mg',
          target: 2000,
          status: NutrientStatus.approachingLimit,
          isMacro: false,
        ),
      ];
      await tester.pumpWidget(
        MaterialApp(home: NutritionDetailScreen(nutrients: nutrients)),
      );
      await tester.pumpAndSettle();

      final sodiumY = tester.getTopLeft(find.text('Natrium')).dy;
      final ironY = tester.getTopLeft(find.text('Zat Besi')).dy;
      expect(sodiumY, lessThan(ironY));
    });
  });
}
