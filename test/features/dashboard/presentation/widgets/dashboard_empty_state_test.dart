import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizilens/features/dashboard/presentation/widgets/dashboard_empty_state.dart';
import 'package:gizilens/features/dashboard/presentation/widgets/dashboard_shimmer_skeleton.dart';

void main() {
  testWidgets('renders empty state and triggers CTA', (tester) async {
    var pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DashboardEmptyState(onRecordFood: () => pressed = true),
        ),
      ),
    );
    expect(find.text('Belum ada makanan yang dicatat'), findsOneWidget);
    expect(
      find.text(
        'Foto atau rekam makanan pertamamu untuk mulai memantau asupan hari ini.',
      ),
      findsOneWidget,
    );
    expect(find.byKey(const Key('ompreng_tray_illustration')), findsOneWidget);
    await tester.tap(find.text('Catat Makanan'));
    expect(pressed, isTrue);
  });

  testWidgets('renders shimmer placeholders', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: DashboardShimmerSkeleton())),
    );
    expect(
      find.byKey(const Key('dashboard_shimmer_container')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('shimmer_energy_card')), findsOneWidget);
    expect(find.byKey(const Key('shimmer_macro_row')), findsOneWidget);
  });
}
