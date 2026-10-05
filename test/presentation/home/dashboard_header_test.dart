import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizilens/presentation/home/home_screen.dart';
import 'package:gizilens/presentation/home/providers/selected_date_provider.dart';
import 'package:gizilens/presentation/home/widgets/dashboard_header.dart';
import 'package:gizilens/presentation/home/widgets/date_context_bar.dart';

void main() {
  testWidgets('renders personalized dashboard header', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: DashboardHeader(userName: 'Siti'))));
    expect(find.text('Halo, Siti'), findsOneWidget);
    expect(find.text('Berikut ringkasan gizimu hari ini.'), findsOneWidget);
  });

  testWidgets('renders current date context and navigation controls', (tester) async {
    final now = DateTime.now();
    await tester.pumpWidget(ProviderScope(
      overrides: [selectedDateProvider.overrideWith((ref) => SelectedDateNotifier(DateTime(now.year, now.month, now.day)))],
      child: const MaterialApp(home: Scaffold(body: DateContextBar())),
    ));
    expect(find.textContaining('Hari ini'), findsOneWidget);
    expect(find.byKey(const Key('date_bar_prev_button')), findsOneWidget);
    expect(find.byKey(const Key('date_bar_next_button')), findsOneWidget);
  });

  testWidgets('previous button updates selected date', (tester) async {
    final now = DateTime.now();
    late WidgetRef capturedRef;
    await tester.pumpWidget(ProviderScope(
      overrides: [selectedDateProvider.overrideWith((ref) => SelectedDateNotifier(DateTime(now.year, now.month, now.day)))],
      child: Consumer(builder: (context, ref, child) { capturedRef = ref; return const MaterialApp(home: Scaffold(body: DateContextBar())); }),
    ));
    final initial = capturedRef.read(selectedDateProvider);
    await tester.tap(find.byKey(const Key('date_bar_prev_button')));
    await tester.pumpAndSettle();
    expect(capturedRef.read(selectedDateProvider), initial.subtract(const Duration(days: 1)));
  });

  testWidgets('renders HomeScreen header and date bar', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: HomeScreen(userName: 'Budi'))));
    expect(find.text('Halo, Budi'), findsOneWidget);
    expect(find.byType(DashboardHeader), findsOneWidget);
    expect(find.byType(DateContextBar), findsOneWidget);
  });
}
