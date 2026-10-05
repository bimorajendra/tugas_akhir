import 'package:flutter/material.dart';
import 'food_record_card.dart';

class TodayFoodList extends StatelessWidget {
  final List<FoodRecordItem>? items;
  final List<FoodRecordItem>? records;
  final void Function(FoodRecordItem item)? onItemTap;
  final VoidCallback? onViewAllTap;

  const TodayFoodList({
    super.key,
    this.items,
    this.records,
    this.onItemTap,
    this.onViewAllTap,
  }) : assert(items == null || records == null);

  List<FoodRecordItem> get _effectiveItems {
    final provided = items ?? records;
    if (provided != null) return provided;
    final now = DateTime.now();
    return [
      FoodRecordItem(
        id: 'mock-1',
        title: 'Nasi, Ayam Suwir & Capcay',
        timestamp: now.subtract(const Duration(hours: 4, minutes: 20)),
        portionGrams: 340,
        caloriesKcal: 560,
        detectedItems: const ['Nasi Putih', 'Ayam Suwir', 'Capcay Kuah'],
      ),
      FoodRecordItem(
        id: 'mock-2',
        title: 'Tempe Mendoan & Pisang',
        timestamp: now.subtract(const Duration(hours: 1, minutes: 15)),
        portionGrams: 160,
        caloriesKcal: 210,
        detectedItems: const ['Tempe Mendoan', 'Pisang Barangan'],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final records = _effectiveItems;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Makanan Hari Ini${records.isEmpty ? '' : ' (${records.length})'}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A),
                ),
              ),
              Semantics(
                button: true,
                label: 'Lihat semua makanan yang dicatat hari ini',
                child: TextButton(
                  onPressed: onViewAllTap ?? () {},
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    minimumSize: const Size(44, 40),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Lihat semua',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF047857),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: records.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) => FoodRecordCard(
            record: records[index],
            onTap: () => onItemTap?.call(records[index]),
          ),
        ),
      ],
    );
  }
}
