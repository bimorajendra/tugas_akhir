import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizilens/features/capture/presentation/widgets/capture_mode_selector.dart';
import 'package:gizilens/features/capture/presentation/widgets/shutter_control_bar.dart';

void main() {
  testWidgets('switches Foto and Video mode', (tester) async {
    var mode = CaptureMode.photo;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CaptureModeSelector(
            currentMode: mode,
            onModeChanged: (value) => mode = value,
          ),
        ),
      ),
    );
    await tester.tap(find.text('Video'));
    expect(mode, CaptureMode.video);
  });

  testWidgets('video recording starts with a 30 second countdown', (
    tester,
  ) async {
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
    await tester.pump(const Duration(seconds: 30));
    expect(stopped, isTrue);
    expect(find.byKey(const Key('video_timer_badge')), findsNothing);
  });
}
