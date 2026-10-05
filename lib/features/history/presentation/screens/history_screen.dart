import 'package:flutter/material.dart';
import 'package:gizilens/core/theme/app_colors.dart';
import 'package:gizilens/core/theme/app_spacing.dart';
import 'package:gizilens/features/history/data/mock_history_records.dart';
import 'package:gizilens/features/history/presentation/screens/food_record_detail_screen.dart';
import 'package:gizilens/features/history/presentation/widgets/calendar_picker_sheet.dart';
import 'package:gizilens/features/history/presentation/widgets/global_error_view.dart';
import 'package:gizilens/features/history/presentation/widgets/horizontal_date_selector.dart';

class HistoryScreen extends StatefulWidget {
  final DateTime? initialDate;
  final HistoryErrorType? errorType;
  final VoidCallback? onRetry;

  const HistoryScreen({
    super.key,
    this.initialDate,
    this.errorType,
    this.onRetry,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late DateTime _selectedDate;
  late HistoryErrorType? _errorType;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialDate ?? DateTime.now();
    _selectedDate = DateTime(initial.year, initial.month, initial.day);
    _errorType = widget.errorType;
  }

  void _selectDate(DateTime date) =>
      setState(() => _selectedDate = DateTime(date.year, date.month, date.day));

  Future<void> _openCalendar() async {
    final selected = await showHistoryCalendarPicker(
      context,
      initialDate: _selectedDate,
    );
    if (selected != null && mounted) {
      _selectDate(selected);
    }
  }

  void _retry() {
    widget.onRetry?.call();
    setState(() => _errorType = null);
  }

  @override
  Widget build(BuildContext context) {
    final records = sampleHistoryRecordsFor(_selectedDate);
    final today = DateTime.now();
    final isToday = _sameDay(_selectedDate, today);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Riwayat Konsumsi'),
        leading: const BackButton(),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.border),
        ),
      ),
      body: SafeArea(
        child: _errorType != null
            ? GlobalErrorView(type: _errorType!, onRetry: _retry)
            : Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenHorizontal,
                      AppSpacing.md,
                      AppSpacing.screenHorizontal,
                      AppSpacing.xl,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HorizontalDateSelector(
                          selectedDate: _selectedDate,
                          anchorDate:
                              _selectedDate.isBefore(
                                today.subtract(const Duration(days: 13)),
                              )
                              ? _selectedDate
                              : today,
                          daysCount: 14,
                          onDateSelected: _selectDate,
                          onCalendarTap: _openCalendar,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          'Riwayat Makanan',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: AppColors.foreground,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          _dateLabel(_selectedDate, isToday),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.mutedForeground),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        if (records.isEmpty)
                          _HistoryEmptyView(
                            onTodayTap: () => _selectDate(DateTime.now()),
                          )
                        else ...[
                          _HistorySummaryCard(records: records),
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            'Catatan Konsumsi (${records.length})',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: AppColors.foreground,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          for (final record in records) ...[
                            _HistoryRecordCard(
                              record: record,
                              onTap: () => Navigator.of(context).pushNamed(
                                '/history/record-detail',
                                arguments: record,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _dateLabel(DateTime date, bool today) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    const weekdays = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    if (today) {
      return 'Hari ini, ${date.day} ${months[date.month - 1]} ${date.year}';
    }
    return '${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class _HistorySummaryCard extends StatelessWidget {
  final List<FoodRecordDetailData> records;

  const _HistorySummaryCard({required this.records});

  @override
  Widget build(BuildContext context) {
    const targetCalories = 2100.0;
    final calories = records.fold<double>(
      0,
      (total, record) => total + record.totalCalories,
    );
    final protein = records.fold<double>(
      0,
      (total, record) => total + record.totalProtein,
    );
    final carbs = records.fold<double>(
      0,
      (total, record) => total + record.totalCarbs,
    );
    final fat = records.fold<double>(
      0,
      (total, record) => total + record.totalFat,
    );
    final fraction = (calories / targetCalories).clamp(0.0, 1.0).toDouble();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.roundedLg,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ringkasan Harian',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: [
              Text(
                'Energi tercatat',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.mutedForeground,
                ),
              ),
              Text(
                '${calories.round()} / ${targetCalories.round()} kkal',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Semantics(
            label:
                'Energi tercatat ${(fraction * 100).round()} persen dari target',
            child: ClipRRect(
              borderRadius: AppRadius.roundedFull,
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 8,
                backgroundColor: AppColors.muted,
                valueColor: const AlwaysStoppedAnimation(AppColors.accent),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _MacroSummary(label: 'Protein', value: protein),
              ),
              Expanded(
                child: _MacroSummary(label: 'Karbohidrat', value: carbs),
              ),
              Expanded(
                child: _MacroSummary(label: 'Lemak', value: fat),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroSummary extends StatelessWidget {
  final String label;
  final double value;
  const _MacroSummary({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        maxLines: 2,
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(color: AppColors.mutedForeground),
      ),
      const SizedBox(height: AppSpacing.xs),
      Text(
        '${value.toStringAsFixed(1)} g',
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: AppColors.foreground,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}

class _HistoryEmptyView extends StatelessWidget {
  final VoidCallback onTodayTap;
  const _HistoryEmptyView({required this.onTodayTap});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    margin: const EdgeInsets.only(top: AppSpacing.sm),
    padding: const EdgeInsets.all(AppSpacing.lg),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: AppRadius.roundedLg,
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      children: [
        const Icon(
          Icons.restaurant_outlined,
          size: 34,
          color: AppColors.mutedForeground,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Belum ada konsumsi pada tanggal ini',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppColors.foreground,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Catatan makanan untuk hari ini akan muncul di sini.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.mutedForeground,
            height: 1.45,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton.icon(
          onPressed: onTodayTap,
          icon: const Icon(Icons.today_outlined),
          label: const Text('Kembali ke hari ini'),
        ),
      ],
    ),
  );
}

class _HistoryRecordCard extends StatelessWidget {
  final FoodRecordDetailData record;
  final VoidCallback onTap;

  const _HistoryRecordCard({required this.record, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final portion = record.items.fold<double>(
      0,
      (total, item) => total + item.portionAmount,
    );
    final hour = record.consumedAt.hour.toString().padLeft(2, '0');
    final minute = record.consumedAt.minute.toString().padLeft(2, '0');

    return Semantics(
      key: ValueKey('history-record-${record.id}'),
      container: true,
      excludeSemantics: true,
      button: true,
      label:
          'Buka detail konsumsi ${record.mealTitle}, ${record.totalCalories.round()} kkal',
      child: Material(
        color: AppColors.surface,
        borderRadius: AppRadius.roundedLg,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.roundedLg,
          child: Container(
            constraints: const BoxConstraints(minHeight: 72),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: AppRadius.roundedLg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _HistoryRecordThumbnail(url: record.mediaUrl),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        record.mealTitle,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.foreground,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      '$hour:$minute',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                    ),
                    const Text(
                      '•',
                      style: TextStyle(color: AppColors.mutedForeground),
                    ),
                    Text(
                      '${portion.round()} g',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                    ),
                    const Text(
                      '•',
                      style: TextStyle(color: AppColors.mutedForeground),
                    ),
                    Text(
                      '${record.totalCalories.round()} kkal',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HistoryRecordThumbnail extends StatelessWidget {
  final String? url;

  const _HistoryRecordThumbnail({this.url});

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: AppColors.muted,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.restaurant_outlined,
        color: AppColors.accent,
        size: 22,
      ),
    );
    if (url == null || url!.trim().isEmpty) return fallback;
    return ClipOval(
      child: Image.network(
        url!,
        width: 44,
        height: 44,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback,
      ),
    );
  }
}
