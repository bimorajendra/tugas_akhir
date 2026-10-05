class MacroNutrientItem {
  final String name;
  final double consumed;
  final double? target;
  final String unit;

  const MacroNutrientItem({required this.name, required this.consumed, this.target, this.unit = 'g'});
  int? get percentage => target == null || target! <= 0 ? null : ((consumed / target!) * 100).round();
  double get progressFraction => target == null || target! <= 0 ? 0 : (consumed / target!).clamp(0.0, 1.0);
}

class NutritionSummary {
  final double energyConsumed;
  final double? energyTarget;
  final String energyUnit;
  final String energyStatusText;
  final List<MacroNutrientItem> macros;

  const NutritionSummary({required this.energyConsumed, this.energyTarget, this.energyUnit = 'kkal', required this.energyStatusText, required this.macros});
  int? get energyPercentage => energyTarget == null || energyTarget! <= 0 ? null : ((energyConsumed / energyTarget!) * 100).round();
  double get energyProgressFraction => energyTarget == null || energyTarget! <= 0 ? 0 : (energyConsumed / energyTarget!).clamp(0.0, 1.0);
}
