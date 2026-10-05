import 'package:flutter/material.dart';
import 'package:gizilens/core/theme/app_colors.dart';
import 'package:gizilens/core/theme/app_spacing.dart';

Future<DateTime?> showHistoryCalendarPicker(
  BuildContext context, {
  required DateTime initialDate,
}) {
  final today = DateTime.now();
  final lastDate = DateTime(today.year, today.month, today.day);
  final firstDate = lastDate.subtract(const Duration(days: 3650));
  final normalized = DateTime(
    initialDate.year,
    initialDate.month,
    initialDate.day,
  );
  final safeInitial = normalized.isAfter(lastDate)
      ? lastDate
      : normalized.isBefore(firstDate)
      ? firstDate
      : normalized;

  return showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => CalendarPickerSheet(
      initialDate: safeInitial,
      firstDate: firstDate,
      lastDate: lastDate,
    ),
  );
}

class CalendarPickerSheet extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const CalendarPickerSheet({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  State<CalendarPickerSheet> createState() => _CalendarPickerSheetState();
}

class _CalendarPickerSheetState extends State<CalendarPickerSheet> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xs,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Pilih tanggal',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.foreground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Tutup kalender',
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
        ),
        CalendarDatePicker(
          initialDate: _selectedDate,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          onDateChanged: (date) => setState(
            () => _selectedDate = DateTime(date.year, date.month, date.day),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.xs,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Batal'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(_selectedDate),
                  child: const Text('Terapkan tanggal'),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
