import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizilens/features/capture/presentation/screens/camera_capture_screen.dart';
import 'package:gizilens/features/capture/presentation/widgets/ompreng_guide_overlay.dart';

void main() {
  testWidgets('renders guide copy and custom tray painter', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: OmprengGuideOverlay())),
    );
    expect(
      find.text('Posisikan ompreng agar semua makanan terlihat jelas'),
      findsOneWidget,
    );
    expect(find.byType(CustomPaint), findsWidgets);
  });

  testWidgets('camera screen has accessible close and flash controls', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CameraCaptureScreen()));
    expect(find.byTooltip('Tutup kamera'), findsOneWidget);
    expect(find.byTooltip('Pengaturan lampu kilat'), findsOneWidget);
    expect(
      tester.getSize(find.byTooltip('Tutup kamera')).width,
      greaterThanOrEqualTo(44),
    );
  });
}
