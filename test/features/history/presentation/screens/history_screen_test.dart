import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizilens/features/history/presentation/screens/history_screen.dart';
import 'package:gizilens/features/history/presentation/widgets/calendar_picker_sheet.dart';
import 'package:gizilens/features/history/presentation/widgets/global_error_view.dart';
import 'package:gizilens/features/history/presentation/widgets/date_chip.dart';

void main() {
  testWidgets('shows daily totals and opens a selected food record detail', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const HistoryScreen(),
        routes: {
          '/history/record-detail': (_) => const _RecordDetailDestination(),
        },
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Riwayat Konsumsi'), findsOneWidget);
    expect(find.text('Ringkasan Harian'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('history-record-record-lunch')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('history-record-record-evening')),
      findsOneWidget,
    );
    expect(find.text('Makan Siang Ompreng'), findsOneWidget);

    await tester.ensureVisible(find.text('Makan Siang Ompreng'));
    await tester.tap(find.text('Makan Siang Ompreng'));
    await tester.pumpAndSettle();
    expect(find.text('Detail Record Terbuka'), findsOneWidget);
  });

  testWidgets(
    'selecting yesterday updates the visible record set and summary',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HistoryScreen()));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('history-record-record-lunch')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('history-record-record-evening')),
        findsOneWidget,
      );

      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final dateChipText = find.descendant(
        of: find.byType(DateChip),
        matching: find.text('${yesterday.day}'),
      );
      await tester.ensureVisible(dateChipText);
      await tester.tap(dateChipText);
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('history-record-record-yesterday')),
        findsOneWidget,
      );
      expect(find.text('Makan Siang'), findsOneWidget);
      expect(find.text('522 / 2100 kkal'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(DateChip),
          matching: find.text('${DateTime.now().day}'),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('calendar selection jumps to a date with an empty-state view', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HistoryScreen()));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Pilih tanggal dari kalender'));
    await tester.pumpAndSettle();
    expect(find.byType(CalendarPickerSheet), findsOneWidget);

    final chosenDate = DateTime.now().subtract(const Duration(days: 30));
    tester
        .widget<CalendarDatePicker>(find.byType(CalendarDatePicker))
        .onDateChanged(chosenDate);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Terapkan tanggal'));
    await tester.pumpAndSettle();

    expect(find.text('Belum ada konsumsi pada tanggal ini'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('history-record-record-yesterday')),
      findsNothing,
    );
  });

  testWidgets(
    'offline error uses safe copy and retry returns to the history content',
    (tester) async {
      var retryCalled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: HistoryScreen(
            errorType: HistoryErrorType.offline,
            onRetry: () => retryCalled = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Tidak ada koneksi internet'), findsOneWidget);
      expect(find.textContaining('SocketException'), findsNothing);
      await tester.tap(find.text('Coba lagi'));
      await tester.pumpAndSettle();
      expect(retryCalled, isTrue);
      expect(find.text('Riwayat Makanan'), findsOneWidget);
    },
  );

  testWidgets(
    'history layout adapts to a small phone, landscape, and larger text',
    (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(1.4)),
              child: const HistoryScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      tester.view.physicalSize = const Size(812, 375);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );
}

class _RecordDetailDestination extends StatelessWidget {
  const _RecordDetailDestination();

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Detail Record Terbuka')));
}
