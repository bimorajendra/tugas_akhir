import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizilens/features/analysis/presentation/widgets/consumption_confirmation_bar.dart';

void main() {
  group('ConsumptionConfirmationBar', () {
    testWidgets('shows the selected time and primary save action', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: ConsumptionConfirmationBar(
              initialDateTime: DateTime(2025, 2, 18, 12, 30),
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

    testWidgets('opens the time picker and reports the changed timestamp', (
      tester,
    ) async {
      DateTime? selected;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: ConsumptionConfirmationBar(
              initialDateTime: DateTime(2025, 2, 18, 12, 30),
              onDateTimeChanged: (value) => selected = value,
              onConfirmSave: () async {},
            ),
          ),
        ),
      );

      await tester.tap(
        find.byKey(const Key('consumption_timestamp_picker_button')),
      );
      await tester.pumpAndSettle();
      expect(find.byType(TimePickerDialog), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(selected, isNotNull);
      expect(selected!.year, 2025);
      expect(selected!.month, 2);
      expect(selected!.day, 18);
    });

    testWidgets('locks rapid repeated submissions until save completes', (
      tester,
    ) async {
      var calls = 0;
      final completer = Completer<void>();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: ConsumptionConfirmationBar(
              initialDateTime: DateTime.now(),
              onDateTimeChanged: (_) {},
              onConfirmSave: () async {
                calls++;
                await completer.future;
              },
            ),
          ),
        ),
      );

      final saveButton = find.byKey(
        const Key('confirm_save_consumption_button'),
      );
      await tester.tap(saveButton);
      await tester.pump();
      await tester.tap(saveButton);
      await tester.pump();

      expect(calls, 1);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete();
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Simpan Konsumsi'), findsOneWidget);
    });
  });
}
