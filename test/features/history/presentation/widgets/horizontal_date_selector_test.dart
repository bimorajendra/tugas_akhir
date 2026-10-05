import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizilens/features/history/presentation/widgets/date_chip.dart';
import 'package:gizilens/features/history/presentation/widgets/horizontal_date_selector.dart';

void main() {
  testWidgets('date chip shows its date and responds to tap', (tester) async {
    final date = DateTime.now().subtract(const Duration(days: 2));
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DateChip(
            date: date,
            isSelected: false,
            isToday: false,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('${date.day}'), findsOneWidget);
    await tester.tap(find.byType(DateChip));
    expect(tapped, isTrue);
  });

  testWidgets(
    'selected today uses the emerald surface and exposes today copy',
    (tester) async {
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

      final material = tester.widget<Material>(
        find
            .descendant(
              of: find.byType(DateChip),
              matching: find.byType(Material),
            )
            .first,
      );
      expect(material.color, const Color(0xFF047857));
      expect(find.text('Hari ini'), findsOneWidget);
    },
  );

  testWidgets(
    'selector highlights selection and reports date and calendar actions',
    (tester) async {
      final today = DateTime.now();
      final selected = DateTime(today.year, today.month, today.day);
      DateTime? chosenDate;
      var openedCalendar = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HorizontalDateSelector(
              selectedDate: selected,
              anchorDate: selected,
              daysCount: 7,
              onDateSelected: (date) => chosenDate = date,
              onCalendarTap: () => openedCalendar = true,
            ),
          ),
        ),
      );

      expect(find.byType(DateChip), findsNWidgets(7));
      await tester.tap(find.byTooltip('Pilih tanggal dari kalender'));
      expect(openedCalendar, isTrue);

      final earlier = selected.subtract(const Duration(days: 3));
      final earlierChip = find.descendant(
        of: find.byType(DateChip),
        matching: find.text('${earlier.day}'),
      );
      await tester.tap(earlierChip);
      expect(chosenDate, earlier);
    },
  );
}
