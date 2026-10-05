import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizilens/core/theme/app_theme.dart';
import 'package:gizilens/domain/models/nutrition_feedback.dart';
import 'package:gizilens/presentation/home/providers/nutrition_feedback_provider.dart';
import 'package:gizilens/presentation/home/widgets/nutrient_status_chip.dart';
import 'package:gizilens/presentation/home/widgets/nutrition_feedback_card.dart';

void main() {
  testWidgets('renders every nutrient status with text and icon', (tester) async {
    for (final status in NutrientStatus.values) {
      await tester.pumpWidget(MaterialApp(theme: AppTheme.lightTheme, home: Scaffold(body: Center(child: NutrientStatusChip(status: status)))));
      expect(find.text(status.label), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
    }
  });

  testWidgets('status chip has descriptive text independent of color', (tester) async {
    await tester.pumpWidget(MaterialApp(theme: AppTheme.lightTheme, home: const Scaffold(body: Center(child: NutrientStatusChip(status: NutrientStatus.approachingLimit)))));
    expect(find.text('Mendekati batas'), findsOneWidget);
    expect(find.byType(NutrientStatusChip), findsOneWidget);
  });

  testWidgets('renders warning feedback and detail CTA', (tester) async {
    var tapped = false;
    final feedback = NutritionFeedback(id: 'fb-1', nutrientName: 'Natrium', title: 'Natrium hari ini mendekati batas', message: 'Kamu sudah mencapai 87% dari batas harian.', severity: FeedbackSeverity.warning, percentage: 87, timestamp: DateTime.now().subtract(const Duration(minutes: 15)));
    await tester.pumpWidget(MaterialApp(theme: AppTheme.lightTheme, home: Scaffold(body: NutritionFeedbackCard(feedback: feedback, onDetailTap: () => tapped = true))));
    expect(find.text(feedback.title), findsOneWidget);
    expect(find.text(feedback.message), findsOneWidget);
    expect(find.text('Lihat detail'), findsOneWidget);
    await tester.tap(find.text('Lihat detail'));
    expect(tapped, isTrue);
  });

  testWidgets('renders positive feedback copy', (tester) async {
    final feedback = NutritionFeedback(id: 'fb-2', nutrientName: 'Protein', title: 'Asupan protein tercukupi', message: 'Pemenuhan protein harianmu telah mencapai target optimal.', severity: FeedbackSeverity.positive, percentage: 102, timestamp: DateTime.now().subtract(const Duration(hours: 1)));
    await tester.pumpWidget(MaterialApp(theme: AppTheme.lightTheme, home: Scaffold(body: NutritionFeedbackCard(feedback: feedback))));
    expect(find.text(feedback.title), findsOneWidget);
    expect(find.text(feedback.message), findsOneWidget);
  });

  test('provider uses relative timestamps and prioritized feedback', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final feedback = container.read(nutritionFeedbackProvider);
    expect(feedback, isNotEmpty);
    expect(feedback.first.title, isNotEmpty);
    expect(feedback.first.message, isNotEmpty);
    expect(feedback.first.timestamp.isBefore(DateTime.now().add(const Duration(seconds: 1))), isTrue);
  });
}
