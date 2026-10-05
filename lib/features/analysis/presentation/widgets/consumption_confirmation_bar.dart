import 'package:flutter/material.dart';
import 'package:gizilens/core/theme/app_colors.dart';
import 'package:gizilens/core/theme/app_spacing.dart';

class ConsumptionConfirmationBar extends StatefulWidget {
  const ConsumptionConfirmationBar({
    super.key,
    required this.initialDateTime,
    required this.onDateTimeChanged,
    required this.onConfirmSave,
    this.isSubmitting = false,
  });

  final DateTime initialDateTime;
  final ValueChanged<DateTime> onDateTimeChanged;
  final Future<void> Function() onConfirmSave;
  final bool isSubmitting;

  @override
  State<ConsumptionConfirmationBar> createState() =>
      _ConsumptionConfirmationBarState();
}

class _ConsumptionConfirmationBarState
    extends State<ConsumptionConfirmationBar> {
  late DateTime _selectedDateTime;
  bool _internalLock = false;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.initialDateTime;
  }

  @override
  void didUpdateWidget(covariant ConsumptionConfirmationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialDateTime != widget.initialDateTime) {
      _selectedDateTime = widget.initialDateTime;
    }
  }

  String _formatTime(DateTime value) =>
      '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')} WIB';

  Future<void> _pickTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(
            context,
          ).colorScheme.copyWith(primary: AppColors.accent),
        ),
        child: child ?? const SizedBox.shrink(),
      ),
    );
    if (selected == null || !mounted) return;

    final updated = DateTime(
      _selectedDateTime.year,
      _selectedDateTime.month,
      _selectedDateTime.day,
      selected.hour,
      selected.minute,
    );
    setState(() => _selectedDateTime = updated);
    widget.onDateTimeChanged(updated);
  }

  Future<void> _save() async {
    if (_internalLock || widget.isSubmitting) return;
    setState(() => _internalLock = true);
    try {
      await widget.onConfirmSave();
    } finally {
      if (mounted) setState(() => _internalLock = false);
    }
  }

  Widget _timeChip(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: AppColors.muted,
      borderRadius: AppRadius.roundedSm,
      border: Border.all(color: AppColors.border),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _formatTime(_selectedDateTime),
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(width: AppSpacing.xs),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: AppColors.mutedForeground,
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final busy = _internalLock || widget.isSubmitting;
    return SafeArea(
      top: false,
      child: Material(
        color: AppColors.surface,
        child: Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                key: const Key('consumption_timestamp_picker_button'),
                onTap: busy ? null : _pickTime,
                borderRadius: AppRadius.roundedMd,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final scaledFont = MediaQuery.textScalerOf(
                      context,
                    ).scale(13);
                    final compact =
                        constraints.maxWidth < 360 || scaledFont > 17;
                    final label = Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 18,
                          color: AppColors.mutedForeground,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            'Waktu Konsumsi',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.mutedForeground),
                          ),
                        ),
                      ],
                    );

                    return ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 48),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                          vertical: AppSpacing.xs,
                        ),
                        child: compact
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  label,
                                  const SizedBox(height: AppSpacing.xs),
                                  Align(
                                    alignment: AlignmentDirectional.centerEnd,
                                    child: _timeChip(context),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  const Icon(
                                    Icons.access_time_rounded,
                                    size: 18,
                                    color: AppColors.mutedForeground,
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Text(
                                    'Waktu Konsumsi',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.mutedForeground,
                                        ),
                                  ),
                                  const Spacer(),
                                  _timeChip(context),
                                ],
                              ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  key: const Key('confirm_save_consumption_button'),
                  onPressed: busy ? null : _save,
                  child: busy
                      ? const SizedBox.square(
                          dimension: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.onAccent,
                          ),
                        )
                      : const Text('Simpan Konsumsi'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
