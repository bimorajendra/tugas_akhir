import 'package:flutter/material.dart';

class FoodRecordItem {
  final String id;
  final String title;
  final DateTime timestamp;
  final double portionGrams;
  final int caloriesKcal;
  final String? imageUrl;
  final List<String> detectedItems;

  const FoodRecordItem({
    required this.id,
    required this.title,
    required this.timestamp,
    required this.portionGrams,
    required this.caloriesKcal,
    this.imageUrl,
    this.detectedItems = const [],
  });

  String get formattedTime {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class FoodRecordCard extends StatelessWidget {
  final FoodRecordItem record;
  final VoidCallback? onTap;

  const FoodRecordCard({super.key, required this.record, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      excludeSemantics: true,
      button: true,
      label: 'Buka detail makanan ${record.title}',
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            constraints: const BoxConstraints(minHeight: 68),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE2E8F0)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                _FoodThumbnail(imageUrl: record.imageUrl),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        record.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            record.formattedTime,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF475569),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              '•',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF475569),
                              ),
                            ),
                          ),
                          Text(
                            '${record.portionGrams.toInt()} g',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF475569),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${record.caloriesKcal} kkal',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF047857),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: Color(0xFF94A3B8),
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

class _FoodThumbnail extends StatelessWidget {
  final String? imageUrl;

  const _FoodThumbnail({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.lunch_dining_outlined,
        size: 22,
        color: Color(0xFF047857),
      ),
    );

    if (imageUrl == null || imageUrl!.isEmpty) return fallback;
    return SizedBox(
      width: 44,
      height: 44,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => fallback,
        ),
      ),
    );
  }
}
