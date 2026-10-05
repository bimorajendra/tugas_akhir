import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizilens/core/theme/app_theme.dart';
import 'package:gizilens/presentation/profile/profile_setup_screen.dart';

void main() {
  Widget subject() => ProviderScope(child: MaterialApp(theme: AppTheme.lightTheme, home: const ProfileSetupScreen()));

  testWidgets('renders profile setup content', (tester) async {
    await tester.pumpWidget(subject());
    expect(find.text('Lengkapi profilmu'), findsOneWidget);
    expect(find.text('Data ini digunakan untuk menyesuaikan target kebutuhan gizimu.'), findsOneWidget);
    expect(find.text('Usia'), findsOneWidget);
    expect(find.text('Jenis Kelamin'), findsOneWidget);
    expect(find.text('Tinggi Badan'), findsOneWidget);
    expect(find.text('Berat Badan'), findsOneWidget);
    expect(find.text('Simpan & Lanjutkan'), findsOneWidget);
  });

  testWidgets('shows inline errors on empty submit', (tester) async {
    await tester.pumpWidget(subject());
    await tester.tap(find.text('Simpan & Lanjutkan'));
    await tester.pumpAndSettle();
    expect(find.text('Bagian ini wajib diisi.'), findsNWidgets(3));
  });

  testWidgets('submits valid data with loading and success state', (tester) async {
    await tester.pumpWidget(subject());
    await tester.enterText(find.byKey(const Key('profile_age_field')), '25');
    await tester.enterText(find.byKey(const Key('profile_height_field')), '172');
    await tester.enterText(find.byKey(const Key('profile_weight_field')), '64');
    await tester.tap(find.text('Simpan & Lanjutkan'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('profile_setup_success_indicator')), findsOneWidget);
  });

  testWidgets('calls completion callback after valid submit', (tester) async {
    var completed = false;
    await tester.pumpWidget(ProviderScope(child: MaterialApp(theme: AppTheme.lightTheme, home: ProfileSetupScreen(onComplete: () => completed = true))));
    await tester.enterText(find.byKey(const Key('profile_age_field')), '25');
    await tester.enterText(find.byKey(const Key('profile_height_field')), '172');
    await tester.enterText(find.byKey(const Key('profile_weight_field')), '64');
    await tester.tap(find.text('Simpan & Lanjutkan'));
    await tester.pumpAndSettle();
    expect(completed, isTrue);
  });
}
