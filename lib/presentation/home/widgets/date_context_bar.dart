import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gizilens/core/theme/app_colors.dart';
import 'package:gizilens/core/theme/app_spacing.dart';
import 'package:gizilens/core/theme/app_typography.dart';
import 'package:gizilens/presentation/home/providers/selected_date_provider.dart';

class DateContextBar extends ConsumerWidget {
  const DateContextBar({super.key});
  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
  static const _days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
    final month = _months[date.month - 1];
    return isToday ? 'Hari ini, ${date.day} $month' : '${_days[date.weekday - 1]}, ${date.day} $month';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedDateProvider);
    final now = DateTime.now();
    final isToday = selected.year == now.year && selected.month == now.month && selected.day == now.day;
    final notifier = ref.read(selectedDateProvider.notifier);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppRadius.roundedFull, border: Border.all(color: AppColors.border)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        IconButton(key: const Key('date_bar_prev_button'), tooltip: 'Hari sebelumnya', icon: const Icon(Icons.chevron_left_rounded, size: 20), color: AppColors.foreground, padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 36, minHeight: 36), onPressed: notifier.previousDay),
        InkWell(onTap: isToday ? null : notifier.resetToToday, borderRadius: AppRadius.roundedFull, child: Padding(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs), child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (isToday) ...[const DecoratedBox(decoration: BoxDecoration(color: AppColors.accent, shape: BoxShape.circle), child: SizedBox(width: 8, height: 8)), const SizedBox(width: AppSpacing.xs)],
          Text(_formatDate(selected), style: AppTypography.bodySm.copyWith(color: AppColors.foreground, fontWeight: FontWeight.w600)),
        ]))),
        IconButton(key: const Key('date_bar_next_button'), tooltip: 'Hari berikutnya', icon: const Icon(Icons.chevron_right_rounded, size: 20), color: AppColors.foreground, padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 36, minHeight: 36), onPressed: notifier.nextDay),
      ]),
    );
  }
}
