import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:ootm_app/data/city.dart';
import 'package:ootm_app/data/divisions.dart';
import 'dart:convert';

import 'package:ootm_app/data/info.dart';
import 'package:ootm_app/data/performance.dart';
import 'package:ootm_app/data/performance_group.dart';
import 'package:ootm_app/data/problems.dart';
import 'package:strings/strings.dart';

class CityDataModel extends ChangeNotifier {
  Box cityBox;
  List<Performance> pfList = [];
  List<Info> infoList = [];
  List<String> stages = [];
  List<PerformanceGroup> pfGroups = [];
  City chosenCity = City(fullName: "", shortName: ["", ""]);

  Future<void> openCityDatabase() async {
    this.cityBox = await Hive.openBox(this.chosenCity.hiveName);
  }

  Future<void> loadCityDatabase() async {
    List<String> boxKeys = this.cityBox.get("performances").cast<String>();
    this.pfList = [for (String k in boxKeys) this.cityBox.get(k)];
    List<PerformanceGroup> pfGroupKeys =
        cityBox.get("performanceGroups").cast<PerformanceGroup>();
    this.pfGroups = pfGroupKeys.map((pfgk) {
      pfgk.performances = [
        // for(String k in pfgk.performanceKeys) this.cityBox.get(k)
        // TODO: whole performancegroup concept should be rewritten
        for (String k in pfgk.performanceKeys)
          this
              .pfList
              .firstWhere((element) => element.id == int.parse(k.substring(1)))
      ];
      return pfgk;
    }).toList();

    this.stages = cityBox.get("stages").cast<String>();
    this.infoList = cityBox.get("info").cast<Info>();
    notifyListeners();
  }

  Future<void> updatePerformanceList(Performance performance) async {
    performance.save();
    int idx = this.pfList.indexOf(performance);
    this.pfList[idx].faved = performance.faved;
  }

  Future<void> closeCityDatabase() async {
    this.cityBox.close();
    this.infoList.clear();
    this.pfList.clear();
    this.pfGroups.clear();
  }

  Future<void> loadChosenCity(String savedCity) async {
    chosenCity =
        CitySet.cities.firstWhere((city) => city.hiveName == savedCity);
  }

  Future<void> storeSchedule() async {
    // keep favourites between updates
    if (this.cityBox.get("performances") != null) {
      final List<String> boxKeys =
          this.cityBox.get("performances").cast<String>();
      final List<Performance> pfListOld = [
        for (String k in boxKeys) this.cityBox.get(k)
      ];
      final List<Performance> pfListOldFavs =
          pfListOld.where((p) => p.faved == true).toList();
      final List<int> indexes = pfListOldFavs.map((p) => p.id).toList();

      if (pfListOldFavs.isNotEmpty) {
        pfList.forEach((p) {
          if (indexes.contains(p.id)) {
            p.faved = true;
          }
        });
      }
    }

    final List<String> keys = pfList.map((p) => "p${p.id}").toList();
    final Map map = Map.fromIterables(keys, pfList);
    await this.cityBox.putAll(map);
    await this.cityBox.put("performances", keys);

    // scrapping names of stages from the schedule
    // TODO discuss stage naming rules
    List<String> stages =
        pfList.map((str) => str.stage.substring(6)).toSet().toList();
    stages.sort();

    // format names of stages to standarise their style.
    final List<String> formattedStages =
        stages.map((s) => capitalize(s.substring(4).toLowerCase())).toList();

    // store stages
    await this.cityBox.put("stages", formattedStages);

    // creating problemGroups for more optimised access
    List<PerformanceGroup> pfGroups = [];
    final List<String> problemsPresent = problemShorts();
    final List<String> agesPresent = ageShorts();
    for (int i = 1; i < stages.length + 1; i++) {
      for (String problem in problemsPresent) {
        for (String age in agesPresent) {
          List<Performance> groupData = pfList
              .where((p) =>
                  p.stage.substring(6, 7) == i.toString() &&
                  p.problem == problem &&
                  p.age == age)
              .toList();

          if (groupData.isNotEmpty) {
            final List<String> pfKeys =
                groupData.map((p) => "p${p.id}").toList();
            pfGroups.add(PerformanceGroup(
              age: age,
              problem: problem,
              stage: i,
              performanceKeys: pfKeys,
            ));
          }
        }
      }
    }
    await this.cityBox.put("performanceGroups", pfGroups);
  }

  Future<void> storeInfo() async {
    this.cityBox.put("info", this.infoList);
  }

  void scheduleToList(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    this.pfList =
        parsed.map<Performance>((json) => Performance.fromJson(json)).toList();
  }

  void infoToList(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    this.infoList = parsed.map<Info>((json) => Info.fromJson(json)).toList();
  }
}
