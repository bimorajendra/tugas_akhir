import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizilens/features/capture/presentation/widgets/gallery_picker_trigger.dart';

void main() {
  testWidgets('shows inline error for unsupported or oversized media', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GalleryPickerTrigger(
            pickMedia: (_) async => (name: 'food.gif', size: 1024),
          ),
        ),
      ),
    );
    await tester.tap(find.byKey(const Key('gallery_picker_trigger')));
    await tester.pump();
    expect(
      find.textContaining('Format foto .gif tidak didukung'),
      findsOneWidget,
    );
  });

  testWidgets('returns valid selected media to callback', (tester) async {
    String? selected;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GalleryPickerTrigger(
            pickMedia: (_) async => (name: 'food.jpg', size: 1024),
            onMediaSelected: (name) => selected = name,
          ),
        ),
      ),
    );
    await tester.tap(find.byKey(const Key('gallery_picker_trigger')));
    await tester.pump();
    expect(selected, 'food.jpg');
  });
}
