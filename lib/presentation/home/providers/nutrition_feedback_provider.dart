import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gizilens/domain/models/nutrition_feedback.dart';

final nutritionFeedbackProvider = Provider<List<NutritionFeedback>>((ref) {
  final now = DateTime.now();
  return [
    NutritionFeedback(id: 'fb-sodium-limit', nutrientName: 'Natrium', title: 'Natrium hari ini mendekati batas', message: 'Kamu sudah mencapai 87% dari batas harian.', severity: FeedbackSeverity.warning, percentage: 87, timestamp: now.subtract(const Duration(minutes: 25))),
    NutritionFeedback(id: 'fb-protein-low', nutrientName: 'Protein', title: 'Asupan protein masih di bawah target', message: 'Penuhi 28 g lagi untuk mencapai target harianmu.', severity: FeedbackSeverity.info, percentage: 62, timestamp: now.subtract(const Duration(hours: 2))),
  ];
});
