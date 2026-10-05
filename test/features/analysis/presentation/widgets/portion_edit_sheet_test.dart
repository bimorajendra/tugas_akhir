import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizilens/features/analysis/presentation/screens/analysis_result_screen.dart';
import 'package:gizilens/features/analysis/presentation/widgets/food_item_card.dart';
import 'package:gizilens/features/analysis/presentation/widgets/portion_edit_sheet.dart';

void main() {
  const sampleFood = DetectedFoodItem(
    id: 'food_01',
    name: 'Ayam Goreng Lengkuas',
    portion: 100,
    portionUnit: 'gram',
    calories: 260,
    protein: 25,
    carbs: 4,
    fat: 16,
  );

  Widget buildTestableWidget({
    DetectedFoodItem foodItem = sampleFood,
    ValueChanged<DetectedFoodItem>? onPortionUpdated,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: PortionEditSheet(
          foodItem: foodItem,
          onPortionUpdated: onPortionUpdated,
        ),
      ),
    );
  }

  group('PortionEditSheet UI and interaction', () {
    testWidgets('renders food, initial portion, units, and nutrition preview', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget());

      expect(find.text('Ubah Porsi'), findsOneWidget);
      expect(find.text('Ayam Goreng Lengkuas'), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
      expect(find.text('gram'), findsOneWidget);
      expect(find.text('Perbarui'), findsOneWidget);
      expect(find.text('Estimasi Nilai Gizi'), findsOneWidget);
      expect(find.text('260 kkal'), findsOneWidget);
    });

    testWidgets('increment and decrement recalculate energy and macros', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget());

      await tester.tap(find.byKey(const Key('portion_increment_button')));
      await tester.pumpAndSettle();
      expect(find.text('110'), findsOneWidget);
      expect(find.text('286 kkal'), findsOneWidget);
      expect(find.text('27.5 g'), findsOneWidget);

      await tester.tap(find.byKey(const Key('portion_decrement_button')));
      await tester.pumpAndSettle();
      expect(find.text('100'), findsOneWidget);
      expect(find.text('260 kkal'), findsOneWidget);
    });

    testWidgets('unit dropdown changes the selected unit', (tester) async {
      await tester.pumpWidget(buildTestableWidget());

      await tester.tap(find.byKey(const Key('portion_unit_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('potong').last);
      await tester.pumpAndSettle();

      expect(find.text('potong'), findsOneWidget);
    });

    testWidgets('Perbarui returns updated model values through callback', (
      tester,
    ) async {
      DetectedFoodItem? updated;
      await tester.pumpWidget(
        buildTestableWidget(onPortionUpdated: (item) => updated = item),
      );

      await tester.tap(find.byKey(const Key('portion_increment_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('portion_increment_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('portion_save_cta')));
      await tester.pumpAndSettle();

      expect(updated?.portion, 120);
      expect(updated?.portionUnit, 'gram');
      expect(updated?.calories, 312);
      expect(updated?.protein, 30);
    });

    testWidgets('invalid zero quantity shows validation and disables update', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget());

      await tester.enterText(find.byKey(const Key('portion_text_field')), '0');
      await tester.pumpAndSettle();

      expect(find.text('Masukkan porsi lebih dari 0.'), findsOneWidget);
      final button = tester.widget<FilledButton>(
        find.byKey(const Key('portion_save_cta')),
      );
      expect(button.onPressed, isNull);
    });
  });
}
