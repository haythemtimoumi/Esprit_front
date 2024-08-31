
// lib/model/module_performance.dart
class ModulePerformance {
  final String module;
  final String typeMoyenne; // Add this field
  final double studentMoyenne;
  final double classAverageMoyenne;

  ModulePerformance(
      this.module,
      this.typeMoyenne, // Add this parameter
      this.studentMoyenne,
      this.classAverageMoyenne,
      );
}