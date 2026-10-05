import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gizilens/features/history/presentation/widgets/global_error_view.dart';

void main() {
  for (final type in HistoryErrorType.values) {
    testWidgets('shows a recoverable message for $type', (tester) async {
      var retried = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlobalErrorView(type: type, onRetry: () => retried = true),
          ),
        ),
      );

      expect(find.text('Coba lagi'), findsOneWidget);
      expect(
        find.byIcon(
          type == HistoryErrorType.offline
              ? Icons.wifi_off_rounded
              : Icons.cloud_off_rounded,
        ),
        findsOneWidget,
      );
      await tester.tap(find.text('Coba lagi'));
      expect(retried, isTrue);
    });
  }
}
