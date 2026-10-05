import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizilens/features/capture/presentation/screens/permission_denied_screen.dart';

void main() {
  testWidgets('renders permission explanation and recovery actions', (
    tester,
  ) async {
    var settings = false;
    var gallery = false;
    await tester.pumpWidget(
      MaterialApp(
        home: PermissionDeniedScreen(
          onOpenSettings: () => settings = true,
          onPickFromGallery: () => gallery = true,
        ),
      ),
    );
    expect(find.text('Kamera belum tersedia'), findsOneWidget);
    expect(find.text('Buka Pengaturan'), findsOneWidget);
    expect(find.text('Pilih dari Galeri'), findsOneWidget);
    await tester.tap(find.text('Buka Pengaturan'));
    await tester.tap(find.text('Pilih dari Galeri'));
    expect(settings, isTrue);
    expect(gallery, isTrue);
  });
}
