import 'package:flutter/material.dart';
import 'package:gizilens/core/theme/app_colors.dart';
import 'package:gizilens/core/theme/app_spacing.dart';
import 'date_chip.dart';

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
  }) : assert(daysCount > 0);

  @override
  State<HorizontalDateSelector> createState() => _HorizontalDateSelectorState();
}

class _HorizontalDateSelectorState extends State<HorizontalDateSelector> {
  late final ScrollController _controller;
  late List<DateTime> _dates;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _generateDates();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
  }

  @override
  void didUpdateWidget(covariant HorizontalDateSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate ||
        oldWidget.anchorDate != widget.anchorDate ||
        oldWidget.daysCount != widget.daysCount) {
      _generateDates();
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
    }
  }

  void _generateDates() {
    final anchor = widget.anchorDate ?? DateTime.now();
    final day = DateTime(anchor.year, anchor.month, anchor.day);
    _dates = List.generate(
      widget.daysCount,
      (index) => day.subtract(Duration(days: widget.daysCount - 1 - index)),
    );
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  void _scrollToSelected() {
    if (!_controller.hasClients) return;
    final index = _dates.indexWhere(
      (date) => _sameDay(date, widget.selectedDate),
    );
    if (index < 0) return;
    const itemExtent = 68.0;
    final offset = (index * itemExtent - 68)
        .clamp(0.0, _controller.position.maxScrollExtent)
        .toDouble();
    _controller.animateTo(
      offset,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: SizedBox(
          height: 90 * MediaQuery.textScalerOf(context).scale(1),
          child: ListView.separated(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            itemCount: _dates.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final date = _dates[index];
              return DateChip(
                date: date,
                isSelected: _sameDay(date, widget.selectedDate),
                isToday: _sameDay(date, DateTime.now()),
                onTap: () => widget.onDateSelected(date),
              );
            },
          ),
        ),
      ),
      const SizedBox(width: AppSpacing.xs),
      Container(width: 1, height: 48, color: AppColors.border),
      const SizedBox(width: AppSpacing.xs),
      IconButton(
        onPressed: widget.onCalendarTap,
        tooltip: 'Pilih tanggal dari kalender',
        icon: const Icon(
          Icons.calendar_month_outlined,
          color: AppColors.foreground,
        ),
        style: IconButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.roundedMd,
            side: const BorderSide(color: AppColors.border),
          ),
        ),
      ),
    ],
  );
}
