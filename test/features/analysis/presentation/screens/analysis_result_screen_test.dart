import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizilens/features/analysis/presentation/screens/analysis_result_screen.dart';

void main() {
  const sampleItems = [
    DetectedFoodItem(
      id: 'food-1',
      name: 'Nasi Putih',
      portion: 150,
      portionUnit: 'gram',
      calories: 195,
      protein: 4,
      carbs: 43.5,
      fat: 0.4,
      dynamicNutrients: {'Serat': '0.6 g', 'Natrium': '1.5 mg'},
    ),
    DetectedFoodItem(
      id: 'food-2',
      name: 'Ayam Bakar Dada',
      portion: 100,
      portionUnit: 'gram',
      calories: 165,
      protein: 31,
      carbs: 0,
      fat: 3.6,
      dynamicNutrients: {'Kolesterol': '85 mg', 'Kalium': '256 mg'},
    ),
    DetectedFoodItem(
      id: 'food-3',
      name: 'Tumis Buncis Tempe',
      portion: 80,
      portionUnit: 'gram',
      calories: 78,
      protein: 4.2,
      carbs: 6.8,
      fat: 4.1,
      dynamicNutrients: {'Serat': '2.4 g', 'Vitamin A': '180 IU'},
    ),
  ];

  Widget buildTestWidget({
    List<DetectedFoodItem> items = sampleItems,
    ValueChanged<DetectedFoodItem>? onEditPortion,
    VoidCallback? onRetake,
    VoidCallback? onPickGallery,
    bool isFailure = false,
  }) {
    return MaterialApp(
      home: AnalysisResultScreen(
        items: items,
        compartmentCount: 3,
        onEditPortion: onEditPortion,
        onRetake: onRetake,
        onPickGallery: onPickGallery,
        isFailure: isFailure,
      ),
    );
  }

  testWidgets('shows food summary, compartment count, and detected items', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestWidget());

    expect(find.text('Hasil Analisis'), findsOneWidget);
    expect(find.text('Periksa kembali sebelum menyimpan.'), findsOneWidget);
    expect(find.text('Ompreng: 3 Kompartemen'), findsOneWidget);
    expect(find.text('Total Energi'), findsOneWidget);
    expect(find.text('438 kkal'), findsOneWidget);
    expect(find.byType(FoodItemCard), findsNWidgets(3));
    expect(find.text('Nasi Putih'), findsOneWidget);
    expect(find.text('150 gram'), findsOneWidget);
    expect(find.text('Ayam Bakar Dada'), findsOneWidget);
    expect(find.text('100 gram'), findsOneWidget);
    expect(find.text('Tumis Buncis Tempe'), findsOneWidget);
    expect(find.text('80 gram'), findsOneWidget);
    expect(find.text('Serat: 0.6 g'), findsOneWidget);
  });

  testWidgets('portion edit updates the selected item and aggregate totals', (
    tester,
  ) async {
    DetectedFoodItem? editedItem;
    await tester.pumpWidget(
      buildTestWidget(onEditPortion: (item) => editedItem = item),
    );

    final editButton = find.byKey(const Key('edit_portion_food-2'));
    await tester.ensureVisible(editButton);
    await tester.tap(editButton);
    await tester.pumpAndSettle();

    expect(find.text('Estimasi Nilai Gizi'), findsOneWidget);
    await tester.tap(find.byKey(const Key('portion_increment_button')));
    await tester.pumpAndSettle();
    expect(find.text('110'), findsOneWidget);
    await tester.tap(find.byKey(const Key('portion_save_cta')));
    await tester.pumpAndSettle();

    expect(editedItem?.id, 'food-2');
    expect(editedItem?.name, 'Ayam Bakar Dada');
    expect(editedItem?.portion, 110);
    expect(find.text('110 gram'), findsOneWidget);
    expect(find.text('455 kkal'), findsOneWidget);
  });

  testWidgets('shows failure recovery when the analysis has no result', (
    tester,
  ) async {
    var retakeCalled = false;
    var galleryCalled = false;
    await tester.pumpWidget(
      buildTestWidget(
        items: const [],
        onRetake: () => retakeCalled = true,
        onPickGallery: () => galleryCalled = true,
      ),
    );

    expect(find.text('Makanan belum dapat dikenali'), findsOneWidget);
    await tester.tap(find.text('Ambil Ulang'));
    await tester.pump();
    expect(retakeCalled, isTrue);

    await tester.tap(find.text('Pilih dari Galeri'));
    await tester.pump();
    expect(galleryCalled, isTrue);
  });

  testWidgets('reflows on a small phone and landscape with larger text', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(375, 812);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(2)),
          child: child!,
        ),
        home: AnalysisResultScreen(items: sampleItems),
      ),
    );
    final smallPhoneLayoutError = tester.takeException();
    expect(
      smallPhoneLayoutError,
      isNull,
      reason: smallPhoneLayoutError?.toString(),
    );

    tester.view.physicalSize = const Size(812, 375);
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
