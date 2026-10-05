import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizilens/presentation/shell/app_shell.dart';
import 'package:gizilens/presentation/shell/widgets/bottom_nav_bar.dart';
import 'package:gizilens/presentation/shell/widgets/floating_capture_button.dart';

void main() {
  group('AppShell & Navigation Widgets', () {
    testWidgets('renders all destinations and central capture button', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AppShell()));
      expect(find.byType(BottomNavBar), findsOneWidget);
      expect(find.byType(FloatingCaptureButton), findsOneWidget);
      expect(find.text('Beranda'), findsOneWidget);
      expect(find.text('Riwayat'), findsOneWidget);
      expect(find.text('Profil'), findsOneWidget);
      expect(find.bySemanticsLabel('Catat makanan'), findsOneWidget);
    });

    testWidgets('switching tab preserves each tab state', (tester) async {
      await tester.pumpWidget(MaterialApp(home: AppShell(children: [
        TextFormField(key: const Key('input_beranda'), initialValue: 'State Beranda'),
        TextFormField(key: const Key('input_riwayat'), initialValue: 'State Riwayat'),
        TextFormField(key: const Key('input_profil'), initialValue: 'State Profil'),
      ])));
      expect(find.byKey(const Key('input_beranda')), findsOneWidget);
      await tester.tap(find.text('Riwayat'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('input_riwayat')), 'State Riwayat Diubah');
      await tester.tap(find.text('Beranda'));
      await tester.pumpAndSettle();
      expect(find.text('State Beranda'), findsOneWidget);
      await tester.tap(find.text('Riwayat'));
      await tester.pumpAndSettle();
      expect(find.text('State Riwayat Diubah'), findsOneWidget);
    });

    testWidgets('triggers onCaptureTap', (tester) async {
      var captureTapped = false;
      await tester.pumpWidget(MaterialApp(home: AppShell(onCaptureTap: () => captureTapped = true)));
      await tester.tap(find.byType(FloatingCaptureButton));
      await tester.pumpAndSettle();
      expect(captureTapped, isTrue);
    });
  });
}
