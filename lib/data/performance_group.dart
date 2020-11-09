import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'performance.dart';

part 'performance_group.g.dart';

@HiveType(typeId: 2)
class PerformanceGroup {
  @HiveField(0)
  final int stage;
  @HiveField(1)
  final String problem;
  @HiveField(2)
  final String age;
  @HiveField(3)
  final List<String> performanceKeys;
  List<Performance> performances;

  PerformanceGroup({@required this.stage, @required this.problem, @required this.age, @required this.performanceKeys, this.performances});
}