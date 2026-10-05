import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizilens/features/analysis/presentation/screens/analysis_processing_screen.dart';
import 'package:gizilens/features/analysis/presentation/widgets/staged_analysis_indicator.dart';

void main() {
  testWidgets('renders upload stage and radar', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AnalysisProcessingScreen(
          mediaPath: '/test/food.jpg',
          isVideo: false,
          simulateProgress: false,
        ),
      ),
    );
    expect(find.text('Menganalisis Makananmu'), findsOneWidget);
    expect(find.text('Mengunggah media…'), findsOneWidget);
    expect(
      find.text('Mengirimkan foto ompreng ke sistem analisis GiziLens.'),
      findsOneWidget,
    );
    expect(find.byType(StagedAnalysisIndicator), findsOneWidget);
  });

  testWidgets('renders detecting, calculating, long wait, and cancel dialog', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StagedAnalysisIndicator(
            stage: AnalysisStage.detecting,
            isLongWait: true,
          ),
        ),
      ),
    );
    expect(find.text('Mengenali makanan…'), findsOneWidget);
    expect(
      find.text('Proses ini sedikit lebih lama dari biasanya.'),
      findsOneWidget,
    );
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StagedAnalysisIndicator(stage: AnalysisStage.calculating),
        ),
      ),
    );
    expect(find.text('Menghitung informasi gizi…'), findsOneWidget);
    await tester.pumpWidget(
      const MaterialApp(
        home: AnalysisProcessingScreen(
          mediaPath: 'mock',
          isVideo: false,
          simulateProgress: false,
        ),
      ),
    );
    await tester.tap(find.byKey(const Key('analysis_close_button')));
    await tester.pump();
    expect(find.text('Batalkan Analisis?'), findsOneWidget);
  });

  testWidgets('completes after the staged analysis progress', (tester) async {
    var completed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: AnalysisProcessingScreen(
          mediaPath: 'mock',
          isVideo: false,
          onAnalysisCompleted: () => completed = true,
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 1800));
    expect(find.text('Mengenali makanan…'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 2200));
    expect(find.text('Menghitung informasi gizi…'), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
    expect(
      find.text('Proses ini sedikit lebih lama dari biasanya.'),
      findsOneWidget,
    );
    await tester.pump(const Duration(seconds: 1));
    expect(completed, isTrue);
  });

  testWidgets('keeps the radar still when reduced motion is enabled', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(disableAnimations: true),
          child: child!,
        ),
        home: const Scaffold(
          body: StagedAnalysisIndicator(stage: AnalysisStage.uploading),
        ),
      ),
    );

    await tester.pump();
    expect(tester.binding.transientCallbackCount, 0);
  });
}
