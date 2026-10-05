import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizilens/features/dashboard/presentation/widgets/food_record_card.dart';
import 'package:gizilens/features/dashboard/presentation/widgets/today_food_list.dart';

void main() {
  testWidgets('renders record details and handles tap', (tester) async {
    var tapped = false;
    final record = FoodRecordItem(
      id: 'rec-1',
      title: 'Nasi Putih, Ayam Bakar +2',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      portionGrams: 280,
      caloriesKcal: 450,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FoodRecordCard(record: record, onTap: () => tapped = true),
        ),
      ),
    );
    expect(find.text(record.title), findsOneWidget);
    expect(find.text('280 g'), findsOneWidget);
    expect(find.text('450 kkal'), findsOneWidget);
    expect(
      find.bySemanticsLabel('Buka detail makanan ${record.title}'),
      findsOneWidget,
    );
    await tester.tap(find.byType(FoodRecordCard));
    expect(tapped, isTrue);
  });

  testWidgets('shows fallback icon without image', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FoodRecordCard(
            record: FoodRecordItem(
              id: 'rec-2',
              title: 'Tumis Kangkung & Tahu',
              timestamp: DateTime.now(),
              portionGrams: 150,
              caloriesKcal: 120,
            ),
          ),
        ),
      ),
    );
    expect(find.byIcon(Icons.lunch_dining_outlined), findsOneWidget);
  });

  testWidgets('renders today list header and items', (tester) async {
    final items = [
      FoodRecordItem(
        id: 'a',
        title: 'Sarapan Ompreng Sehat',
        timestamp: DateTime.now(),
        portionGrams: 320,
        caloriesKcal: 510,
      ),
      FoodRecordItem(
        id: 'b',
        title: 'Buah Pepaya & Jeruk',
        timestamp: DateTime.now(),
        portionGrams: 180,
        caloriesKcal: 95,
      ),
    ];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: TodayFoodList(items: items)),
      ),
    );
    expect(find.text('Makanan Hari Ini (2)'), findsOneWidget);
    expect(find.text('Lihat semua'), findsOneWidget);
    expect(find.text('Sarapan Ompreng Sehat'), findsOneWidget);
    expect(find.text('Buah Pepaya & Jeruk'), findsOneWidget);
  });
}
