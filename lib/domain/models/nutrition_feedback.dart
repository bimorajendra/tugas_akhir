import 'package:flutter/material.dart';
import 'package:gizilens/core/theme/app_colors.dart';

enum FeedbackSeverity { info, positive, warning, critical }

enum NutrientStatus {
  low,
  adequate,
  approachingLimit,
  excessive,
  unavailable;

  String get label => switch (this) {
        NutrientStatus.low => 'Rendah',
        NutrientStatus.adequate => 'Cukup',
        NutrientStatus.approachingLimit => 'Mendekati batas',
        NutrientStatus.excessive => 'Berlebih',
        NutrientStatus.unavailable => 'Data belum tersedia',
      };

  IconData get icon => switch (this) {
        NutrientStatus.low => Icons.arrow_downward_rounded,
        NutrientStatus.adequate => Icons.check_circle_outline_rounded,
        NutrientStatus.approachingLimit => Icons.warning_amber_rounded,
        NutrientStatus.excessive => Icons.error_outline_rounded,
        NutrientStatus.unavailable => Icons.help_outline_rounded,
      };

  Color get foregroundColor => switch (this) {
        NutrientStatus.low => AppColors.statusRendah,
        NutrientStatus.adequate => AppColors.statusCukup,
        NutrientStatus.approachingLimit => AppColors.statusMendekatiBatas,
        NutrientStatus.excessive => AppColors.statusBerlebih,
        NutrientStatus.unavailable => AppColors.statusBelumTersedia,
      };

  Color get backgroundColor => switch (this) {
        NutrientStatus.low => AppColors.muted,
        NutrientStatus.adequate => const Color(0xFFF0FDF4),
        NutrientStatus.approachingLimit => const Color(0xFFFFFBEB),
        NutrientStatus.excessive => const Color(0xFFFEF2F2),
        NutrientStatus.unavailable => AppColors.muted,
      };

  Color get borderColor => switch (this) {
        NutrientStatus.low => AppColors.border,
        NutrientStatus.adequate => const Color(0xFFBBF7D0),
        NutrientStatus.approachingLimit => const Color(0xFFFDE68A),
        NutrientStatus.excessive => const Color(0xFFFECACA),
        NutrientStatus.unavailable => AppColors.border,
      };
}

class NutritionFeedback {
  final String id;
  final String nutrientName;
  final String title;
  final String message;
  final FeedbackSeverity severity;
  final double? percentage;
  final DateTime timestamp;

  const NutritionFeedback({required this.id, required this.nutrientName, required this.title, required this.message, required this.severity, this.percentage, required this.timestamp});
}
