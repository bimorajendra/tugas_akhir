import 'package:gizilens/features/history/presentation/screens/food_record_detail_screen.dart';
import 'package:gizilens/features/nutrition_detail/presentation/widgets/nutrient_breakdown_item.dart';

DateTime _earlierToday(DateTime now, int hoursBack) {
  final minutesSinceMidnight = now.hour * 60 + now.minute;
  final minutesBack = (hoursBack * 60).clamp(0, minutesSinceMidnight);
  return now.subtract(Duration(minutes: minutesBack));
}

FoodRecordDetailData sampleLunchRecord(DateTime now) => FoodRecordDetailData(
  id: 'record-lunch',
  mealTitle: 'Makan Siang Ompreng',
  consumedAt: _earlierToday(now, 3),
  items: const [
    RecordedFoodItem(
      name: 'Nasi Putih',
      portionAmount: 150,
      portionUnit: 'gram',
      calories: 195,
    ),
    RecordedFoodItem(
      name: 'Ayam Goreng Lengkuas',
      portionAmount: 100,
      portionUnit: 'gram',
      calories: 260,
    ),
    RecordedFoodItem(
      name: 'Sayur Bening Bayam',
      portionAmount: 80,
      portionUnit: 'gram',
      calories: 36,
    ),
  ],
  totalCalories: 491,
  totalProtein: 28.5,
  totalCarbs: 45.2,
  totalFat: 21,
  nutrients: const [
    NutrientData(
      id: 'iron',
      name: 'Zat Besi (Fe)',
      value: 3.2,
      unit: 'mg',
      target: 18,
      status: NutrientStatus.adequate,
      feedback: 'Asupan zat besi dari bayam mencukupi porsi makan siang.',
    ),
    NutrientData(
      id: 'sodium',
      name: 'Natrium',
      value: 420,
      unit: 'mg',
      target: 2000,
      status: NutrientStatus.adequate,
    ),
  ],
);

FoodRecordDetailData _sampleEveningRecord(DateTime now) => FoodRecordDetailData(
  id: 'record-evening',
  mealTitle: 'Makan Malam',
  consumedAt: _earlierToday(now, 7),
  items: const [
    RecordedFoodItem(
      name: 'Nasi Merah',
      portionAmount: 180,
      portionUnit: 'gram',
      calories: 216,
    ),
    RecordedFoodItem(
      name: 'Ikan Kembung Bakar',
      portionAmount: 120,
      portionUnit: 'gram',
      calories: 220,
    ),
    RecordedFoodItem(
      name: 'Tumis Sayur',
      portionAmount: 150,
      portionUnit: 'gram',
      calories: 113,
    ),
  ],
  totalCalories: 549,
  totalProtein: 34,
  totalCarbs: 63,
  totalFat: 14.5,
  nutrients: const [
    NutrientData(
      name: 'Serat Pangan',
      value: 5.8,
      unit: 'g',
      target: 30,
      status: NutrientStatus.low,
    ),
    NutrientData(
      name: 'Kalium',
      value: 480,
      unit: 'mg',
      target: 4700,
      status: NutrientStatus.low,
    ),
  ],
);

FoodRecordDetailData _sampleYesterdayRecord(DateTime now) =>
    FoodRecordDetailData(
      id: 'record-yesterday',
      mealTitle: 'Makan Siang',
      consumedAt: DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(const Duration(days: 1)).add(const Duration(hours: 12)),
      items: const [
        RecordedFoodItem(
          name: 'Nasi Putih',
          portionAmount: 160,
          portionUnit: 'gram',
          calories: 208,
        ),
        RecordedFoodItem(
          name: 'Pepes Tahu',
          portionAmount: 120,
          portionUnit: 'gram',
          calories: 190,
        ),
        RecordedFoodItem(
          name: 'Sayur Asem',
          portionAmount: 180,
          portionUnit: 'gram',
          calories: 124,
        ),
      ],
      totalCalories: 522,
      totalProtein: 25.6,
      totalCarbs: 66.2,
      totalFat: 14.2,
      nutrients: const [
        NutrientData(
          name: 'Natrium',
          value: 860,
          unit: 'mg',
          target: 2000,
          status: NutrientStatus.adequate,
        ),
        NutrientData(
          name: 'Vitamin B12',
          value: 1.2,
          unit: 'µg',
          status: NutrientStatus.noTarget,
        ),
      ],
    );

List<FoodRecordDetailData> sampleHistoryRecordsFor(
  DateTime selectedDate, {
  DateTime? now,
}) {
  final current = now ?? DateTime.now();
  final selectedDay = DateTime(
    selectedDate.year,
    selectedDate.month,
    selectedDate.day,
  );
  final currentDay = DateTime(current.year, current.month, current.day);
  if (selectedDay == currentDay) {
    return [sampleLunchRecord(current), _sampleEveningRecord(current)];
  }
  if (selectedDay == currentDay.subtract(const Duration(days: 1))) {
    return [_sampleYesterdayRecord(current)];
  }
  return const [];
}
