import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gizilens/core/theme/app_colors.dart';
import 'package:gizilens/core/theme/app_spacing.dart';
import 'package:gizilens/features/analysis/presentation/widgets/food_item_card.dart';

class PortionEditSheet extends StatefulWidget {
  const PortionEditSheet({
    super.key,
    required this.foodItem,
    this.onPortionUpdated,
  });

  final DetectedFoodItem foodItem;
  final ValueChanged<DetectedFoodItem>? onPortionUpdated;

  static Future<DetectedFoodItem?> show(
    BuildContext context, {
    required DetectedFoodItem foodItem,
  }) {
    return showModalBottomSheet<DetectedFoodItem>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PortionEditSheet(foodItem: foodItem),
    );
  }

  @override
  State<PortionEditSheet> createState() => _PortionEditSheetState();
}

class _PortionEditSheetState extends State<PortionEditSheet> {
  static const _units = <String>['gram', 'porsi', 'sdm', 'potong', 'mangkuk'];

  late final TextEditingController _portionController;
  late double _portion;
  late String _unit;
  String? _inputError;

  @override
  void initState() {
    super.initState();
    _portion = widget.foodItem.portion > 0 ? widget.foodItem.portion : 100;
    _unit = _units.contains(widget.foodItem.portionUnit)
        ? widget.foodItem.portionUnit
        : _units.first;
    _portionController = TextEditingController(text: _format(_portion));
  }

  @override
  void dispose() {
    _portionController.dispose();
    super.dispose();
  }

  String _format(double value) => value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(1);

  double get _step => switch (_unit) {
    'gram' => 10,
    'porsi' || 'potong' || 'mangkuk' => 0.5,
    'sdm' => 1,
    _ => 1,
  };

  double get _ratio {
    final initialPortion = widget.foodItem.portion > 0
        ? widget.foodItem.portion
        : 100;
    return _portion / initialPortion;
  }

  int get _calories => (widget.foodItem.calories * _ratio).round();
  double get _protein => widget.foodItem.protein * _ratio;
  double get _carbs => widget.foodItem.carbs * _ratio;
  double get _fat => widget.foodItem.fat * _ratio;

  void _setPortion(double value) {
    if (!value.isFinite || value <= 0) return;
    final normalized = double.parse(value.toStringAsFixed(1));
    setState(() {
      _portion = normalized;
      _inputError = null;
      _portionController.value = TextEditingValue(
        text: _format(normalized),
        selection: TextSelection.collapsed(offset: _format(normalized).length),
      );
    });
  }

  void _onTextChanged(String value) {
    final parsed = double.tryParse(value.replaceAll(',', '.'));
    setState(() {
      if (parsed == null || !parsed.isFinite || parsed <= 0) {
        _inputError = 'Masukkan porsi lebih dari 0.';
      } else {
        _portion = parsed;
        _inputError = null;
      }
    });
  }

  DetectedFoodItem _updatedItem() => widget.foodItem.copyWith(
    portion: _portion,
    portionUnit: _unit,
    calories: _calories,
    protein: double.parse(_protein.toStringAsFixed(1)),
    carbs: double.parse(_carbs.toStringAsFixed(1)),
    fat: double.parse(_fat.toStringAsFixed(1)),
  );

  void _save() {
    if (_inputError != null || _portion <= 0) return;
    final updated = _updatedItem();
    widget.onPortionUpdated?.call(updated);
    if (Navigator.of(context).canPop()) Navigator.of(context).pop(updated);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 560,
          maxHeight: MediaQuery.sizeOf(context).height * 0.9,
        ),
        child: Material(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
          clipBehavior: Clip.antiAlias,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.lg + bottomInset,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ubah Porsi', style: theme.textTheme.titleLarge),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            widget.foodItem.name,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Tutup',
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Semantics(
                        label: 'Jumlah porsi',
                        child: TextField(
                          key: const Key('portion_text_field'),
                          controller: _portionController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            TextInputFormatter.withFunction((oldValue, value) {
                              return RegExp(
                                    r'^\d*[.,]?\d*$',
                                  ).hasMatch(value.text)
                                  ? value
                                  : oldValue;
                            }),
                          ],
                          decoration: InputDecoration(
                            labelText: 'Jumlah',
                            errorText: _inputError,
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  key: const Key('portion_decrement_button'),
                                  tooltip: 'Kurangi porsi',
                                  onPressed: () =>
                                      _setPortion(_portion - _step),
                                  icon: const Icon(Icons.remove_rounded),
                                ),
                                IconButton(
                                  key: const Key('portion_increment_button'),
                                  tooltip: 'Tambah porsi',
                                  onPressed: () =>
                                      _setPortion(_portion + _step),
                                  icon: const Icon(Icons.add_rounded),
                                ),
                              ],
                            ),
                          ),
                          onChanged: _onTextChanged,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        key: const Key('portion_unit_dropdown'),
                        initialValue: _unit,
                        decoration: const InputDecoration(labelText: 'Satuan'),
                        items: _units
                            .map(
                              (unit) => DropdownMenuItem<String>(
                                value: unit,
                                child: Text(unit),
                              ),
                            )
                            .toList(growable: false),
                        onChanged: (value) {
                          if (value != null) setState(() => _unit = value);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Card(
                  color: AppColors.muted,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Estimasi Nilai Gizi',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: AppColors.mutedForeground,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          '$_calories kkal',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Wrap(
                          spacing: AppSpacing.lg,
                          runSpacing: AppSpacing.sm,
                          children: [
                            _NutrientPreview(
                              label: 'Protein',
                              value: '${_protein.toStringAsFixed(1)} g',
                            ),
                            _NutrientPreview(
                              label: 'Karbohidrat',
                              value: '${_carbs.toStringAsFixed(1)} g',
                            ),
                            _NutrientPreview(
                              label: 'Lemak',
                              value: '${_fat.toStringAsFixed(1)} g',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton(
                  key: const Key('portion_save_cta'),
                  onPressed: _inputError == null ? _save : null,
                  child: const Text('Perbarui'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NutrientPreview extends StatelessWidget {
  const _NutrientPreview({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.mutedForeground,
          ),
        ),
        Text(value, style: theme.textTheme.labelLarge),
      ],
    );
  }
}
