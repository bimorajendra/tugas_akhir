import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizilens/features/analysis/presentation/screens/analysis_result_screen.dart';
import 'package:gizilens/features/analysis/presentation/widgets/save_failure_dialog.dart';
import 'package:gizilens/features/analysis/presentation/widgets/save_feedback_toast.dart';

void main() {
  const food = DetectedFoodItem(
    id: 'food-1',
    name: 'Nasi Putih',
    portion: 150,
    portionUnit: 'gram',
    calories: 195,
    protein: 4.1,
    carbs: 43.2,
    fat: 0.4,
  );

  testWidgets('success feedback displays a lightweight toast', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showSaveSuccessToast(context),
              child: const Text('Tampilkan'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Tampilkan'));
    await tester.pump();

    expect(find.text('Konsumsi berhasil disimpan'), findsOneWidget);
    expect(find.text('Ringkasan harian telah diperbarui.'), findsOneWidget);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
  });

  testWidgets('failure dialog retries or dismisses without losing context', (
    tester,
  ) async {
    var retried = false;
    var dismissed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showDialog<void>(
                context: context,
                builder: (_) => SaveFailureDialog(
                  onRetry: () => retried = true,
                  onDismiss: () => dismissed = true,
                ),
              ),
              child: const Text('Buka'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Buka'));
    await tester.pumpAndSettle();

    expect(find.text('Konsumsi belum tersimpan'), findsOneWidget);
    expect(
      find.text('Hasil analisismu masih tersedia. Coba simpan kembali.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Simpan Lagi'));
    await tester.pumpAndSettle();
    expect(retried, isTrue);
    expect(dismissed, isFalse);
  });

  testWidgets('save failure keeps detected food visible and can be dismissed', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AnalysisResultScreen(
          items: const [food],
          onSaveRecord: (_) async => false,
        ),
      ),
    );

    await tester.tap(find.text('Simpan Konsumsi'));
    await tester.pumpAndSettle();
    expect(find.text('Konsumsi belum tersimpan'), findsOneWidget);
    await tester.tap(find.text('Nanti'));
    await tester.pumpAndSettle();
    expect(find.text('Nasi Putih'), findsOneWidget);
  });

  testWidgets('save success shows toast and invokes callback', (tester) async {
    var successCalled = false;
    await tester.pumpWidget(
      MaterialApp(
        home: AnalysisResultScreen(
          items: const [food],
          onSaveRecord: (_) async => true,
          onSaveSuccess: () => successCalled = true,
        ),
      ),
    );

    await tester.tap(find.text('Simpan Konsumsi'));
    await tester.pump();
    expect(find.text('Konsumsi berhasil disimpan'), findsOneWidget);
    expect(successCalled, isTrue);
  });

  testWidgets('save exceptions use generic recoverable copy', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AnalysisResultScreen(
          items: const [food],
          onSaveRecord: (_) async =>
              throw StateError('private internal detail'),
        ),
      ),
    );

    await tester.tap(find.text('Simpan Konsumsi'));
    await tester.pumpAndSettle();
    expect(find.text('Konsumsi belum tersimpan'), findsOneWidget);
    expect(find.textContaining('private internal detail'), findsNothing);
  });
}
