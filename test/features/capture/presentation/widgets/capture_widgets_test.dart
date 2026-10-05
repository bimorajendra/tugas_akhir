import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizilens/features/capture/presentation/screens/camera_capture_screen.dart';
import 'package:gizilens/features/capture/presentation/widgets/capture_mode_selector.dart';
import 'package:gizilens/features/capture/presentation/widgets/ompreng_guide_overlay.dart';
import 'package:gizilens/features/capture/presentation/widgets/shutter_control_bar.dart';

void main() {
  testWidgets('overlay and camera screen render', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: OmprengGuideOverlay())),
    );
    expect(
      find.text('Posisikan ompreng agar semua makanan terlihat jelas'),
      findsOneWidget,
    );
    expect(find.byType(CustomPaint), findsWidgets);
    await tester.pumpWidget(const MaterialApp(home: CameraCaptureScreen()));
    expect(find.byType(OmprengGuideOverlay), findsOneWidget);
    expect(find.byTooltip('Tutup kamera'), findsOneWidget);
    expect(find.byTooltip('Pengaturan lampu kilat'), findsOneWidget);
  });

  testWidgets('mode selector switches and photo shutter taps', (tester) async {
    var selected = CaptureMode.photo;
    var photo = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              CaptureModeSelector(
                currentMode: selected,
                onModeChanged: (value) => selected = value,
              ),
              ShutterControlBar(
                mode: CaptureMode.photo,
                onTakePhoto: () => photo = true,
                onStartRecording: () {},
                onStopRecording: () {},
                onGalleryTap: () {},
                onFlipCameraTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
    await tester.tap(find.text('Video'));
    expect(selected, CaptureMode.video);
    await tester.tap(find.byKey(const Key('shutter_button')));
    await tester.pump();
    expect(photo, isTrue);
  });

  testWidgets('video timer counts down and auto-stops', (tester) async {
    var started = false;
    var stopped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ShutterControlBar(
            mode: CaptureMode.video,
            onTakePhoto: () {},
            onStartRecording: () => started = true,
            onStopRecording: () => stopped = true,
            onGalleryTap: () {},
            onFlipCameraTap: () {},
          ),
        ),
      ),
    );
    await tester.tap(find.byKey(const Key('shutter_button')));
    await tester.pump();
    expect(started, isTrue);
    expect(find.text('00:30'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    expect(find.text('00:25'), findsOneWidget);
    await tester.pump(const Duration(seconds: 25));
    expect(stopped, isTrue);
    expect(find.byKey(const Key('video_timer_badge')), findsNothing);
  });
}
