import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizilens/features/capture/presentation/screens/media_preview_screen.dart';
import 'package:gizilens/features/capture/presentation/widgets/preview_action_card.dart';

void main() {
  testWidgets('renders preview action card', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PreviewActionCard(
            isAnalyzing: false,
            onAnalyze: () {},
            onRetake: () {},
          ),
        ),
      ),
    );
    expect(find.text('Siap dianalisis?'), findsOneWidget);
    expect(
      find.text('Pastikan seluruh makanan dalam ompreng terlihat jelas.'),
      findsOneWidget,
    );
    expect(find.text('Analisis Makanan'), findsOneWidget);
    expect(find.text('Ambil Ulang'), findsOneWidget);
  });

  testWidgets('analyze is locked against duplicate taps', (tester) async {
    var count = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: MediaPreviewScreen(
          mediaPath: 'mock.jpg',
          onRetake: () {},
          onConfirmAnalysis: (_) => count++,
        ),
      ),
    );
    await tester.pumpAndSettle();
    final button = find.widgetWithText(ElevatedButton, 'Analisis Makanan');
    await tester.tap(button);
    await tester.pump();
    await tester.tap(button, warnIfMissed: false);
    await tester.pump();
    expect(count, 1);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
