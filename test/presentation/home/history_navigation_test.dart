import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizilens/features/history/presentation/screens/history_screen.dart';
import 'package:gizilens/presentation/home/home_screen.dart';

void main() {
  testWidgets('home history action opens the historical daily summary', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: const HomeScreen(userName: 'Budi'),
          routes: {'/history': (_) => const HistoryScreen()},
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Riwayat konsumsi'));
    await tester.pumpAndSettle();

    expect(find.text('Riwayat Konsumsi'), findsOneWidget);
    expect(find.text('Ringkasan Harian'), findsOneWidget);
    expect(find.text('Catatan Konsumsi (2)'), findsOneWidget);
  });
}
