import 'package:flutter/material.dart';
import 'package:gizilens/core/theme/app_colors.dart';
import 'package:gizilens/core/theme/app_spacing.dart';
import 'package:gizilens/features/history/presentation/widgets/food_record_nutrition_card.dart';
import 'package:gizilens/features/nutrition_detail/presentation/widgets/nutrient_breakdown_item.dart';

class RecordedFoodItem {
  final String name;
  final double portionAmount;
  final String portionUnit;
  final double calories;

  const RecordedFoodItem({
    required this.name,
    required this.portionAmount,
    required this.portionUnit,
    required this.calories,
  });
}

class FoodRecordDetailData {
  final String id;
  final String mealTitle;
  final DateTime consumedAt;
  final String? mediaUrl;
  final List<RecordedFoodItem> items;
  final double totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;
  final List<NutrientData> nutrients;

  const FoodRecordDetailData({
    required this.id,
    required this.mealTitle,
    required this.consumedAt,
    this.mediaUrl,
    required this.items,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    required this.nutrients,
  });
}

class FoodRecordDetailScreen extends StatelessWidget {
  final FoodRecordDetailData record;

  const FoodRecordDetailScreen({super.key, required this.record});

  String _timeLabel(DateTime dateTime) {
    final now = DateTime.now();
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final today = DateTime(now.year, now.month, now.day);
    final prefix = date == today
        ? 'Hari ini'
        : date == today.subtract(const Duration(days: 1))
        ? 'Kemarin'
        : '${date.day} ${_monthNames[date.month - 1]}';
    return '$prefix, ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} WIB';
  }

  static const _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    appBar: AppBar(
      title: const Text('Detail Konsumsi'),
      centerTitle: true,
      leading: const Tooltip(message: 'Kembali', child: BackButton()),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: AppColors.border),
      ),
    ),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenHorizontal,
              AppSpacing.lg,
              AppSpacing.screenHorizontal,
              AppSpacing.xl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _MediaPreview(mediaUrl: record.mediaUrl),
                const SizedBox(height: AppSpacing.md),
                Text(
                  record.mealTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.foreground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 18,
                      color: AppColors.mutedForeground,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      _timeLabel(record.consumedAt),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                _SectionHeading('Daftar Makanan (${record.items.length})'),
                const SizedBox(height: AppSpacing.sm),
                if (record.items.isEmpty)
                  const _EmptyRecordItems()
                else
                  ...record.items.map((item) => _FoodItemTile(item: item)),
                const SizedBox(height: AppSpacing.md),
                FoodRecordNutritionCard(
                  totalCalories: record.totalCalories,
                  proteinGrams: record.totalProtein,
                  carbsGrams: record.totalCarbs,
                  fatGrams: record.totalFat,
                ),
                const SizedBox(height: AppSpacing.lg),
                _SectionHeading('Rincian Mikronutrien'),
                const SizedBox(height: AppSpacing.sm),
                if (record.nutrients.isEmpty)
                  const _EmptyRecordItems(
                    label:
                        'Rincian mikronutrien belum tersedia untuk catatan ini.',
                  )
                else
                  ...record.nutrients.map(
                    (nutrient) => NutrientBreakdownItem(nutrient: nutrient),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _MediaPreview extends StatelessWidget {
  final String? mediaUrl;
  const _MediaPreview({this.mediaUrl});

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: double.infinity,
      height: 190,
      decoration: BoxDecoration(
        color: AppColors.muted,
        borderRadius: AppRadius.roundedLg,
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_outlined, size: 36, color: AppColors.accent),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Foto Ompreng Makanan',
            style: TextStyle(
              color: AppColors.mutedForeground,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
    if (mediaUrl == null || mediaUrl!.trim().isEmpty) return placeholder;
    return Semantics(
      image: true,
      label: 'Foto makanan tersimpan',
      child: ClipRRect(
        borderRadius: AppRadius.roundedLg,
        child: Image.network(
          mediaUrl!,
          width: double.infinity,
          height: 190,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => placeholder,
        ),
      ),
    );
  }
}

class _FoodItemTile extends StatelessWidget {
  final RecordedFoodItem item;
  const _FoodItemTile({required this.item});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: AppRadius.roundedLg,
      border: Border.all(color: AppColors.border),
    ),
    child: Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: AppColors.muted,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.restaurant_menu_rounded,
            color: AppColors.accent,
            size: 21,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.foreground,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${_formatAmount(item.portionAmount)} ${item.portionUnit} • ${item.calories.toStringAsFixed(0)} kkal',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  String _formatAmount(double value) => value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(1);
}

class _SectionHeading extends StatelessWidget {
  final String title;
  const _SectionHeading(this.title);

  @override
  Widget build(BuildContext context) => Text(
    title,
    style: Theme.of(context).textTheme.titleMedium?.copyWith(
      color: AppColors.foreground,
      fontWeight: FontWeight.w700,
    ),
  );
}

class _EmptyRecordItems extends StatelessWidget {
  final String label;
  const _EmptyRecordItems({this.label = 'Belum ada makanan pada catatan ini.'});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
    child: Text(
      label,
      style: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(color: AppColors.mutedForeground),
    ),
  );
}
