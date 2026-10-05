import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizilens/features/analysis/presentation/widgets/analysis_failure_view.dart';

void main() {
  testWidgets('explains the failure and exposes both recovery actions', (
    tester,
  ) async {
    var retakeCalled = false;
    var galleryCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AnalysisFailureView(
            onRetake: () => retakeCalled = true,
            onPickGallery: () => galleryCalled = true,
          ),
        ),
      ),
    );

    expect(find.text('Makanan belum dapat dikenali'), findsOneWidget);
    expect(
      find.text(
        'Coba ambil ulang dengan seluruh ompreng terlihat jelas dan pencahayaan yang cukup.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Ambil Ulang'));
    await tester.pump();
    expect(retakeCalled, isTrue);

    await tester.tap(find.text('Pilih dari Galeri'));
    await tester.pump();
    expect(galleryCalled, isTrue);
  });
}
