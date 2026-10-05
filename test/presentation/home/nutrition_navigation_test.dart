import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizilens/features/nutrition_detail/presentation/screens/nutrition_detail_screen.dart';
import 'package:gizilens/presentation/home/home_screen.dart';

void main() {
  testWidgets(
    'nutrition feedback detail action opens the nutrient detail page',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: const HomeScreen(userName: 'Budi'),
            routes: {'/nutrition/detail': (_) => const NutritionDetailScreen()},
          ),
        ),
      );
      await tester.pumpAndSettle();

      final detailButton = find.text('Lihat detail');
      await tester.ensureVisible(detailButton);
      await tester.tap(detailButton);
      await tester.pumpAndSettle();

      expect(find.text('Detail Nutrisi'), findsOneWidget);
      expect(find.text('Natrium'), findsOneWidget);
    },
  );
}
