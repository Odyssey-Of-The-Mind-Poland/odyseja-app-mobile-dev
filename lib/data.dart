import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async' show Future;
import 'package:hive/hive.dart';
import 'package:strings/strings.dart';

import 'data/city.dart';
import 'data/city_set.dart';
import 'data/divisions.dart';
import 'data/info.dart';
import 'data/performance.dart';
import 'data/performance_group.dart';
import 'data/problems.dart';
import 'services/api_endpoints.dart';



void firstRunSync() {
  // FUTURE: getCities, to get events and dates for the current year.
  // FUTURE: getProblems, to get problem names for the current year.
  syncRegio();
  syncFinals();
}

void defaultRunSync() {
  // first city of regional eliminations; the start of the season
  DateTime regioSeasonS = CitySet.cities.first.eventDate;
  // last city of regional eliminations; the end of the season
  DateTime regioSeasonE = CitySet.cities.elementAt(CitySet.cities.length - 2).eventDate;
  DateTime finalsSeason = CitySet.cities.last.eventDate;
  DateTime today = DateTime.now();
  syncRegio(); // DEBUG TODO
  if (today.isAfter(regioSeasonS.subtract(new Duration(days: 14)))) {
    if (today.isBefore(regioSeasonS.subtract(new Duration(days: 1)))) {
      syncRegio();
    }
  }
  else if (today.isAfter(regioSeasonE.add(new Duration(days: 7)))) {
    if (today.isBefore(finalsSeason.subtract(new Duration(days: 1)))) {
      syncFinals();
    }
  }
}

void syncRegio() {
  print("syncRegio");
  List<City> cities = CitySet.cities;
  for (City city in cities.sublist(0, cities.length - 1)) {
    print(city.shortName[0]);
    CityData(
      hiveName: city.hiveName,
      apiName: city.apiName,
    ).syncData();
  }
}

void syncFinals() {
  print("syncFinals");
  City finals = CitySet.cities.last;
  print(finals.shortName[0]);
  CityData(
    hiveName: finals.hiveName,
    apiName: finals.apiName,
  ).syncData();
}



class CityData {
  final String hiveName;
  final String apiName;
  Box cityBox;
  List<int> favIndices; 
  CityData({@required this.hiveName, @required this.apiName});

  Future<void> syncData() async {
    this.cityBox = await Hive.openBox(this.hiveName);
    final cityAgnostic = await Hive.openBox("cityAgnostic");

    final bool gotSchedule = await _syncSchedule();
    final bool gotInfo = await _syncInfo();
    // syncStages();

    // TODO put proper info  
    // if (gotSchedule == true && gotInfo == true) {
    if (gotSchedule == true) { // DEBUG
      print([this.hiveName, "true"]);
      cityAgnostic.put(this.hiveName, true);
    } else {
      print([this.hiveName, "false"]);
      cityAgnostic.put(this.hiveName, false);
    }
    this.cityBox.close();

  }
    
  Future<bool> _syncSchedule() async {

    List<Performance> pfList = new List<Performance>();
    try {
      final response = await http.get(urlSchedule(this.apiName));
      if (response.statusCode == 200) {
        pfList.addAll(scheduleToList(response.body));
      }
      else return false;
      if (pfList.isEmpty) {
        return false;
      }
    } catch (e) {
      throw Exception("Pobranie harmonogramu nie powiodło się.");
    }


    if (this.cityBox.get("performances") != null) {
      final List<String> boxKeys = this.cityBox.get("performances").cast<String>();
      final List<Performance> pfListOld = [for(String k in boxKeys) this.cityBox.get(k)];
      final List<Performance> pfListOldFavs = pfListOld.where((p) => p.faved == true).toList();
      final List<int> indexes = pfListOldFavs.map((p) => p.id).toList();
      
      if (pfListOldFavs.isNotEmpty) {
        pfList.forEach((p) {
          if (indexes.contains(p.id)) {
            p.faved = true;
          }
        });
      }
    }


    // final List<String> keys = new List<String>.generate(pfList.length, (i) => "p$i");
    final List<String> keys = pfList.map((p) => "p${p.id}").toList();
    final Map map = Map.fromIterables(keys, pfList);
    await this.cityBox.putAll(map);
    await this.cityBox.put("performances", keys);


    // scrapping stages from the schedule
    List<String> stages = pfList.map((str) => str.stage.substring(6)).toSet().toList();
    stages.sort();

    // Why the commented code below doesn't work as intended? 
    // stages.forEach((str) => str.substring(4));

    final List<String> formattedStages = stages.map((s) => 
      capitalize(s.substring(4).toLowerCase())).toList();
    // print(uniq);
    await this.cityBox.put("stages", formattedStages);


    // creating problemGroups for easier access
    List<PerformanceGroup> pfGroups = new List<PerformanceGroup>();
    final List<String> problemsPresent = problemShorts();
    final List<String> agesPresent = ageShorts();
    for (int i=1; i<stages.length+1; i++){
      for (String problem in problemsPresent) {
        for (String age in agesPresent) {
          List<Performance> groupData = pfList.where(
            (p) =>
            p.stage.substring(6,7) == i.toString() &&
            p.problem ==  problem && 
            p.age == age
          ).toList();

          if (groupData.isNotEmpty) {
            final List<String> pfKeys = groupData.map((p) => "p${p.id}").toList();
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
    await this.cityBox.put("performanceGroups",pfGroups);

    return true;
  }

  Future<bool> _syncInfo() async {
    try {
      final response = await http.get(urlInfo(this.apiName));
      if (response.statusCode == 200) {
        List<Info> infoList = infoToList(response.body);
        if (infoList.isNotEmpty) {
          await this.cityBox.put("info", infoList);
          return true;
        }
      }
    } catch (e) {
      throw Exception("Pobranie info nie powiodło się.");
    }
    return false;
  }

  // Future<void> syncStages() async {
  //   try {
  //     final response = await http.get(urlStages(this.apiName));
  //     if (response.statusCode == 200) {
  //       // this.stages.addAll(scheduleToList(response.body));
  //     }
  //   } catch (e) {
  //     throw Exception("Pobranie harmonogramu nie powiodło się.");
  //   }
  // }
}



List<Performance> scheduleToList(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Performance>((json) => Performance.fromJson(json)).toList();
}


List<Info> infoToList(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Info>((json) => Info.fromJson(json)).toList();
}
