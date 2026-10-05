import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizilens/core/theme/app_theme.dart';
import 'package:gizilens/presentation/onboarding/onboarding_screen.dart';
import 'package:gizilens/presentation/onboarding/widgets/ompreng_artwork.dart';

void main() {
  Widget subject({VoidCallback? onComplete}) => MaterialApp(theme: AppTheme.lightTheme, home: OnboardingScreen(onComplete: onComplete));

  testWidgets('renders first slide with ompreng artwork and skip action', (tester) async {
    await tester.pumpWidget(subject());
    expect(find.text('Kenali asupanmu dengan lebih mudah'), findsOneWidget);
    expect(find.text('Pantau makanan dan kandungan gizinya tanpa pencatatan manual yang rumit.'), findsOneWidget);
    expect(find.byType(OmprengArtwork), findsOneWidget);
    expect(find.byKey(const Key('onboarding_skip_button')), findsOneWidget);
    expect(find.text('Lanjut'), findsOneWidget);
  });

  testWidgets('swiping navigates through all slides and starts', (tester) async {
    var completed = false;
    await tester.pumpWidget(subject(onComplete: () => completed = true));
    await tester.drag(find.byKey(const Key('onboarding_page_view')), const Offset(-400, 0));
    await tester.pumpAndSettle();
    expect(find.text('Cukup foto atau rekam makananmu'), findsOneWidget);
    await tester.drag(find.byKey(const Key('onboarding_page_view')), const Offset(-400, 0));
    await tester.pumpAndSettle();
    expect(find.text('Lihat kecukupan gizimu setiap hari'), findsOneWidget);
    expect(find.byKey(const Key('onboarding_start_button')), findsOneWidget);
    expect(find.text('Mulai'), findsOneWidget);
    await tester.tap(find.byKey(const Key('onboarding_start_button')));
    await tester.pumpAndSettle();
    expect(completed, isTrue);
  });

  testWidgets('skip completes immediately', (tester) async {
    var completed = false;
    await tester.pumpWidget(subject(onComplete: () => completed = true));
    await tester.tap(find.byKey(const Key('onboarding_skip_button')));
    await tester.pumpAndSettle();
    expect(completed, isTrue);
  });
}
