import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizilens/features/history/presentation/screens/food_record_detail_screen.dart';
import 'package:gizilens/features/history/presentation/widgets/food_record_nutrition_card.dart';
import 'package:gizilens/features/nutrition_detail/presentation/widgets/nutrient_breakdown_item.dart';

void main() {
  final record = FoodRecordDetailData(
    id: 'rec-001',
    mealTitle: 'Makan Siang Ompreng',
    consumedAt: DateTime.now().subtract(const Duration(hours: 3)),
    items: const [
      RecordedFoodItem(
        name: 'Nasi Putih',
        portionAmount: 150,
        portionUnit: 'gram',
        calories: 195,
      ),
      RecordedFoodItem(
        name: 'Ayam Goreng Lengkuas',
        portionAmount: 100,
        portionUnit: 'gram',
        calories: 260,
      ),
      RecordedFoodItem(
        name: 'Sayur Bening Bayam',
        portionAmount: 80,
        portionUnit: 'gram',
        calories: 36,
      ),
    ],
    totalCalories: 491,
    totalProtein: 28.5,
    totalCarbs: 45.2,
    totalFat: 21,
    nutrients: const [
      NutrientData(
        id: 'fe',
        name: 'Zat Besi (Fe)',
        value: 3.2,
        unit: 'mg',
        target: 18,
        percentage: 17.7,
        status: NutrientStatus.adequate,
        feedback: 'Asupan zat besi dari bayam mencukupi porsi makan siang.',
      ),
      NutrientData(
        id: 'na',
        name: 'Natrium',
        value: 420,
        unit: 'mg',
        target: 2000,
        percentage: 21,
        status: NutrientStatus.adequate,
      ),
    ],
  );

  testWidgets('renders consumed food, portions, totals, and nutrient details', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: FoodRecordDetailScreen(record: record)),
    );

    expect(find.text('Detail Konsumsi'), findsOneWidget);
    expect(find.byType(BackButton), findsOneWidget);
    expect(find.text('Makan Siang Ompreng'), findsOneWidget);
    expect(find.text('Daftar Makanan (3)'), findsOneWidget);
    expect(find.text('Nasi Putih'), findsOneWidget);
    expect(find.text('150 gram • 195 kkal'), findsOneWidget);
    expect(find.text('Ayam Goreng Lengkuas'), findsOneWidget);
    expect(find.text('100 gram • 260 kkal'), findsOneWidget);
    expect(find.text('Sayur Bening Bayam'), findsOneWidget);
    expect(find.byType(FoodRecordNutritionCard), findsOneWidget);
    expect(find.text('491'), findsOneWidget);
    expect(find.text('28.5g'), findsOneWidget);
    expect(find.text('45.2g'), findsOneWidget);
    expect(find.text('21.0g'), findsOneWidget);
    expect(find.byType(NutrientBreakdownItem), findsNWidgets(2));
    expect(find.text('Zat Besi (Fe)'), findsOneWidget);
    expect(find.text('Natrium'), findsOneWidget);
  });

  testWidgets('provides a labeled placeholder when there is no food photo', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: FoodRecordDetailScreen(record: record)),
    );

    expect(find.byIcon(Icons.restaurant_outlined), findsOneWidget);
    expect(find.text('Foto Ompreng Makanan'), findsOneWidget);
  });
}
