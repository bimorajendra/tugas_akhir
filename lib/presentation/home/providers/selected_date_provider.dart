import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedDateNotifier extends StateNotifier<DateTime> {
  SelectedDateNotifier([DateTime? initialDate]) : super(_day(initialDate ?? DateTime.now()));
  static DateTime _day(DateTime value) => DateTime(value.year, value.month, value.day);
  void selectDate(DateTime date) => state = _day(date);
  void previousDay() => state = state.subtract(const Duration(days: 1));
  void nextDay() => state = state.add(const Duration(days: 1));
  void resetToToday() => state = _day(DateTime.now());
}

final selectedDateProvider = StateNotifierProvider<SelectedDateNotifier, DateTime>((ref) => SelectedDateNotifier());
