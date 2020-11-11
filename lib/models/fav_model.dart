import 'package:flutter/widgets.dart';
import 'package:ootm_app/data/performance_group.dart';

class FavModel extends ChangeNotifier {
  List<PerformanceGroup> _favPerformanceGroups = [];

  set favList(List<PerformanceGroup> pfGroups) {
    _favPerformanceGroups = pfGroups.map((pfGroup) {
      return PerformanceGroup(
          stage: pfGroup.stage,
          problem: pfGroup.problem,
          age: pfGroup.age,
          performanceKeys: pfGroup.performanceKeys,
          performances:
              pfGroup.performances.where((p) => p.faved == true).toList());
    }).toList();

    notifyListeners();
  }

  get favList => _favPerformanceGroups;
}
