import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gizilens/core/theme/app_colors.dart';
import 'package:gizilens/core/theme/app_spacing.dart';
import 'package:gizilens/features/analysis/presentation/widgets/analysis_failure_view.dart';
import 'package:gizilens/features/analysis/presentation/widgets/consumption_confirmation_bar.dart';
import 'package:gizilens/features/analysis/presentation/widgets/food_item_card.dart';
import 'package:gizilens/features/analysis/presentation/widgets/portion_edit_sheet.dart';
import 'package:gizilens/features/analysis/presentation/widgets/save_failure_dialog.dart';
import 'package:gizilens/features/analysis/presentation/widgets/save_feedback_toast.dart';

export 'package:gizilens/features/analysis/presentation/widgets/food_item_card.dart'
    show DetectedFoodItem, FoodItemCard;

class AnalysisResultScreen extends StatefulWidget {
  const AnalysisResultScreen({
    super.key,
    required this.items,
    this.compartmentCount = 3,
    this.onEditPortion,
    this.onRetake,
    this.onPickGallery,
    this.isFailure = false,
    this.onSaveRecord,
    this.onSaveSuccess,
  });

  final List<DetectedFoodItem> items;
  final int compartmentCount;
  final ValueChanged<DetectedFoodItem>? onEditPortion;
  final VoidCallback? onRetake;
  final VoidCallback? onPickGallery;
  final bool isFailure;
  final Future<bool> Function(DateTime consumptionTime)? onSaveRecord;
  final VoidCallback? onSaveSuccess;

  @override
  State<AnalysisResultScreen> createState() => _AnalysisResultScreenState();
}

class _AnalysisResultScreenState extends State<AnalysisResultScreen> {
  late List<DetectedFoodItem> _items;
  late DateTime _consumptionTime;

  @override
  void initState() {
    super.initState();
    _items = List<DetectedFoodItem>.of(widget.items);
    _consumptionTime = DateTime.now();
  }

  @override
  void didUpdateWidget(covariant AnalysisResultScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.items, widget.items)) {
      _items = List<DetectedFoodItem>.of(widget.items);
    }
  }

  Future<void> _editPortion(DetectedFoodItem item) async {
    final updated = await PortionEditSheet.show(context, foodItem: item);
    if (updated == null || !mounted) return;

    final index = _items.indexWhere((candidate) => candidate.id == updated.id);
    if (index < 0) return;
    setState(() => _items[index] = updated);
    widget.onEditPortion?.call(updated);
  }

  Future<void> _saveConsumption() async {
    var succeeded = true;
    try {
      final handler = widget.onSaveRecord;
      if (handler != null) succeeded = await handler(_consumptionTime);
    } catch (_) {
      // Keep internal error details out of the user-facing recovery flow.
      succeeded = false;
    }

    if (!mounted) return;
    if (succeeded) {
      showSaveSuccessToast(context);
      widget.onSaveSuccess?.call();
      return;
    }

    unawaited(
      showDialog<void>(
        context: context,
        builder: (context) => SaveFailureDialog(onRetry: _saveConsumption),
      ),
    );
  }

  void _updateConsumptionTime(DateTime value) {
    setState(() => _consumptionTime = value);
  }

  int get _totalCalories =>
      _items.fold(0, (total, item) => total + item.calories);
  double get _totalProtein =>
      _items.fold(0, (total, item) => total + item.protein);
  double get _totalCarbs => _items.fold(0, (total, item) => total + item.carbs);
  double get _totalFat => _items.fold(0, (total, item) => total + item.fat);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final failed = widget.isFailure || _items.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Hasil Analisis'),
        backgroundColor: AppColors.surface,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.border),
        ),
      ),
      body: failed
          ? AnalysisFailureView(
              onRetake: widget.onRetake,
              onPickGallery: widget.onPickGallery,
            )
          : SafeArea(
              top: false,
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Periksa kembali sebelum menyimpan.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.mutedForeground,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            constraints: const BoxConstraints(minHeight: 36),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFA7F3D0),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.dashboard_outlined,
                                  size: 18,
                                  color: AppColors.accent,
                                ),
                                const SizedBox(width: AppSpacing.xs),
                                Flexible(
                                  child: Text(
                                    'Ompreng: ${widget.compartmentCount} Kompartemen',
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(color: AppColors.accent),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _NutritionSummary(
                          calories: _totalCalories,
                          protein: _totalProtein,
                          carbs: _totalCarbs,
                          fat: _totalFat,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Makanan Terdeteksi',
                                style: theme.textTheme.titleMedium,
                              ),
                            ),
                            Text(
                              '${_items.length} item',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        ..._items.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.sm,
                            ),
                            child: FoodItemCard(
                              item: item,
                              onEditPortion: (_) => _editPortion(item),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      bottomNavigationBar: failed
          ? null
          : ConsumptionConfirmationBar(
              initialDateTime: _consumptionTime,
              onDateTimeChanged: _updateConsumptionTime,
              onConfirmSave: _saveConsumption,
            ),
    );
  }
}

class _NutritionSummary extends StatelessWidget {
  const _NutritionSummary({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  final int calories;
  final double protein;
  final double carbs;
  final double fat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Energi',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.mutedForeground,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '$calories kkal',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _NutrientTotal(label: 'Protein', value: protein),
                ),
                Expanded(
                  child: _NutrientTotal(label: 'Karbohidrat', value: carbs),
                ),
                Expanded(
                  child: _NutrientTotal(label: 'Lemak', value: fat),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NutrientTotal extends StatelessWidget {
  const _NutrientTotal({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${value.toStringAsFixed(1)} g',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}
