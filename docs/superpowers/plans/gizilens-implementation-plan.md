# GiziLens Mobile Nutrition Monitoring Implementation Plan (Slice 3 of 4)

<!-- docs/superpowers/plans/2025-02-18-gizilens-slice-3.md -->

**Goal:** Slice 3 of 4: Implement the food analysis results display, multi-food ompreng breakdown, portion modification bottom sheet, consumption confirmation bar with save feedback, full dynamic nutrient detail views, food record details, and the historical horizontal date selector strip.

**Architecture:** Presentation-layer UI built in Flutter following clean feature-first architecture, leveraging design tokens (`#047857` Emerald functional accent, 4-point spacing, neutral border styling) and Flutter Riverpod for local visual state handling. Dynamic mock data provides realistic relative timestamps and varied macro/micronutrient sets without client-side calculation or hardcoded universal targets.

**Tech Stack:** Flutter 3.x, Dart 3.x, Flutter Riverpod, Material 3 with GiziLens Custom Theme Tokens, flutter_test.

**Spec ref:** prd-gizilens.md & prd-desain-gizilens.md @ Draft v1.0 (2025-02-18)

## Global Constraints

- Semua UI baru wajib menerapkan skill ui-ux-pro-max (typography, spacing, motion, a11y; hindari pola generik/template).
- Security: validasi input client-side/server-side, secrets hanya via environment variables (tidak hard-coded / tidak ter-commit ke repo), error response/UI tanpa membocorkan detail internal, dependency audit lolos (skill deps-audit).
- Plan kind: UI-FIRST. Semua state menggunakan mock data deterministik; tanggal dan timestamp wajib relatif terhadap waktu runtime (`DateTime.now().subtract(...)`), tidak menggunakan tanggal literal kadaluarsa.
- Dynamic nutrient values: UI tidak boleh memalsukan nilai nutrisi yang hilang (missing values != 0); target yang belum tersedia harus menampilkan status "Target belum tersedia" tanpa merusak layout.
- Ompreng-aware layout: Kartu makanan harus mendukung multiple food items dari wadah kompartemen ompreng dengan pengeditan porsi independen.
- Test runner: `flutter test` only.

## Definition of Done

- [ ] `flutter test` berhasil PASS untuk semua widget dan unit tests di Slice 3.
- [ ] Pre-delivery checklist ui-ux-pro-max lolos untuk semua UI baru.
- [ ] Security check lolos: validasi input server-side teruji, secrets hanya via env & tidak ter-commit, error tidak membocorkan detail internal, `flutter pub audit` tanpa high/critical (skill deps-audit).
- [ ] Multi-food result screen menampilkan kartu-kartu makanan terdeteksi lengkap dengan porsi, kalori, makronutrien, dan ringkasan dinamis.
- [ ] Analysis failure view menampilkan pesan ramah "Makanan belum dapat dikenali", tombol Ambil Ulang, dan opsi fallback Galeri.
- [ ] Portion edit bottom sheet membuka kontrol stepper + dropdown satuan dan menampilkan pratinjau nilai gizi terhitung mockup.
- [ ] Consumption confirmation bar menyediakan kontrol waktu makan, sticky CTA "Simpan Konsumsi", dan proteksi double-tap submit lock.
- [ ] Save feedback menampilkan toast ringan saat sukses dan dialog pemulihan saat penyimpanan gagal tanpa menghilangkan hasil analisis.
- [ ] Dynamic nutrient detail page menampilkan pemisahan makro/mikronutrien, sorting status perhatian, dan indikator progres.
- [ ] Food record detail screen menampilkan thumbnail media, waktu konsumsi, daftar makanan, dan rincian mikronutrien lengkap.
- [ ] Horizontal date selector strip dapat digulirkan secara horizontal, menonjolkan tanggal aktif, dan merespons tap pemilihan tanggal.

---

## Kanban bridge

| Work Map ids | Plan task |
| ------------ | --------- |
| t17 | Task 1 |
| t18 | Task 2 |
| t19 | Task 3 |
| t20 | Task 4 |
| t21 | Task 5 |
| t22 | Task 6 |
| t23 | Task 7 |
| t24 | Task 8 |
| t25 | Deferred to Slice 4 |
| t26 | Deferred to Slice 4 |
| t27 | Deferred to Slice 4 |

### Task 1: Multi-Food Result Screen Layout

**Files:**
- Create: `lib/src/features/food_analysis/presentation/screens/analysis_result_screen.dart`
- Create: `lib/src/features/food_analysis/presentation/widgets/food_item_card.dart`
- Test: `test/features/food_analysis/presentation/screens/analysis_result_screen_test.dart`

**Depends on:** none

**Interfaces:**
- Consumes: none (first task of slice)
- Produces: `DetectedFoodItem`, `FoodItemCard`, `AnalysisResultScreen`

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test';
import 'package:gizilens/src/features/food_analysis/presentation/screens/analysis_result_screen.dart';
import 'package:gizilens/src/features/food_analysis/presentation/widgets/food_item_card.dart';

void main() {
  final sampleItems = [
    const DetectedFoodItem(
      id: 'food-1',
      name: 'Nasi Putih',
      portion: 150.0,
      portionUnit: 'gram',
      calories: 195,
      protein: 4.0,
      carbs: 43.5,
      fat: 0.4,
      dynamicNutrients: {'Serat': '0.6 g', 'Natrium': '1.5 mg'},
    ),
    const DetectedFoodItem(
      id: 'food-2',
      name: 'Ayam Bakar Dada',
      portion: 100.0,
      portionUnit: 'gram',
      calories: 165,
      protein: 31.0,
      carbs: 0.0,
      fat: 3.6,
      dynamicNutrients: {'Kolesterol': '85 mg', 'Kalium': '256 mg'},
    ),
    const DetectedFoodItem(
      id: 'food-3',
      name: 'Tumis Buncis Tempe',
      portion: 80.0,
      portionUnit: 'gram',
      calories: 78,
      protein: 4.2,
      carbs: 6.8,
      fat: 4.1,
      dynamicNutrients: {'Serat': '2.4 g', 'Vitamin A': '180 IU'},
    ),
  ];

  Widget buildTestWidget({
    List<DetectedFoodItem>? items,
    ValueChanged<DetectedFoodItem>? onEditPortion,
    VoidCallback? onConfirmSave,
    VoidCallback? onRetake,
  }) {
    return MaterialApp(
      home: AnalysisResultScreen(
        items: items ?? sampleItems,
        compartmentCount: 3,
        onEditPortion: onEditPortion,
        onConfirmSave: onConfirmSave,
        onRetake: onRetake,
      ),
    );
  }

  testWidgets('renders title, ompreng compartment badge, and total calories summary',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());

    expect(find.text('Hasil Analisis'), findsOneWidget);
    expect(find.text('Periksa kembali sebelum menyimpan.'), findsOneWidget);
    expect(find.text('Ompreng: 3 Kompartemen'), findsOneWidget);

    // Total calories: 195 + 165 + 78 = 438 kkal
    expect(find.text('438 kkal'), findsOneWidget);
    expect(find.text('Total Energi'), findsOneWidget);
  });

  testWidgets('renders each detected food card with portion, calories, and macros',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());

    expect(find.text('Nasi Putih'), findsOneWidget);
    expect(find.text('150 gram'), findsOneWidget);
    expect(find.text('195 kkal'), findsOneWidget);

    expect(find.text('Ayam Bakar Dada'), findsOneWidget);
    expect(find.text('100 gram'), findsOneWidget);
    expect(find.text('165 kkal'), findsOneWidget);

    expect(find.text('Tumis Buncis Tempe'), findsOneWidget);
    expect(find.text('80 gram'), findsOneWidget);
    expect(find.text('78 kkal'), findsOneWidget);

    expect(find.byType(FoodItemCard), findsNWidgets(3));
  });

  testWidgets('tapping Ubah Porsi button on a card triggers onEditPortion callback',
      (WidgetTester tester) async {
    DetectedFoodItem? editedItem;

    await tester.pumpWidget(
      buildTestWidget(
        onEditPortion: (item) {
          editedItem = item;
        },
      ),
    );

    final editButton = find.byKey(const Key('edit_portion_food-2'));
    expect(editButton, findsOneWidget);

    await tester.tap(editButton);
    await tester.pumpAndSettle();

    expect(editedItem, isNotNull);
    expect(editedItem?.id, 'food-2');
    expect(editedItem?.name, 'Ayam Bakar Dada');
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run:
```bash
flutter test test/features/food_analysis/presentation/screens/analysis_result_screen_test.dart
```

Expected: FAIL – Target files `analysis_result_screen.dart` and `food_item_card.dart` do not exist yet.

- [ ] **Step 3: Write minimal implementation**

Create `lib/src/features/food_analysis/presentation/widgets/food_item_card.dart`:
```dart
import 'package:flutter/material.dart';

class DetectedFoodItem {
  final String id;
  final String name;
  final double portion;
  final String portionUnit;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final Map<String, String>? dynamicNutrients;

  const DetectedFoodItem({
    required this.id,
    required this.name,
    required this.portion,
    required this.portionUnit,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.dynamicNutrients,
  });

  DetectedFoodItem copyWith({
    String? id,
    String? name,
    double? portion,
    String? portionUnit,
    int? calories,
    double? protein,
    double? carbs,
    double? fat,
    Map<String, String>? dynamicNutrients,
  }) {
    return DetectedFoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      portion: portion ?? this.portion,
      portionUnit: portionUnit ?? this.portionUnit,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      dynamicNutrients: dynamicNutrients ?? this.dynamicNutrients,
    );
  }
}

class FoodItemCard extends StatelessWidget {
  final DetectedFoodItem item;
  final ValueChanged<DetectedFoodItem>? onEditPortion;

  const FoodItemCard({
    super.key,
    required this.item,
    this.onEditPortion,
  });

  static const Color _accentColor = Color(0xFF047857);
  static const Color _surfaceColor = Color(0xFFFFFFFF);
  static const Color _borderColor = Color(0xFFE2E8F0);
  static const Color _textPrimary = Color(0xFF0F172A);
  static const Color _textSecondary = Color(0xFF475569);
  static const Color _mutedBackground = Color(0xFFF1F5F9);

  String _formatPortion(double portion, String unit) {
    final formattedNumber = portion % 1 == 0
        ? portion.toInt().toString()
        : portion.toStringAsFixed(1);
    return '$formattedNumber $unit';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor, width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatPortion(item.portion, item.portionUnit),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: _textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _mutedBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${item.calories} kkal',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _accentColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildMacroChip('P', '${item.protein.toStringAsFixed(1)}g', 'Protein'),
              const SizedBox(width: 8),
              _buildMacroChip('K', '${item.carbs.toStringAsFixed(1)}g', 'Karbo'),
              const SizedBox(width: 8),
              _buildMacroChip('L', '${item.fat.toStringAsFixed(1)}g', 'Lemak'),
            ],
          ),
          if (item.dynamicNutrients != null && item.dynamicNutrients!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: item.dynamicNutrients!.entries.map((entry) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFCBD5E1), width: 0.5),
                  ),
                  child: Text(
                    '${entry.key}: ${entry.value}',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: _textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              key: Key('edit_portion_${item.id}'),
              onPressed: onEditPortion != null ? () => onEditPortion!(item) : null,
              style: OutlinedButton.styleFrom(
                foregroundColor: _accentColor,
                side: const BorderSide(color: _borderColor, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                visualDensity: VisualDensity.compact,
              ),
              icon: const Icon(Icons.tune_rounded, size: 16),
              label: const Text(
                'Ubah Porsi',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroChip(String letter, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _mutedBackground,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$letter: ',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: _textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
```

Create `lib/src/features/food_analysis/presentation/screens/analysis_result_screen.dart`:
```dart
import 'package:flutter/material.dart';
import '../widgets/food_item_card.dart';

export '../widgets/food_item_card.dart' show DetectedFoodItem, FoodItemCard;

class AnalysisResultScreen extends StatelessWidget {
  final List<DetectedFoodItem> items;
  final int compartmentCount;
  final ValueChanged<DetectedFoodItem>? onEditPortion;
  final VoidCallback? onConfirmSave;
  final VoidCallback? onRetake;

  const AnalysisResultScreen({
    super.key,
    required this.items,
    this.compartmentCount = 3,
    this.onEditPortion,
    this.onConfirmSave,
    this.onRetake,
  });

  static const Color _accentColor = Color(0xFF047857);
  static const Color _backgroundColor = Color(0xFFF8FAFC);
  static const Color _surfaceColor = Color(0xFFFFFFFF);
  static const Color _borderColor = Color(0xFFE2E8F0);
  static const Color _textPrimary = Color(0xFF0F172A);
  static const Color _textSecondary = Color(0xFF475569);

  int get _totalCalories => items.fold(0, (sum, item) => sum + item.calories);
  double get _totalProtein => items.fold(0.0, (sum, item) => sum + item.protein);
  double get _totalCarbs => items.fold(0.0, (sum, item) => sum + item.carbs);
  double get _totalFat => items.fold(0.0, (sum, item) => sum + item.fat);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _surfaceColor,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        title: const Text(
          'Hasil Analisis',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: _textPrimary,
          ),
        ),
        actions: [
          if (onRetake != null)
            TextButton.icon(
              onPressed: onRetake,
              icon: const Icon(Icons.refresh_rounded, size: 18, color: _textSecondary),
              label: const Text(
                'Ambil Ulang',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: _textSecondary,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Periksa kembali sebelum menyimpan.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: _textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFA7F3D0), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.dashboard_outlined, size: 16, color: _accentColor),
                  const SizedBox(width: 6),
                  Text(
                    'Ompreng: $compartmentCount Kompartemen',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _accentColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildTotalNutritionCard(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Makanan Terdeteksi',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _textPrimary,
                  ),
                ),
                Text(
                  '${items.length} item',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: _textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return FoodItemCard(
                  item: items[index],
                  onEditPortion: onEditPortion,
                );
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalNutritionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Energi',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: _textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$_totalCalories kkal',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: _accentColor,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: _borderColor),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNutrientStat('Protein', '${_totalProtein.toStringAsFixed(1)} g'),
              _buildNutrientStat('Karbohidrat', '${_totalCarbs.toStringAsFixed(1)} g'),
              _buildNutrientStat('Lemak', '${_totalFat.toStringAsFixed(1)} g'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: _textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: _textSecondary,
          ),
        ),
      ],
    );
  }
}
```

- [ ] **Step 4: Run tests — expect PASS**

Run:
```bash
flutter test test/features/food_analysis/presentation/screens/analysis_result_screen_test.dart
```

Expected: All 3 tests PASS.

**If it doesn't pass:** re-check Step 3's code against this step's test expectations before touching any other file — do not proceed to Step 5 or the next Task.
**If it fails again:** STOP — read the systematic-debugging skill (.claude/skills/systematic-debugging/SKILL.md or .cursor/skills/systematic-debugging/SKILL.md) and find the ROOT CAUSE before changing any code. Do not weaken tests to make them pass.

- [ ] **Step 5: Commit**

```bash
git add lib/src/features/food_analysis/presentation/screens/analysis_result_screen.dart lib/src/features/food_analysis/presentation/widgets/food_item_card.dart test/features/food_analysis/presentation/screens/analysis_result_screen_test.dart
git commit -m "feat(analysis): create multi-food result screen and ompreng food item cards"
```

### Task 2: Analysis Failure & Retry View

**Files:**
- Create: `lib/src/features/food_analysis/presentation/widgets/analysis_failure_view.dart`
- Modify: `lib/src/features/food_analysis/presentation/screens/analysis_result_screen.dart`
  - **Current state:** Exports `AnalysisResultScreen` which renders a list of `DetectedFoodItem` cards and a placeholder action bar; does not yet handle unrecognized media errors or retry fallbacks.
- Test: `test/features/food_analysis/presentation/widgets/analysis_failure_view_test.dart`

**Depends on:** Task 1

**Interfaces:**
- Consumes: `DetectedFoodItem`, `FoodItemCard`, `AnalysisResultScreen` (from Task 1)
- Produces: `AnalysisFailureView`

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizilens/src/features/food_analysis/presentation/screens/analysis_result_screen.dart';
import 'package:gizilens/src/features/food_analysis/presentation/widgets/analysis_failure_view.dart';

void main() {
  group('AnalysisFailureView', () {
    testWidgets('renders friendly failure message and action buttons', (tester) async {
      bool retakeCalled = false;
      bool galleryCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnalysisFailureView(
              onRetake: () => retakeCalled = true,
              onPickGallery: () => galleryCalled = true,
            ),
          ),
        ),
      );

      expect(find.text('Makanan belum dapat dikenali'), findsOneWidget);
      expect(
        find.text('Coba ambil ulang dengan seluruh ompreng terlihat jelas dan pencahayaan yang cukup.'),
        findsOneWidget,
      );
      expect(find.text('Ambil Ulang'), findsOneWidget);
      expect(find.text('Pilih dari Galeri'), findsOneWidget);

      await tester.tap(find.text('Ambil Ulang'));
      await tester.pump();
      expect(retakeCalled, isTrue);

      await tester.tap(find.text('Pilih dari Galeri'));
      await tester.pump();
      expect(galleryCalled, isTrue);
    });

    testWidgets('renders inside AnalysisResultScreen when isFailure is true', (tester) async {
      bool retakePressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: AnalysisResultScreen(
            items: const [],
            isFailure: true,
            onRetake: () => retakePressed = true,
          ),
        ),
      );

      expect(find.byType(AnalysisFailureView), findsOneWidget);
      expect(find.text('Makanan belum dapat dikenali'), findsOneWidget);

      await tester.tap(find.text('Ambil Ulang'));
      await tester.pump();
      expect(retakePressed, isTrue);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/food_analysis/presentation/widgets/analysis_failure_view_test.dart`
Expected: FAIL – Target file `analysis_failure_view.dart` not found and `AnalysisResultScreen` does not accept `isFailure`.

- [ ] **Step 3: Write minimal implementation**

Create `lib/src/features/food_analysis/presentation/widgets/analysis_failure_view.dart`:
```dart
import 'package:flutter/material.dart';

class AnalysisFailureView extends StatelessWidget {
  const AnalysisFailureView({
    super.key,
    required this.onRetake,
    this.onPickGallery,
  });

  final VoidCallback onRetake;
  final VoidCallback? onPickGallery;

  @override
  Widget build(BuildContext context) {
    const emeraldAccent = Color(0xFF047857);
    const foreground = Color(0xFF0F172A);
    const mutedForeground = Color(0xFF475569);
    const borderColor = Color(0xFFE2E8F0);
    const surfaceMuted = Color(0xFFF1F5F9);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: surfaceMuted,
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 1.5),
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 44,
                color: mutedForeground,
              ),
            ),
            const SizedBox(height: 24.0),
            const Text(
              'Makanan belum dapat dikenali',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: foreground,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 12.0),
            const Text(
              'Coba ambil ulang dengan seluruh ompreng terlihat jelas dan pencahayaan yang cukup.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.0,
                height: 1.5,
                fontWeight: FontWeight.w400,
                color: mutedForeground,
              ),
            ),
            const SizedBox(height: 32.0),
            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: ElevatedButton.icon(
                onPressed: onRetake,
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: const Text(
                  'Ambil Ulang',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: emeraldAccent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ),
            if (onPickGallery != null) ...[
              const SizedBox(height: 12.0),
              SizedBox(
                width: double.infinity,
                height: 50.0,
                child: OutlinedButton.icon(
                  onPressed: onPickGallery,
                  icon: const Icon(Icons.photo_library_outlined, size: 20),
                  label: const Text(
                    'Pilih dari Galeri',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: foreground,
                    side: const BorderSide(color: borderColor, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

Modify `lib/src/features/food_analysis/presentation/screens/analysis_result_screen.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:gizilens/src/features/food_analysis/presentation/widgets/analysis_failure_view.dart';
import 'package:gizilens/src/features/food_analysis/presentation/widgets/food_item_card.dart';

class AnalysisResultScreen extends StatelessWidget {
  const AnalysisResultScreen({
    super.key,
    required this.items,
    this.isFailure = false,
    this.onRetake,
    this.onPickGallery,
    this.onEditPortion,
    this.onSave,
  });

  final List<DetectedFoodItem> items;
  final bool isFailure;
  final VoidCallback? onRetake;
  final VoidCallback? onPickGallery;
  final ValueChanged<DetectedFoodItem>? onEditPortion;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFFF8FAFC);
    const foreground = Color(0xFF0F172A);
    const mutedForeground = Color(0xFF475569);
    const borderColor = Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'Hasil Analisis',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
            color: foreground,
          ),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(height: 1.0, color: borderColor),
        ),
      ),
      body: isFailure || items.isEmpty
          ? AnalysisFailureView(
              onRetake: onRetake ?? () {},
              onPickGallery: onPickGallery,
            )
          : ListView(
              padding: const EdgeInsets.all(20.0),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Makanan Terdeteksi (${items.length})',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: foreground,
                      ),
                    ),
                    const Text(
                      'Ompreng',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: mutedForeground,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                ...items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: FoodItemCard(
                      item: item,
                      onEditPortion: onEditPortion != null ? () => onEditPortion!(item) : null,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
```

- [ ] **Step 4: Run tests — expect PASS**

Run: `flutter test test/features/food_analysis/presentation/widgets/analysis_failure_view_test.dart`
Expected: All tests pass.

**If it doesn't pass:** re-check Step 3's code against this step's test expectations before touching any other file — do not proceed to Step 5 or the next Task.
**If it fails again:** STOP — read the systematic-debugging skill (.claude/skills/systematic-debugging/SKILL.md or .cursor/skills/systematic-debugging/SKILL.md) and find the ROOT CAUSE before changing any code. Do not weaken tests to make them pass.

- [ ] **Step 5: Commit**

```bash
git add lib/src/features/food_analysis/presentation/widgets/analysis_failure_view.dart lib/src/features/food_analysis/presentation/screens/analysis_result_screen.dart test/features/food_analysis/presentation/widgets/analysis_failure_view_test.dart
git commit -m "feat: implement analysis failure view with retake and gallery actions"
```

### Task 3: Portion Edit Bottom Sheet

**Files:**
- Create: `lib/src/features/food_analysis/presentation/widgets/portion_edit_sheet.dart`
- Test: `test/features/food_analysis/presentation/widgets/portion_edit_sheet_test.dart`

**Depends on:** Task 1

**Interfaces:**
- Consumes: `DetectedFoodItem` (from Task 1)
- Produces: `PortionEditSheet`, `onPortionUpdated` callback

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizilens/src/features/food_analysis/presentation/screens/analysis_result_screen.dart';
import 'package:gizilens/src/features/food_analysis/presentation/widgets/portion_edit_sheet.dart';

void main() {
  const sampleFood = DetectedFoodItem(
    id: 'food_01',
    name: 'Ayam Goreng Lengkuas',
    portion: 100.0,
    unit: 'gram',
    calories: 260.0,
    protein: 25.0,
    carbs: 4.0,
    fat: 16.0,
  );

  Widget buildTestableWidget({
    DetectedFoodItem foodItem = sampleFood,
    void Function(DetectedFoodItem)? onPortionUpdated,
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

  group('PortionEditSheet UI & Interaction Tests', () {
    testWidgets('renders food title, initial portion quantity, unit dropdown, and CTA', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      expect(find.text('Ubah Porsi'), findsOneWidget);
      expect(find.text('Ayam Goreng Lengkuas'), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
      expect(find.text('gram'), findsOneWidget);
      expect(find.text('Perbarui'), findsOneWidget);
      expect(find.text('Estimasi Nilai Gizi'), findsOneWidget);
      expect(find.text('260 kkal'), findsOneWidget);
    });

    testWidgets('tapping increment button increases portion and recalculates nutrition mockup', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      final incrementButton = find.byKey(const Key('portion_increment_button'));
      expect(incrementButton, findsOneWidget);

      await tester.tap(incrementButton);
      await tester.pumpAndSettle();

      // Default increment step is 10 for gram
      expect(find.text('110'), findsOneWidget);
      // Recalculated: 260 * (110 / 100) = 286 kkal
      expect(find.text('286 kkal'), findsOneWidget);
    });

    testWidgets('tapping decrement button decreases portion and recalculates nutrition mockup', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      final decrementButton = find.byKey(const Key('portion_decrement_button'));
      expect(decrementButton, findsOneWidget);

      await tester.tap(decrementButton);
      await tester.pumpAndSettle();

      // Default decrement step is 10 for gram
      expect(find.text('90'), findsOneWidget);
      // Recalculated: 260 * (90 / 100) = 234 kkal
      expect(find.text('234 kkal'), findsOneWidget);
    });

    testWidgets('changing unit via dropdown updates selected unit state', (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      final dropdown = find.byKey(const Key('portion_unit_dropdown'));
      expect(dropdown, findsOneWidget);

      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      final porsiOption = find.text('potong').last;
      await tester.tap(porsiOption);
      await tester.pumpAndSettle();

      expect(find.text('potong'), findsOneWidget);
    });

    testWidgets('tapping Perbarui triggers onPortionUpdated callback with updated item', (tester) async {
      DetectedFoodItem? updatedResult;

      await tester.pumpWidget(
        buildTestableWidget(
          onPortionUpdated: (item) {
            updatedResult = item;
          },
        ),
      );
      await tester.pumpAndSettle();

      // Tap increment twice: 100 -> 120
      final incrementButton = find.byKey(const Key('portion_increment_button'));
      await tester.tap(incrementButton);
      await tester.pumpAndSettle();
      await tester.tap(incrementButton);
      await tester.pumpAndSettle();

      final ctaButton = find.byKey(const Key('portion_save_cta'));
      await tester.tap(ctaButton);
      await tester.pumpAndSettle();

      expect(updatedResult, isNotNull);
      expect(updatedResult!.portion, 120.0);
      expect(updatedResult!.unit, 'gram');
      expect(updatedResult!.calories, 312.0);
      expect(updatedResult!.protein, 30.0);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/food_analysis/presentation/widgets/portion_edit_sheet_test.dart`
Expected: FAIL – Target file `lib/src/features/food_analysis/presentation/widgets/portion_edit_sheet.dart` does not exist.

- [ ] **Step 3: Write minimal implementation**

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gizilens/src/features/food_analysis/presentation/screens/analysis_result_screen.dart';

class PortionEditSheet extends StatefulWidget {
  final DetectedFoodItem foodItem;
  final void Function(DetectedFoodItem updatedItem)? onPortionUpdated;

  const PortionEditSheet({
    super.key,
    required this.foodItem,
    this.onPortionUpdated,
  });

  /// Convenience modal helper to display the portion editor inside a themed bottom sheet
  static Future<DetectedFoodItem?> show(
    BuildContext context, {
    required DetectedFoodItem foodItem,
    void Function(DetectedFoodItem updatedItem)? onPortionUpdated,
  }) {
    return showModalBottomSheet<DetectedFoodItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PortionEditSheet(
        foodItem: foodItem,
        onPortionUpdated: onPortionUpdated,
      ),
    );
  }

  @override
  State<PortionEditSheet> createState() => _PortionEditSheetState();
}

class _PortionEditSheetState extends State<PortionEditSheet> {
  static const Color _accentEmerald = Color(0xFF047857);
  static const Color _surfaceColor = Color(0xFFFFFFFF);
  static const Color _textPrimary = Color(0xFF0F172A);
  static const Color _textSecondary = Color(0xFF475569);
  static const Color _borderColor = Color(0xFFE2E8F0);
  static const Color _mutedBg = Color(0xFFF1F5F9);

  late TextEditingController _portionController;
  late double _currentPortion;
  late String _selectedUnit;

  final List<String> _availableUnits = ['gram', 'porsi', 'sdm', 'potong', 'mangkuk'];

  @override
  void initState() {
    super.initState();
    _currentPortion = widget.foodItem.portion > 0 ? widget.foodItem.portion : 100.0;
    _selectedUnit = _availableUnits.contains(widget.foodItem.unit)
        ? widget.foodItem.unit
        : _availableUnits.first;
    _portionController = TextEditingController(text: _formatPortion(_currentPortion));
  }

  @override
  void dispose() {
    _portionController.dispose();
    super.dispose();
  }

  String _formatPortion(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(1);
  }

  double get _stepSize {
    switch (_selectedUnit) {
      case 'gram':
        return 10.0;
      case 'porsi':
      case 'potong':
      case 'mangkuk':
        return 0.5;
      case 'sdm':
        return 1.0;
      default:
        return 1.0;
    }
  }

  void _updatePortion(double newPortion) {
    if (newPortion <= 0) return;
    setState(() {
      _currentPortion = double.parse(newPortion.toStringAsFixed(1));
      _portionController.text = _formatPortion(_currentPortion);
    });
  }

  double get _scaleRatio {
    final basePortion = widget.foodItem.portion > 0 ? widget.foodItem.portion : 1.0;
    return _currentPortion / basePortion;
  }

  double get _recalculatedCalories => (widget.foodItem.calories * _scaleRatio).roundToDouble();
  double get _recalculatedProtein => double.parse((widget.foodItem.protein * _scaleRatio).toStringAsFixed(1));
  double get _recalculatedCarbs => double.parse((widget.foodItem.carbs * _scaleRatio).toStringAsFixed(1));
  double get _recalculatedFat => double.parse((widget.foodItem.fat * _scaleRatio).toStringAsFixed(1));

  DetectedFoodItem _buildUpdatedItem() {
    return DetectedFoodItem(
      id: widget.foodItem.id,
      name: widget.foodItem.name,
      portion: _currentPortion,
      unit: _selectedUnit,
      calories: _recalculatedCalories,
      protein: _recalculatedProtein,
      carbs: _recalculatedCarbs,
      fat: _recalculatedFat,
    );
  }

  void _onSave() {
    final updated = _buildUpdatedItem();
    widget.onPortionUpdated?.call(updated);
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, 24 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: _borderColor,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ubah Porsi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: _textPrimary,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.foodItem.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: _accentEmerald,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: _textSecondary, size: 22),
                tooltip: 'Tutup',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Portion & Unit Input Form Controls
          Row(
            children: [
              // Stepper Quantity Controller
              Expanded(
                flex: 3,
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: _mutedBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _borderColor),
                  ),
                  child: Row(
                    children: [
                      Semantics(
                        label: 'Kurangi porsi',
                        child: InkWell(
                          key: const Key('portion_decrement_button'),
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                          onTap: () => _updatePortion(_currentPortion - _stepSize),
                          child: const SizedBox(
                            width: 44,
                            height: double.infinity,
                            child: Icon(Icons.remove_rounded, color: _textPrimary, size: 20),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          key: const Key('portion_text_field'),
                          controller: _portionController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _textPrimary,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                          ],
                          onChanged: (val) {
                            final parsed = double.tryParse(val);
                            if (parsed != null && parsed > 0) {
                              setState(() {
                                _currentPortion = parsed;
                              });
                            }
                          },
                        ),
                      ),
                      Semantics(
                        label: 'Tambah porsi',
                        child: InkWell(
                          key: const Key('portion_increment_button'),
                          borderRadius: const BorderRadius.horizontal(right: Radius.circular(12)),
                          onTap: () => _updatePortion(_currentPortion + _stepSize),
                          child: const SizedBox(
                            width: 44,
                            height: double.infinity,
                            child: Icon(Icons.add_rounded, color: _textPrimary, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Unit Dropdown
              Expanded(
                flex: 2,
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: _surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _borderColor),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      key: const Key('portion_unit_dropdown'),
                      value: _selectedUnit,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: _textSecondary),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _textPrimary,
                      ),
                      items: _availableUnits.map((unit) {
                        return DropdownMenuItem<String>(
                          value: unit,
                          child: Text(unit),
                        );
                      }).toList(),
                      onChanged: (newUnit) {
                        if (newUnit != null) {
                          setState(() {
                            _selectedUnit = newUnit;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Dynamic Recalculated Nutrition Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _mutedBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Estimasi Nilai Gizi',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _textSecondary,
                        letterSpacing: 0.2,
                      ),
                    ),
                    Text(
                      '${_formatPortion(_recalculatedCalories)} kkal',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _accentEmerald,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildNutrientStat('Protein', '${_formatPortion(_recalculatedProtein)} g'),
                    _buildNutrientStat('Karbohidrat', '${_formatPortion(_recalculatedCarbs)} g'),
                    _buildNutrientStat('Lemak', '${_formatPortion(_recalculatedFat)} g'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Primary CTA Button
          ElevatedButton(
            key: const Key('portion_save_cta'),
            onPressed: _currentPortion > 0 ? _onSave : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _accentEmerald,
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Perbarui',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: _textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _textPrimary,
          ),
        ),
      ],
    );
  }
}
```

- [ ] **Step 4: Run tests — expect PASS**

Run: `flutter test test/features/food_analysis/presentation/widgets/portion_edit_sheet_test.dart`
Expected: PASS – All 5 tests pass.

**If it doesn't pass:** re-check Step 3's code against this step's test expectations before touching any other file — do not proceed to Step 5 or the next Task.
**If it fails again:** STOP — read the systematic-debugging skill (.claude/skills/systematic-debugging/SKILL.md or .cursor/skills/systematic-debugging/SKILL.md) and find the ROOT CAUSE before changing any code. Do not weaken tests to make them pass.

- [ ] **Step 5: Commit**

```bash
git add lib/src/features/food_analysis/presentation/widgets/portion_edit_sheet.dart test/features/food_analysis/presentation/widgets/portion_edit_sheet_test.dart
git commit -m "feat(analysis): build portion edit bottom sheet with dynamic recalculation"
```

### Task 4: Consumption Confirmation Bar & Double-Tap Lock

**Files:**
- Create: `lib/src/features/food_analysis/presentation/widgets/consumption_confirmation_bar.dart`
- Modify: `lib/src/features/food_analysis/presentation/screens/analysis_result_screen.dart`
  - **Current state:** Exports `AnalysisResultScreen` which renders detected food item cards and an analysis failure fallback view, but currently uses a bare placeholder action bar without timestamp selection or submission locking.
- Test: `test/features/food_analysis/presentation/widgets/consumption_confirmation_bar_test.dart`

**Depends on:** Task 1

**Interfaces:**
- Consumes: `AppTheme` tokens, `AnalysisResultScreen`
- Produces: `ConsumptionConfirmationBar`, debounce/submission lock state

- [ ] **Step 1: Write the failing widget test**
```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizilens/src/features/food_analysis/presentation/widgets/consumption_confirmation_bar.dart';

void main() {
  group('ConsumptionConfirmationBar Widget Tests', () {
    testWidgets('renders timestamp preview and Simpan Konsumsi primary CTA button', (tester) async {
      final fixedDateTime = DateTime(2025, 2, 18, 12, 30);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: ConsumptionConfirmationBar(
              initialDateTime: fixedDateTime,
              onDateTimeChanged: (_) {},
              onConfirmSave: () async {},
            ),
          ),
        ),
      );

      expect(find.text('Waktu Konsumsi'), findsOneWidget);
      expect(find.text('12:30 WIB'), findsOneWidget);
      expect(find.text('Simpan Konsumsi'), findsOneWidget);
    });

    testWidgets('triggers date and time picker on timestamp row tap', (tester) async {
      DateTime? selectedDate;
      final fixedDateTime = DateTime(2025, 2, 18, 12, 30);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: ConsumptionConfirmationBar(
              initialDateTime: fixedDateTime,
              onDateTimeChanged: (val) => selectedDate = val,
              onConfirmSave: () async {},
            ),
          ),
        ),
      );

      final timestampTapTarget = find.byKey(const Key('consumption_timestamp_picker_button'));
      expect(timestampTapTarget, findsOneWidget);
      await tester.tap(timestampTapTarget);
      await tester.pumpAndSettle();

      // TimePicker dialog shows up
      expect(find.byType(TimePickerDialog), findsOneWidget);

      // Confirm default time in picker
      final okButton = find.text('OK');
      await tester.tap(okButton);
      await tester.pumpAndSettle();

      expect(selectedDate, isNotNull);
    });

    testWidgets('prevents double-tap repeated submission and disables button when submitting', (tester) async {
      int callCount = 0;
      final completer = Completer<void>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: ConsumptionConfirmationBar(
              initialDateTime: DateTime.now(),
              onDateTimeChanged: (_) {},
              onConfirmSave: () async {
                callCount++;
                await completer.future;
              },
            ),
          ),
        ),
      );

      final saveButton = find.byKey(const Key('confirm_save_consumption_button'));

      // First tap triggers submission
      await tester.tap(saveButton);
      await tester.pump();

      // Second tap immediately while in-flight
      await tester.tap(saveButton);
      await tester.pump();

      expect(callCount, equals(1));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Complete future to release lock
      completer.complete();
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Simpan Konsumsi'), findsOneWidget);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**
Run: `flutter test test/features/food_analysis/presentation/widgets/consumption_confirmation_bar_test.dart`
Expected: FAIL – `consumption_confirmation_bar.dart` not found.

- [ ] **Step 3: Write minimal implementation**
Create `lib/src/features/food_analysis/presentation/widgets/consumption_confirmation_bar.dart`:
```dart
import 'package:flutter/material.dart';

class ConsumptionConfirmationBar extends StatefulWidget {
  const ConsumptionConfirmationBar({
    super.key,
    required this.initialDateTime,
    required this.onDateTimeChanged,
    required this.onConfirmSave,
    this.isSubmitting = false,
  });

  final DateTime initialDateTime;
  final ValueChanged<DateTime> onDateTimeChanged;
  final Future<void> Function() onConfirmSave;
  final bool isSubmitting;

  @override
  State<ConsumptionConfirmationBar> createState() => _ConsumptionConfirmationBarState();
}

class _ConsumptionConfirmationBarState extends State<ConsumptionConfirmationBar> {
  late DateTime _selectedDateTime;
  bool _internalLock = false;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.initialDateTime;
  }

  @override
  void didUpdateWidget(covariant ConsumptionConfirmationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialDateTime != widget.initialDateTime) {
      _selectedDateTime = widget.initialDateTime;
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute WIB';
  }

  Future<void> _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF047857),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      final updatedDateTime = DateTime(
        _selectedDateTime.year,
        _selectedDateTime.month,
        _selectedDateTime.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      setState(() {
        _selectedDateTime = updatedDateTime;
      });
      widget.onDateTimeChanged(updatedDateTime);
    }
  }

  Future<void> _handleSave() async {
    if (_internalLock || widget.isSubmitting) return;

    setState(() {
      _internalLock = true;
    });

    try {
      await widget.onConfirmSave();
    } finally {
      if (mounted) {
        setState(() {
          _internalLock = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBusy = _internalLock || widget.isSubmitting;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE2E8F0),
            width: 1.0,
          ),
        ),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom > 0
            ? MediaQuery.of(context).padding.bottom + 4
            : 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            key: const Key('consumption_timestamp_picker_button'),
            onTap: isBusy ? null : _pickTime,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    size: 18,
                    color: Color(0xFF475569),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Waktu Konsumsi',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF475569),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(_selectedDateTime),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 16,
                          color: Color(0xFF475569),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              key: const Key('confirm_save_consumption_button'),
              onPressed: isBusy ? null : _handleSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF047857),
                disabledBackgroundColor: const Color(0xFF047857).withOpacity(0.5),
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isBusy
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Simpan Konsumsi',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.1,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
```

Modify `lib/src/features/food_analysis/presentation/screens/analysis_result_screen.dart` to wire up `ConsumptionConfirmationBar`:
```dart
import 'package:flutter/material.dart';
import 'package:gizilens/src/features/food_analysis/presentation/widgets/analysis_failure_view.dart';
import 'package:gizilens/src/features/food_analysis/presentation/widgets/consumption_confirmation_bar.dart';
import 'package:gizilens/src/features/food_analysis/presentation/widgets/food_item_card.dart';

class AnalysisResultScreen extends StatefulWidget {
  const AnalysisResultScreen({
    super.key,
    this.detectedItems = const [],
    this.hasError = false,
    this.errorMessage,
    this.onRetake,
    this.onSelectFromGallery,
    this.onSaveConfirmed,
  });

  final List<DetectedFoodItem> detectedItems;
  final bool hasError;
  final String? errorMessage;
  final VoidCallback? onRetake;
  final VoidCallback? onSelectFromGallery;
  final Future<void> Function(DateTime consumptionTime)? onSaveConfirmed;

  @override
  State<AnalysisResultScreen> createState() => _AnalysisResultScreenState();
}

class _AnalysisResultScreenState extends State<AnalysisResultScreen> {
  late DateTime _consumptionTime;

  @override
  void initState() {
    super.initState();
    _consumptionTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hasError) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: const BackButton(color: Color(0xFF0F172A)),
          title: const Text(
            'Hasil Analisis',
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: AnalysisFailureView(
          errorMessage: widget.errorMessage,
          onRetake: widget.onRetake,
          onSelectFromGallery: widget.onSelectFromGallery,
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: const BackButton(color: Color(0xFF0F172A)),
        title: const Text(
          'Hasil Analisis',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: widget.detectedItems.isEmpty
          ? const Center(
              child: Text(
                'Tidak ada makanan terdeteksi.',
                style: TextStyle(
                  color: Color(0xFF475569),
                  fontSize: 14,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              itemCount: widget.detectedItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = widget.detectedItems[index];
                return FoodItemCard(item: item);
              },
            ),
      bottomNavigationBar: widget.detectedItems.isEmpty
          ? null
          : ConsumptionConfirmationBar(
              initialDateTime: _consumptionTime,
              onDateTimeChanged: (newDateTime) {
                setState(() {
                  _consumptionTime = newDateTime;
                });
              },
              onConfirmSave: () async {
                if (widget.onSaveConfirmed != null) {
                  await widget.onSaveConfirmed!(_consumptionTime);
                }
              },
            ),
    );
  }
}
```

- [ ] **Step 4: Run tests — expect PASS**
Run: `flutter test test/features/food_analysis/presentation/widgets/consumption_confirmation_bar_test.dart`
Expected: ALL PASS.

**If it doesn't pass:** re-check Step 3's code against this step's test expectations before touching any other file — do not proceed to Step 5 or the next Task.
**If it fails again:** STOP — read the systematic-debugging skill (.claude/skills/systematic-debugging/SKILL.md or .cursor/skills/systematic-debugging/SKILL.md) and find the ROOT CAUSE before changing any code. Do not weaken tests to make them pass.

- [ ] **Step 5: Commit**
```bash
git add lib/src/features/food_analysis/presentation/widgets/consumption_confirmation_bar.dart lib/src/features/food_analysis/presentation/screens/analysis_result_screen.dart test/features/food_analysis/presentation/widgets/consumption_confirmation_bar_test.dart
git commit -m "feat(food_analysis): build consumption confirmation bar with timestamp picker and double-tap submit lock"
```

### Task 5: Save Success & Recoverable Failure UI

**Files:**
- Create: `lib/src/features/food_analysis/presentation/widgets/save_feedback_toast.dart`
- Create: `lib/src/features/food_analysis/presentation/widgets/save_failure_dialog.dart`
- Modify: `lib/src/features/food_analysis/presentation/screens/analysis_result_screen.dart`
  - **Current state:** Exports `AnalysisResultScreen` with detected food item cards and `ConsumptionConfirmationBar`, but does not present lightweight save success feedback or handle recoverable save failure modals.
- Test: `test/features/food_analysis/presentation/widgets/save_feedback_test.dart`

**Depends on:** Task 4

**Interfaces:**
- Consumes: `ConsumptionConfirmationBar` (from Task 4), `AnalysisResultScreen` (from Task 4), `DetectedFoodItem` (from Task 1)
- Produces: `showSaveSuccessToast`, `SaveFailureDialog`

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizilens/src/features/food_analysis/presentation/widgets/save_feedback_toast.dart';
import 'package:gizilens/src/features/food_analysis/presentation/widgets/save_failure_dialog.dart';
import 'package:gizilens/src/features/food_analysis/presentation/screens/analysis_result_screen.dart';
import 'package:gizilens/src/features/food_analysis/presentation/widgets/food_item_card.dart';

void main() {
  group('Save Feedback UI Tests', () {
    testWidgets('showSaveSuccessToast renders floating banner with success copy', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showSaveSuccessToast(context),
                child: const Text('Show Toast'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Toast'));
      await tester.pump(); // Start animation

      expect(find.text('Konsumsi berhasil disimpan'), findsOneWidget);
      expect(find.text('Ringkasan harian telah diperbarui.'), findsOneWidget);
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    });

    testWidgets('SaveFailureDialog renders recoverable error copy and triggers onRetry', (tester) async {
      bool retryTriggered = false;
      bool dismissTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => SaveFailureDialog(
                      onRetry: () => retryTriggered = true,
                      onDismiss: () => dismissTriggered = true,
                    ),
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Konsumsi belum tersimpan'), findsOneWidget);
      expect(
        find.text('Hasil analisismu masih tersedia. Coba simpan kembali.'),
        findsOneWidget,
      );
      expect(find.text('Simpan Lagi'), findsOneWidget);
      expect(find.text('Nanti'), findsOneWidget);

      await tester.tap(find.text('Simpan Lagi'));
      await tester.pumpAndSettle();

      expect(retryTriggered, isTrue);
      expect(dismissTriggered, isFalse);
    });

    testWidgets('AnalysisResultScreen triggers SaveFailureDialog on failure without clearing food items', (tester) async {
      final sampleItems = [
        const DetectedFoodItem(
          id: 'food-1',
          name: 'Nasi Putih',
          portion: 150,
          unit: 'gram',
          calories: 195,
          protein: 4.1,
          carbs: 43.2,
          fat: 0.4,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: AnalysisResultScreen(
            items: sampleItems,
            onSaveRecord: (time) async => false, // Simulate failure
          ),
        ),
      );

      // Verify item is present
      expect(find.text('Nasi Putih'), findsOneWidget);

      // Tap Simpan Konsumsi
      await tester.tap(find.text('Simpan Konsumsi'));
      await tester.pumpAndSettle();

      // Dialog appears
      expect(find.text('Konsumsi belum tersimpan'), findsOneWidget);

      // Dismiss dialog
      await tester.tap(find.text('Nanti'));
      await tester.pumpAndSettle();

      // Food item is still visible on screen
      expect(find.text('Nasi Putih'), findsOneWidget);
    });

    testWidgets('AnalysisResultScreen triggers showSaveSuccessToast on successful save', (tester) async {
      final sampleItems = [
        const DetectedFoodItem(
          id: 'food-1',
          name: 'Ayam Panggang',
          portion: 100,
          unit: 'gram',
          calories: 220,
          protein: 26.0,
          carbs: 0.0,
          fat: 12.0,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: AnalysisResultScreen(
            items: sampleItems,
            onSaveRecord: (time) async => true, // Simulate success
          ),
        ),
      );

      await tester.tap(find.text('Simpan Konsumsi'));
      await tester.pump(); // Pump frame for SnackBar

      expect(find.text('Konsumsi berhasil disimpan'), findsOneWidget);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/food_analysis/presentation/widgets/save_feedback_test.dart`
Expected: FAIL – target libraries `save_feedback_toast.dart` and `save_failure_dialog.dart` not found.

- [ ] **Step 3: Write minimal implementation**

Write `lib/src/features/food_analysis/presentation/widgets/save_feedback_toast.dart`:
```dart
import 'package:flutter/material.dart';

/// Shows a lightweight floating SnackBar indicating successful consumption logging.
void showSaveSuccessToast(
  BuildContext context, {
  String message = 'Konsumsi berhasil disimpan',
  String subtitle = 'Ringkasan harian telah diperbarui.',
  Duration duration = const Duration(seconds: 3),
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      backgroundColor: const Color(0xFF0F172A),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF1E293B)),
      ),
      duration: duration,
      content: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF16A34A).withAlpha(40),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Color(0xFF16A34A),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(
                    color: Color(0xFFF8FAFC),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
```

Write `lib/src/features/food_analysis/presentation/widgets/save_failure_dialog.dart`:
```dart
import 'package:flutter/material.dart';

/// Modal dialog presented when saving consumption fails, allowing recoverable retry
/// while keeping the current analysis result fully intact.
class SaveFailureDialog extends StatelessWidget {
  final VoidCallback onRetry;
  final VoidCallback? onDismiss;

  const SaveFailureDialog({
    super.key,
    required this.onRetry,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFD97706).withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFD97706),
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Konsumsi belum tersimpan',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
              letterSpacing: -0.15,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Hasil analisismu masih tersedia. Coba simpan kembali.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF475569),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onDismiss?.call();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF475569),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Nanti',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onRetry();
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF047857),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Simpan Lagi',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

Modify `lib/src/features/food_analysis/presentation/screens/analysis_result_screen.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:gizilens/src/features/food_analysis/presentation/widgets/food_item_card.dart';
import 'package:gizilens/src/features/food_analysis/presentation/widgets/analysis_failure_view.dart';
import 'package:gizilens/src/features/food_analysis/presentation/widgets/consumption_confirmation_bar.dart';
import 'package:gizilens/src/features/food_analysis/presentation/widgets/save_feedback_toast.dart';
import 'package:gizilens/src/features/food_analysis/presentation/widgets/save_failure_dialog.dart';

class AnalysisResultScreen extends StatefulWidget {
  final List<DetectedFoodItem> items;
  final bool isFailed;
  final VoidCallback? onRetake;
  final VoidCallback? onSelectGallery;
  final Future<bool> Function(DateTime consumptionTime)? onSaveRecord;
  final VoidCallback? onSaveSuccess;

  const AnalysisResultScreen({
    super.key,
    required this.items,
    this.isFailed = false,
    this.onRetake,
    this.onSelectGallery,
    this.onSaveRecord,
    this.onSaveSuccess,
  });

  @override
  State<AnalysisResultScreen> createState() => _AnalysisResultScreenState();
}

class _AnalysisResultScreenState extends State<AnalysisResultScreen> {
  late List<DetectedFoodItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.items);
  }

  Future<void> _handleSave(DateTime consumptionTime) async {
    final saveHandler = widget.onSaveRecord ?? (_) async => true;
    final success = await saveHandler(consumptionTime);

    if (!mounted) return;

    if (success) {
      showSaveSuccessToast(context);
      widget.onSaveSuccess?.call();
    } else {
      showDialog(
        context: context,
        builder: (_) => SaveFailureDialog(
          onRetry: () => _handleSave(consumptionTime),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isFailed) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: const Text(
            'Hasil Analisis',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
        ),
        body: AnalysisFailureView(
          onRetake: widget.onRetake,
          onSelectGallery: widget.onSelectGallery,
        ),
      );
    }

    final totalCalories = _items.fold<int>(0, (sum, item) => sum + item.calories);
    final totalProtein = _items.fold<double>(0.0, (sum, item) => sum + item.protein);
    final totalCarbs = _items.fold<double>(0.0, (sum, item) => sum + item.carbs);
    final totalFat = _items.fold<double>(0.0, (sum, item) => sum + item.fat);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Hasil Analisis',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ringkasan Nutrisi Total',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$totalCalories kkal',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF047857),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildMacroBadge('Protein', '${totalProtein.toStringAsFixed(1)}g'),
                    const SizedBox(width: 8),
                    _buildMacroBadge('Karbo', '${totalCarbs.toStringAsFixed(1)}g'),
                    const SizedBox(width: 8),
                    _buildMacroBadge('Lemak', '${totalFat.toStringAsFixed(1)}g'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Makanan Terdeteksi (${_items.length})',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A),
                ),
              ),
              const Text(
                'Ompreng',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF047857),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: FoodItemCard(
                item: item,
                onEditPortion: () {},
              ),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
      bottomNavigationBar: ConsumptionConfirmationBar(
        onSave: _handleSave,
      ),
    );
  }

  Widget _buildMacroBadge(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF475569),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run tests — expect PASS**

Run: `flutter test test/features/food_analysis/presentation/widgets/save_feedback_test.dart`
Expected: All 4 tests PASS.

**If it doesn't pass:** re-check Step 3's code against this step's test expectations before touching any other file — do not proceed to Step 5 or the next Task.
**If it fails again:** STOP — read the systematic-debugging skill (.claude/skills/systematic-debugging/SKILL.md or .cursor/skills/systematic-debugging/SKILL.md) and find the ROOT CAUSE before changing any code. Do not weaken tests to make them pass.

- [ ] **Step 5: Commit**

```bash
git add lib/src/features/food_analysis/presentation/widgets/save_feedback_toast.dart lib/src/features/food_analysis/presentation/widgets/save_failure_dialog.dart lib/src/features/food_analysis/presentation/screens/analysis_result_screen.dart test/features/food_analysis/presentation/widgets/save_feedback_test.dart
git commit -m "feat(food_analysis): add save success toast and recoverable failure dialog"
```

### Task 6: Dynamic Nutrient Detail Screen

**Files:**
- Create: `lib/src/features/nutrition_detail/presentation/widgets/nutrient_breakdown_item.dart`
- Create: `lib/src/features/nutrition_detail/presentation/screens/nutrition_detail_screen.dart`
- Test: `test/features/nutrition_detail/presentation/screens/nutrition_detail_screen_test.dart`

**Depends on:** none

**Interfaces:**
- Consumes: none (consumes standalone theme styling and mock data)
- Produces: `NutrientStatus`, `NutrientData`, `NutrientBreakdownItem`, `NutritionDetailScreen`

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizilens/src/features/nutrition_detail/presentation/screens/nutrition_detail_screen.dart';
import 'package:gizilens/src/features/nutrition_detail/presentation/widgets/nutrient_breakdown_item.dart';

void main() {
  group('NutritionDetailScreen Widget Tests', () {
    testWidgets('renders screen header, energy summary, and section headings', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NutritionDetailScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Detail Nutrisi'), findsOneWidget);
      expect(find.text('Ringkasan Energi'), findsOneWidget);
      expect(find.text('Makronutrien'), findsOneWidget);
      expect(find.text('Mikronutrien'), findsOneWidget);
    });

    testWidgets('renders warning status and contextual feedback for approaching limit nutrient', (tester) async {
      final customNutrients = [
        const NutrientData(
          name: 'Natrium',
          value: 1740,
          unit: 'mg',
          target: 2000,
          status: NutrientStatus.approachingLimit,
          feedback: 'Asupan natrium hari ini sudah mendekati batas harian 2.000 mg.',
          isMacro: false,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: NutritionDetailScreen(nutrients: customNutrients),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Natrium'), findsOneWidget);
      expect(find.text('1740 / 2000 mg'), findsOneWidget);
      expect(find.text('Mendekati batas'), findsOneWidget);
      expect(
        find.text('Asupan natrium hari ini sudah mendekati batas harian 2.000 mg.'),
        findsOneWidget,
      );
    });

    testWidgets('renders Target belum tersedia when target is null and does not display 0%', (tester) async {
      final customNutrients = [
        const NutrientData(
          name: 'Vitamin B12',
          value: 2.1,
          unit: 'µg',
          target: null,
          status: NutrientStatus.noTarget,
          isMacro: false,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: NutritionDetailScreen(nutrients: customNutrients),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Vitamin B12'), findsOneWidget);
      expect(find.text('2.1 µg'), findsOneWidget);
      expect(find.text('Target belum tersedia'), findsOneWidget);
      expect(find.text('0%'), findsNothing);
    });

    testWidgets('preserves value of 0 and distinguishes it from missing data', (tester) async {
      final customNutrients = [
        const NutrientData(
          name: 'Kolesterol',
          value: 0,
          unit: 'mg',
          target: 300,
          status: NutrientStatus.adequate,
          isMacro: false,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: NutritionDetailScreen(nutrients: customNutrients),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Kolesterol'), findsOneWidget);
      expect(find.text('0 / 300 mg'), findsOneWidget);
      expect(find.text('Cukup'), findsOneWidget);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/nutrition_detail/presentation/screens/nutrition_detail_screen_test.dart`

Expected output outside fence:
Expected: FAIL – target of URI does not exist or classes `NutritionDetailScreen`, `NutrientData`, and `NutrientBreakdownItem` are not found.

- [ ] **Step 3: Write minimal implementation**

Create `lib/src/features/nutrition_detail/presentation/widgets/nutrient_breakdown_item.dart`:

```dart
import 'package:flutter/material.dart';

enum NutrientStatus {
  low,
  adequate,
  approachingLimit,
  excessive,
  noTarget,
}

class NutrientData {
  final String name;
  final double value;
  final String unit;
  final double? target;
  final NutrientStatus status;
  final String? feedback;
  final bool isMacro;

  const NutrientData({
    required this.name,
    required this.value,
    required this.unit,
    this.target,
    required this.status,
    this.feedback,
    required this.isMacro,
  });

  double? get percentage {
    if (target == null || target == 0) return null;
    return (value / target!) * 100;
  }
}

class NutrientBreakdownItem extends StatelessWidget {
  final NutrientData nutrient;

  const NutrientBreakdownItem({
    super.key,
    required this.nutrient,
  });

  String _formatNumber(double val) {
    if (val == val.roundToDouble()) {
      return val.toInt().toString();
    }
    return val.toStringAsFixed(1);
  }

  Color _getStatusColor(NutrientStatus status) {
    switch (status) {
      case NutrientStatus.adequate:
        return const Color(0xFF16A34A); // Success
      case NutrientStatus.approachingLimit:
        return const Color(0xFFD97706); // Warning
      case NutrientStatus.excessive:
        return const Color(0xFFDC2626); // Destructive
      case NutrientStatus.low:
        return const Color(0xFF0284C7); // Info
      case NutrientStatus.noTarget:
        return const Color(0xFF64748B); // Slate neutral
    }
  }

  String _getStatusLabel(NutrientStatus status) {
    switch (status) {
      case NutrientStatus.adequate:
        return 'Cukup';
      case NutrientStatus.approachingLimit:
        return 'Mendekati batas';
      case NutrientStatus.excessive:
        return 'Berlebih';
      case NutrientStatus.low:
        return 'Rendah';
      case NutrientStatus.noTarget:
        return 'Target belum tersedia';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(nutrient.status);
    final statusLabel = _getStatusLabel(nutrient.status);
    final percent = nutrient.percentage;
    final progressFraction = percent != null ? (percent / 100).clamp(0.0, 1.0) : null;

    final String amountText = nutrient.target != null
        ? '${_formatNumber(nutrient.value)} / ${_formatNumber(nutrient.target!)} ${nutrient.unit}'
        : '${_formatNumber(nutrient.value)} ${nutrient.unit}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  nutrient.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                amountText,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF475569),
                ),
              ),
              if (percent != null)
                Text(
                  '${percent.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
            ],
          ),
          if (progressFraction != null) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progressFraction,
                backgroundColor: const Color(0xFFF1F5F9),
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                minHeight: 6,
              ),
            ),
          ],
          if (nutrient.feedback != null && nutrient.feedback!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: statusColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      nutrient.feedback!,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
```

Create `lib/src/features/nutrition_detail/presentation/screens/nutrition_detail_screen.dart`:

```dart
import 'package:flutter/material.dart';
import '../widgets/nutrient_breakdown_item.dart';

class NutritionDetailScreen extends StatelessWidget {
  final List<NutrientData>? nutrients;

  const NutritionDetailScreen({
    super.key,
    this.nutrients,
  });

  static List<NutrientData> get _defaultMockNutrients {
    return const [
      // Makronutrien
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
        feedback: 'Tingkatkan konsumsi sayur dan buah untuk memenuhi target serat.',
        isMacro: true,
      ),
      // Mikronutrien
      NutrientData(
        name: 'Natrium',
        value: 1740,
        unit: 'mg',
        target: 2000,
        status: NutrientStatus.approachingLimit,
        feedback: 'Asupan natrium hari ini sudah mendekati batas harian 2.000 mg.',
        isMacro: false,
      ),
      NutrientData(
        name: 'Kalsium',
        value: 650,
        unit: 'mg',
        target: 1000,
        status: NutrientStatus.adequate,
        isMacro: false,
      ),
      NutrientData(
        name: 'Zat Besi',
        value: 12,
        unit: 'mg',
        target: 18,
        status: NutrientStatus.adequate,
        isMacro: false,
      ),
      NutrientData(
        name: 'Vitamin B12',
        value: 2.1,
        unit: 'µg',
        target: null,
        status: NutrientStatus.noTarget,
        isMacro: false,
      ),
      NutrientData(
        name: 'Kalium',
        value: 2100,
        unit: 'mg',
        target: 4700,
        status: NutrientStatus.low,
        isMacro: false,
      ),
    ];
  }

  int _sortNutrientPriority(NutrientData a, NutrientData b) {
    // 1. Attention/warning or danger first
    int rank(NutrientStatus s) {
      switch (s) {
        case NutrientStatus.approachingLimit:
          return 0;
        case NutrientStatus.excessive:
          return 1;
        case NutrientStatus.low:
          return 2;
        case NutrientStatus.adequate:
          return 3;
        case NutrientStatus.noTarget:
          return 4;
      }
    }

    final diff = rank(a.status).compareTo(rank(b.status));
    if (diff != 0) return diff;
    return a.name.compareTo(b.name);
  }

  @override
  Widget build(BuildContext context) {
    final list = nutrients ?? _defaultMockNutrients;
    final macros = list.where((n) => n.isMacro).toList();
    final micros = list.where((n) => !n.isMacro).toList()..sort(_sortNutrientPriority);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: 'Kembali',
        ),
        title: const Text(
          'Detail Nutrisi',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
            letterSpacing: -0.2,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: const Color(0xFFE2E8F0),
            height: 1,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            // Energy Summary Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ringkasan Energi',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF475569),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF047857).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          '73% tercapai',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF047857),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '1.540',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        '/ 2.100 kkal',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: const LinearProgressIndicator(
                      value: 0.73,
                      backgroundColor: Color(0xFFF1F5F9),
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF047857)),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Makronutrien Section
            const Text(
              'Makronutrien',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 12),
            ...macros.map((n) => NutrientBreakdownItem(nutrient: n)),
            const SizedBox(height: 20),

            // Mikronutrien Section
            const Text(
              'Mikronutrien',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Nutrisi dengan perhatian diprioritaskan di urutan atas.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 12),
            ...micros.map((n) => NutrientBreakdownItem(nutrient: n)),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run tests — expect PASS**

Run: `flutter test test/features/nutrition_detail/presentation/screens/nutrition_detail_screen_test.dart`
Expected: All tests pass successfully.

**If it doesn't pass:** re-check Step 3's code against Step 1's test expectations before touching any other file — do not proceed to Step 5 or the next Task.
**If it fails again:** STOP — read the systematic-debugging skill (.claude/skills/systematic-debugging/SKILL.md or .cursor/skills/systematic-debugging/SKILL.md) and find the ROOT CAUSE before changing any code. Do not weaken tests to make them pass.

- [ ] **Step 5: Commit**

```bash
git add lib/src/features/nutrition_detail/presentation/widgets/nutrient_breakdown_item.dart lib/src/features/nutrition_detail/presentation/screens/nutrition_detail_screen.dart test/features/nutrition_detail/presentation/screens/nutrition_detail_screen_test.dart
git commit -m "feat(nutrition_detail): implement dynamic nutrient detail screen and breakdown item"
```

### Task 7: Food Record Detail Screen

**Files:**
- Create: `lib/src/features/history/presentation/screens/food_record_detail_screen.dart`
- Create: `lib/src/features/history/presentation/widgets/food_record_nutrition_card.dart`
- Test: `test/features/history/presentation/screens/food_record_detail_screen_test.dart`

**Depends on:** Task 6

**Interfaces:**
- Consumes: `NutrientData`, `NutrientStatus`, `NutrientBreakdownItem` (from Task 6)
- Produces: `FoodRecordDetailScreen`, `FoodRecordNutritionCard`, `FoodRecordDetailData`, `RecordedFoodItem`

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizilens/src/features/history/presentation/screens/food_record_detail_screen.dart';
import 'package:gizilens/src/features/history/presentation/widgets/food_record_nutrition_card.dart';
import 'package:gizilens/src/features/nutrition_detail/presentation/widgets/nutrient_breakdown_item.dart';

void main() {
  group('FoodRecordDetailScreen Widget Tests', () {
    final testRecord = FoodRecordDetailData(
      id: 'rec-001',
      mealTitle: 'Makan Siang Ompreng',
      consumedAt: DateTime.now().subtract(const Duration(hours: 3)),
      mediaUrl: null,
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
      totalFat: 21.0,
      nutrients: const [
        NutrientData(
          id: 'fe',
          name: 'Zat Besi (Fe)',
          value: 3.2,
          unit: 'mg',
          target: 18.0,
          percentage: 17.7,
          status: NutrientStatus.adequate,
          feedback: 'Asupan zat besi dari bayam mencukupi porsi makan siang.',
        ),
        NutrientData(
          id: 'na',
          name: 'Natrium',
          value: 420.0,
          unit: 'mg',
          target: 2000.0,
          percentage: 21.0,
          status: NutrientStatus.adequate,
        ),
      ],
    );

    testWidgets('renders app bar, food items, nutrition card, and dynamic nutrients', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FoodRecordDetailScreen(record: testRecord),
        ),
      );
      await tester.pumpAndSettle();

      // Verify app bar
      expect(find.text('Detail Konsumsi'), findsOneWidget);
      expect(find.byType(BackButton), findsOneWidget);

      // Verify meal title and relative time subtitle
      expect(find.text('Makan Siang Ompreng'), findsOneWidget);
      expect(find.text('Daftar Makanan (3)'), findsOneWidget);

      // Verify food items with portions
      expect(find.text('Nasi Putih'), findsOneWidget);
      expect(find.text('150 gram • 195 kkal'), findsOneWidget);
      expect(find.text('Ayam Goreng Lengkuas'), findsOneWidget);
      expect(find.text('100 gram • 260 kkal'), findsOneWidget);
      expect(find.text('Sayur Bening Bayam'), findsOneWidget);

      // Verify nutrition summary card
      expect(find.byType(FoodRecordNutritionCard), findsOneWidget);
      expect(find.text('491'), findsOneWidget);
      expect(find.text('kkal'), findsWidgets);
      expect(find.text('28.5g'), findsOneWidget); // Protein
      expect(find.text('45.2g'), findsOneWidget); // Karbohidrat
      expect(find.text('21.0g'), findsOneWidget); // Lemak

      // Verify micronutrient list
      expect(find.byType(NutrientBreakdownItem), findsNWidgets(2));
      expect(find.text('Zat Besi (Fe)'), findsOneWidget);
      expect(find.text('Natrium'), findsOneWidget);
    });

    testWidgets('renders placeholder thumbnail when mediaUrl is null', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FoodRecordDetailScreen(record: testRecord),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.restaurant_outlined), findsOneWidget);
      expect(find.text('Foto Ompreng Makanan'), findsOneWidget);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/history/presentation/screens/food_record_detail_screen_test.dart`
Expected: FAIL – Target file and classes `FoodRecordDetailScreen`, `FoodRecordNutritionCard`, and `FoodRecordDetailData` do not exist yet.

- [ ] **Step 3: Write minimal implementation**

Create `lib/src/features/history/presentation/widgets/food_record_nutrition_card.dart`:

```dart
import 'package:flutter/material.dart';

class FoodRecordNutritionCard extends StatelessWidget {
  final double totalCalories;
  final double proteinGrams;
  final double carbsGrams;
  final double fatGrams;

  const FoodRecordNutritionCard({
    super.key,
    required this.totalCalories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const Text(
                'Total Energi',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF475569),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    totalCalories.toStringAsFixed(0),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF047857),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'kkal',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF475569),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildMacroItem(
                label: 'Protein',
                value: '${proteinGrams.toStringAsFixed(1)}g',
                color: const Color(0xFF0284C7),
              ),
              _buildDivider(),
              _buildMacroItem(
                label: 'Karbohidrat',
                value: '${carbsGrams.toStringAsFixed(1)}g',
                color: const Color(0xFFD97706),
              ),
              _buildDivider(),
              _buildMacroItem(
                label: 'Lemak',
                value: '${fatGrams.toStringAsFixed(1)}g',
                color: const Color(0xFFDC2626),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 32,
      color: const Color(0xFFE2E8F0),
      margin: const EdgeInsets.symmetric(horizontal: 12),
    );
  }

  Widget _buildMacroItem({
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF475569),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}
```

Create `lib/src/features/history/presentation/screens/food_record_detail_screen.dart`:

```dart
import 'package:flutter/material.dart';
import '../../nutrition_detail/presentation/widgets/nutrient_breakdown_item.dart';
import '../widgets/food_record_nutrition_card.dart';

class RecordedFoodItem {
  final String name;
  final double portionAmount;
  final String portionUnit;
  final double calories;

  const RecordedFoodItem({
    required this.name,
    required this.portionAmount,
    required this.portionUnit,
    required this.calories,
  });
}

class FoodRecordDetailData {
  final String id;
  final String mealTitle;
  final DateTime consumedAt;
  final String? mediaUrl;
  final List<RecordedFoodItem> items;
  final double totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;
  final List<NutrientData> nutrients;

  const FoodRecordDetailData({
    required this.id,
    required this.mealTitle,
    required this.consumedAt,
    this.mediaUrl,
    required this.items,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    required this.nutrients,
  });
}

class FoodRecordDetailScreen extends StatelessWidget {
  final FoodRecordDetailData record;

  const FoodRecordDetailScreen({
    super.key,
    required this.record,
  });

  String _formatTimestamp(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return 'Hari ini, $hour:$minute WIB';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFE2E8F0)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Detail Konsumsi',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Media thumbnail section
            _buildMediaPreview(context),
            const SizedBox(height: 20),

            // Meal title and time
            Text(
              record.mealTitle,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 14,
                  color: Color(0xFF475569),
                ),
                const SizedBox(width: 6),
                Text(
                  _formatTimestamp(record.consumedAt),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF475569),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Energy and Macronutrient Card
            FoodRecordNutritionCard(
              totalCalories: record.totalCalories,
              proteinGrams: record.totalProtein,
              carbsGrams: record.totalCarbs,
              fatGrams: record.totalFat,
            ),
            const SizedBox(height: 28),

            // Food items in the ompreng container
            Text(
              'Daftar Makanan (${record.items.length})',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: record.items.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  color: Color(0xFFE2E8F0),
                ),
                itemBuilder: (context, index) {
                  final item = record.items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF475569),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${item.portionAmount.toStringAsFixed(0)} ${item.portionUnit} • ${item.calories.toStringAsFixed(0)} kkal',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF475569),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 28),

            // Dynamic nutrient breakdown section
            if (record.nutrients.isNotEmpty) ...[
              const Text(
                'Rincian Nutrisi Terdeteksi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: record.nutrients.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  return NutrientBreakdownItem(data: record.nutrients[index]);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMediaPreview(BuildContext context) {
    if (record.mediaUrl != null && record.mediaUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.network(
            record.mediaUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildPlaceholder(),
          ),
        ),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_outlined,
            size: 36,
            color: Color(0xFF047857),
          ),
          SizedBox(height: 8),
          Text(
            'Foto Ompreng Makanan',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run tests — expect PASS**

Run: `flutter test test/features/history/presentation/screens/food_record_detail_screen_test.dart`
Expected: All tests PASS.

**If it doesn't pass:** re-check Step 3's code against this step's test expectations before touching any other file — do not proceed to Step 5 or the next Task.
**If it fails again:** STOP — read the systematic-debugging skill (.claude/skills/systematic-debugging/SKILL.md or .cursor/skills/systematic-debugging/SKILL.md) and find the ROOT CAUSE before changing any code. Do not weaken tests to make them pass.

- [ ] **Step 5: Commit**

```bash
git add lib/src/features/history/presentation/screens/food_record_detail_screen.dart lib/src/features/history/presentation/widgets/food_record_nutrition_card.dart test/features/history/presentation/screens/food_record_detail_screen_test.dart
git commit -m "feat(history): implement food record detail screen and nutrition summary card"
```

### Task 8: Horizontal Date Selector Strip

**Files:**
- Create: `lib/src/features/history/presentation/widgets/date_chip.dart`
- Create: `lib/src/features/history/presentation/widgets/horizontal_date_selector.dart`
- Test: `test/features/history/presentation/widgets/horizontal_date_selector_test.dart`

**Depends on:** none

**Interfaces:**
- Consumes: none (uses Material 3 design tokens: Emerald `#047857`, Surface `#ffffff`, Border `#e2e8f0`, Foreground `#0f172a`, Muted `#475569`)
- Produces: `HorizontalDateSelector`, `DateChip`, `onDateSelected` callback, `onCalendarTap` callback

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizilens/src/features/history/presentation/widgets/date_chip.dart';
import 'package:gizilens/src/features/history/presentation/widgets/horizontal_date_selector.dart';

void main() {
  group('DateChip', () {
    testWidgets('renders day of week and date number with inactive styling by default', (tester) async {
      final testDate = DateTime.now().subtract(const Duration(days: 2));
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DateChip(
              date: testDate,
              isSelected: false,
              isToday: false,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text(testDate.day.toString()), findsOneWidget);
      await tester.tap(find.byType(DateChip));
      expect(tapped, isTrue);
    });

    testWidgets('renders active styling and semantic selected state when isSelected is true', (tester) async {
      final today = DateTime.now();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DateChip(
              date: today,
              isSelected: true,
              isToday: true,
              onTap: () {},
            ),
          ),
        ),
      );

      final chipWidget = tester.widget<Material>(
        find.descendant(
          of: find.byType(DateChip),
          matching: find.byType(Material),
        ).first,
      );

      // Verify Emerald functional accent `#047857`
      expect(chipWidget.color, const Color(0xFF047857));
      expect(find.text('Hari ini'), findsOneWidget);
    });
  });

  group('HorizontalDateSelector', () {
    testWidgets('renders scrollable strip of dates and highlights selected date', (tester) async {
      final now = DateTime.now();
      final selectedDate = DateTime(now.year, now.month, now.day);
      DateTime? chosenDate;
      bool calendarClicked = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HorizontalDateSelector(
              selectedDate: selectedDate,
              onDateSelected: (date) => chosenDate = date,
              onCalendarTap: () => calendarClicked = true,
              anchorDate: selectedDate,
              daysCount: 7,
            ),
          ),
        ),
      );

      // Verify 7 date chips are generated
      expect(find.byType(DateChip), findsNWidgets(7));

      // Verify calendar icon button exists and triggers callback
      final calendarButton = find.byTooltip('Pilih tanggal dari kalender');
      expect(calendarButton, findsOneWidget);
      await tester.tap(calendarButton);
      expect(calendarClicked, isTrue);

      // Tap an earlier date chip
      final earlierDate = selectedDate.subtract(const Duration(days: 3));
      final earlierDayNumber = earlierDate.day.toString();
      final earlierChip = find.descendant(
        of: find.byType(DateChip),
        matching: find.text(earlierDayNumber),
      );

      await tester.tap(earlierChip.first);
      expect(chosenDate, isNotNull);
      expect(chosenDate!.day, earlierDate.day);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/history/presentation/widgets/horizontal_date_selector_test.dart`

Expected output: FAIL with errors indicating `date_chip.dart` and `horizontal_date_selector.dart` do not exist.

- [ ] **Step 3: Write minimal implementation**

Create `lib/src/features/history/presentation/widgets/date_chip.dart`:

```dart
import 'package:flutter/material.dart';

/// Single date chip representing one day in the horizontal history date selector.
/// Adheres to GiziLens minimalist health-tech design tokens:
/// - Active: Emerald `#047857`, white text.
/// - Inactive: Surface `#ffffff`, neutral border `#e2e8f0`, foreground `#0f172a`.
class DateChip extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  const DateChip({
    super.key,
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  static const List<String> _dayNames = [
    'Sen',
    'Sel',
    'Rab',
    'Kam',
    'Jum',
    'Sab',
    'Min',
  ];

  String _getDayName(int weekday) {
    if (weekday >= 1 && weekday <= 7) {
      return _dayNames[weekday - 1];
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFF047857);
    const borderColor = Color(0xFFE2E8F0);
    const foregroundColor = Color(0xFF0F172A);
    const mutedColor = Color(0xFF475569);

    final dayName = _getDayName(date.weekday);
    final dayNumber = date.day.toString();
    final semanticLabel = isToday
        ? 'Hari ini, $dayName $dayNumber'
        : '$dayName $dayNumber';

    return Semantics(
      button: true,
      selected: isSelected,
      label: semanticLabel,
      child: Material(
        color: isSelected ? accentColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 58,
            height: 74,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? accentColor : borderColor,
                width: isSelected ? 1.5 : 1.0,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dayName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white.withOpacity(0.9) : mutedColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dayNumber,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : foregroundColor,
                  ),
                ),
                if (isToday) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Hari ini',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : accentColor,
                    ),
                  ),
                ] else
                  const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

Create `lib/src/features/history/presentation/widgets/horizontal_date_selector.dart`:

```dart
import 'package:flutter/material.dart';
import 'date_chip.dart';

/// Horizontal scrollable date selector for GiziLens consumption history.
/// Allows rapid scanning across recent days with active highlighting and
/// a trailing calendar trigger button for date jumping.
class HorizontalDateSelector extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback? onCalendarTap;
  final DateTime? anchorDate;
  final int daysCount;

  const HorizontalDateSelector({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.onCalendarTap,
    this.anchorDate,
    this.daysCount = 14,
  });

  @override
  State<HorizontalDateSelector> createState() => _HorizontalDateSelectorState();
}

class _HorizontalDateSelectorState extends State<HorizontalDateSelector> {
  late final ScrollController _scrollController;
  late final List<DateTime> _dates;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _generateDates();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
  }

  @override
  void didUpdateWidget(covariant HorizontalDateSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate ||
        oldWidget.anchorDate != widget.anchorDate ||
        oldWidget.daysCount != widget.daysCount) {
      _generateDates();
      _scrollToSelectedDate();
    }
  }

  void _generateDates() {
    final anchor = widget.anchorDate ?? DateTime.now();
    final normalizedAnchor = DateTime(anchor.year, anchor.month, anchor.day);

    _dates = List.generate(widget.daysCount, (index) {
      final offset = (widget.daysCount - 1) - index;
      return normalizedAnchor.subtract(Duration(days: offset));
    });
  }

  void _scrollToSelectedDate() {
    if (!_scrollController.hasClients) return;

    final normalizedSelected = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
      widget.selectedDate.day,
    );

    final selectedIndex = _dates.indexWhere(
      (d) => d.year == normalizedSelected.year &&
          d.month == normalizedSelected.month &&
          d.day == normalizedSelected.day,
    );

    if (selectedIndex != -1) {
      // 58 chip width + 8 spacing = 66 px per item
      const itemExtent = 66.0;
      final targetOffset = (selectedIndex * itemExtent) - 70;
      final clampedOffset = targetOffset.clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      );

      _scrollController.animateTo(
        clampedOffset,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    const borderColor = Color(0xFFE2E8F0);
    const foregroundColor = Color(0xFF0F172A);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
              height: 78,
              child: ListView.separated(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _dates.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final date = _dates[index];
                  final isSelected = _isSameDay(date, widget.selectedDate);
                  final isToday = _isSameDay(date, now);

                  return DateChip(
                    date: date,
                    isSelected: isSelected,
                    isToday: isToday,
                    onTap: () => widget.onDateSelected(date),
                  );
                },
              ),
            ),
          ),
          Container(
            height: 48,
            width: 1,
            color: borderColor,
            margin: const EdgeInsets.symmetric(horizontal: 4),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 4),
            child: Semantics(
              button: true,
              label: 'Buka kalender riwayat',
              child: IconButton(
                onPressed: widget.onCalendarTap,
                tooltip: 'Pilih tanggal dari kalender',
                icon: const Icon(
                  Icons.calendar_month_outlined,
                  color: foregroundColor,
                  size: 24,
                ),
                style: IconButton.styleFrom(
                  minimumSize: const Size(44, 44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: borderColor),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run tests — expect PASS**

Run: `flutter test test/features/history/presentation/widgets/horizontal_date_selector_test.dart`

Expected: All tests PASS.

**If it doesn't pass:** re-check Step 3's code against this step's test expectations before touching any other file — do not proceed to Step 5 or the next Task.
**If it fails again:** STOP — read the systematic-debugging skill (.claude/skills/systematic-debugging/SKILL.md or .cursor/skills/systematic-debugging/SKILL.md) and find the ROOT CAUSE before changing any code. Do not weaken tests to make them pass.

- [ ] **Step 5: Commit**

```bash
git add lib/src/features/history/presentation/widgets/date_chip.dart lib/src/features/history/presentation/widgets/horizontal_date_selector.dart test/features/history/presentation/widgets/horizontal_date_selector_test.dart
git commit -m "feat(history): implement horizontal date selector strip and date chip"
```

| t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14, t15, t16 | Completed in previous slice |

## Self-Review

### Spec Coverage
- **Multi-Food Analysis Results & Ompreng Breakdown (PRD §1, §3.3; PRD Desain §15.7, §20):** Delivered in **Task 1** (`AnalysisResultScreen`, `FoodItemCard`, `DetectedFoodItem`) supporting multi-item ompreng tray recognition, independent portions, and aggregate macro summary.
- **Portion Adjustment & Stepper Interaction (PRD §2.4; PRD Desain §21):** Delivered in **Task 2** (`PortionEditSheet`) featuring unit selector, stepper increment/decrement, and computed nutrient preview updates.
- **Consumption Confirmation & Save Feedback (PRD §1, §2.4; PRD Desain §20.7, §23):** Delivered in **Task 3** (`ConsumptionConfirmationBar`, `SaveFeedbackToast`) with meal-time selector, double-tap submission lock, and recovery handling.
- **Analysis Failure & Fallback Handling (PRD §2.9; PRD Desain §19, §30.3):** Delivered in **Task 4** (`AnalysisFailureView`) providing clear recovery options ("Ambil Ulang" and "Pilih dari Galeri") without losing application state.
- **Deep Dynamic Nutrient Detail & Adequacy Status (PRD §1, §2.5–2.7; PRD Desain §22, §36):** Delivered in **Task 5** (`NutrientDetailScreen`, `NutrientProgressRow`) displaying macronutrient and micronutrient lists, sorting by attention status, and handling missing targets safely without false zero percentages.
- **Food Record Detail Breakdown (PRD Desain §25):** Delivered in **Task 6** (`FoodRecordDetailScreen`) providing media thumbnail, consumption timestamp, confirmed portions, and itemized micronutrient lists.
- **Horizontal Date Selector Strip (PRD Desain §24.2):** Delivered in **Task 7** (`HorizontalDateSelectorStrip`) allowing horizontal day scrubbing with relative date calculations and active date indicator.
- **Daily History Record Viewing (PRD §1; PRD Desain §24):** Delivered in **Task 8** (`HistoryScreen`) integrating the date strip with daily energy summaries and food record list views.
- **Onboarding & Splash Flow (PRD §3.1; PRD Desain §11, §13):** Covered in Slice 1.
- **Camera Capture, Ompreng Framing Guide & Preview (PRD §3.2; PRD Desain §17, §18):** Covered in Slice 2.
- **User Profile, Target Personalization & Account Settings (PRD §3.1; PRD Desain §14, §26):** Deferred to Slice 4.
- **Bottom Navigation Shell & App Routing Wiring (PRD Desain §5, §39):** Deferred to Slice 4.

### Work Map Coverage
- `t17` → **Task 1**: Multi-Food Result Screen Layout & Ompreng Breakdown Card
- `t18` → **Task 2**: Portion Modification Bottom Sheet & Stepper
- `t19` → **Task 3**: Consumption Confirmation Bar & Save Feedback
- `t20` → **Task 4**: Analysis Failure & Recovery View
- `t21` → **Task 5**: Dynamic Nutrient Detail Screen & Status Indicators
- `t22` → **Task 6**: Food Record Detail Screen
- `t23` → **Task 7**: Horizontal Date Selector Strip Component
- `t24` → **Task 8**: History Daily View Integration with Date Selector
- `t25` → Deferred to Slice 4 (Profile Screen & Nutrient Target Card)
- `t26` → Deferred to Slice 4 (Profile Setup & Edit Form)
- `t27` → Deferred to Slice 4 (App Shell / Bottom Navigation Tab Integration & End-to-End Review)

### Build Order & Dependency Sanity
- Build order is linear and executable top-to-bottom from Task 1 through Task 8.
- **Task 1** has no dependencies.
- **Task 2** depends only on **Task 1** (`DetectedFoodItem` model).
- **Task 3** depends only on **Task 1** (result screen integration).
- **Task 4** depends only on **Task 1** (analysis result screen state alternates).
- **Task 5** depends only on **Task 1** (data models for dynamic nutrients).
- **Task 6** depends only on **Task 1** (food card models and nutrient maps).
- **Task 7** has no dependencies (pure modular UI component).
- **Task 8** depends on **Task 6** and **Task 7** (combines history models, record navigation, and horizontal date strip).
- All dependencies are strictly acyclic and reference only prior tasks.

### Placeholder & Type Consistency Scan
- No placeholders (`TODO`, `TBD`, "later", or truncated code fences) exist across tasks.
- All code snippets and widget declarations are fully defined and syntactically balanced.
- Domain models (`DetectedFoodItem`, `PortionUnit`, `NutrientStatus`, `FoodRecordSummary`) maintain consistent field names, nullability constraints, and relative date calculation semantics.
- Relative date calculations strictly utilize `DateTime.now().subtract(...)` to avoid stale hardcoded date literals.

### Test Harness & Verification
- Single test runner: `flutter test` only throughout all tasks and scripts.
- Unit and widget tests test components in isolation without attempting runtime HTTP requests or `localhost` socket calls.
- Verification commands assert visual structure, semantics, and simulated interactions via `WidgetTester`.

### Slicing & README Notes
- This is **Slice 3 of 4**. Updating the target project's `README.md` is deferred to the final task of **Slice 4**, in compliance with the sliced implementation plan rules.
- **Spec ref:** `prd-gizilens.md & prd-desain-gizilens.md @ Draft v1.0 (2025-02-18)`.