import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async' show Future;
import 'package:hive/hive.dart';
import 'package:strings/strings.dart';
part 'data.g.dart';

String urlSchedule(String _city) {
  final String _address = 
    'http://grzybek.xyz:8081/timeTable/getLike?city=$_city&team=&problem=&age=&stage=';
  return  _address;
}
String urlInfo(String _city) {
  final String _address = 'http://grzybek.xyz:8081/info/getInfo?city=$_city';
  return  _address;
}
String urlStages(String _city) {
  final String _address = 'http://grzybek.xyz:8081/info/getInfo?city=$_city';
  return  _address;
}
String urlProblems(String _city) {
  final String _address = 'http://grzybek.xyz:8081/info/getInfo?city=$_city';
  return  _address;
}

void firstRunSync() {
  // FUTURE: getCities, to get events and dates for the current year.
  // FUTURE: getProblems, to get problem names for the current year.
  // CitySet.generate();
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
  // syncRegio(); // DEBUG
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
    print(city.shortName);
    CityData(
      hiveName: city.hiveName,
      apiName: city.apiName,
    ).syncData();
  }
}

void syncFinals() {
  print("syncFinals");
  City finals = CitySet.cities.last;
  print(finals.shortName);
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

    if (gotSchedule == true && gotInfo == true) {
    // if (gotSchedule == true) { // DEBUG
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

    // TODO? Why the commented code below doesn't work as intended? 
    // stages.forEach((str) => str.substring(4));

    final List<String> formattedStages = stages.map((s) => 
      capitalize(s.substring(4).toLowerCase())).toList();
    // print(uniq);
    await this.cityBox.put("stages", formattedStages);


    // creating problemGroups for easier access
    List<PerformanceGroup> pfGroups = new List<PerformanceGroup>();
    final List<String> problemsPresent = problemShorts();
    final List<String> agesPresent = ageShorts();

    for (int i=0; i<stages.length; i++){
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
          // print(infoList[0].infoText);
          await this.cityBox.put("info", infoList);
          // List<Info> getInfo = this.cityBox.get("info").cast<Info>();
          // print(getInfo[0].infoText);
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


class CitySet {
  static List<City> cities = new List<City>();

  CitySet({cities});

  factory CitySet.generate() {
    cities.clear();
      for (int i=0; i<City.hiveNames().length; i++) {
        cities.add(new City.generate(i));
      }
    return CitySet(cities: cities);
  }

}


class City {
  String apiName;
  String fullName;
  String shortName;
  String hiveName;
  DateTime eventDate;

  City({this.apiName, this.fullName, this.shortName, this.hiveName, this.eventDate});

  factory City.generate(int idx) { 
    return City(
      apiName: apiNames()[idx],
      fullName: fullNames()[idx],
      shortName: shortNames()[idx],
      hiveName: hiveNames()[idx],
      eventDate: eventDates()[idx],
    );
  }
  static List<String> apiNames() {
    const List<String> _events = [
      "Wrocław",
      "Poznań",
      "Katowice",
      "Warszawa",
      "Łódź",
      "Gdańsk",
      "Gdynia",
    ];
    return _events;
  }
  static List<String> fullNames() {
    const List<String> _events = [
      "Eliminacje Regionalne - Wrocław",
      "Eliminacje Regionalne - Poznań",
      "Eliminacje Regionalne - Katowice",
      "Eliminacje Regionalne - Warszawa",
      "Eliminacje Regionalne - Łódź",
      "Eliminacje Regionalne - Gdańsk",
      "Finał Ogólnopolski - Gdynia",
    ];
    return _events;
  }
  static List<String> shortNames() {
    const List<String> _events = [
      "WRO",
      "POZ",
      "KATO",
      "WAW",
      "ŁÓDŹ",
      "GDA",
      "GDY",
      ];
    return _events;
  }
  static List<String> hiveNames() {
    const List<String> _events = [
      "wroclaw",
      "poznan",
      "katowice",
      "warszawa",
      "lodz",
      "gdansk",
      "gdynia",
      ];
    return _events;
  }
  static List<DateTime> eventDates() {
    List<DateTime> _dates = [
      DateTime(2020,02,29),
      DateTime(2020,03,01),
      DateTime(2020,03,07),
      DateTime(2020,03,08),
      DateTime(2020,03,14),
      DateTime(2020,03,15),
      DateTime(2020,04,04),
      ];
    return _dates;
  }
}


List<Performance> scheduleToList(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Performance>((json) => Performance.fromJson(json)).toList();
}


List<Info> infoToList(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Info>((json) => Info.fromJson(json)).toList();
}


@HiveType(typeId: 0)
class Performance extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String city;
  @HiveField(2)
  final String team;
  @HiveField(3)
  final String problem;
  @HiveField(4)
  final String age;
  @HiveField(5)
  final String play;
  @HiveField(6)
  final String spontan;
  @HiveField(7)
  final String stage;
  @HiveField(8)
  bool faved;

  Performance({this.faved, this.id, this.city, this.team,
    this.problem, this.age, this.play, this.spontan, this.stage});

  factory Performance.fromJson(Map<String, dynamic> json) {
    return Performance(
      id: json['id'],
      city: json['city'],
      team: json['team'],
      problem: json['problem'],
      age: json['age'],
      play: (json['performance'].length < 5)
      ? "0" + json['performance']
      : json['performance'],
      spontan: json['spontan'],
      stage: json['stage'],
      faved: false,
    );
  }
}

@HiveType(typeId: 1)
class Info extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String infoText;
  @HiveField(2)
  final String city;
  @HiveField(3)
  final String infName;

  Info({this.id, this.infoText, this.city, this.infName});

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      id: json['id'],
      infoText: json['infoText'],
      city: json['city'],
      infName: json['infName']
    );
  }
}


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

  PerformanceGroup({@required this.stage, @required this.problem, @required this.age, @required this.performanceKeys});
}
// http://grzybek.xyz:8081/timeTable/getProblems
// int id, String problemName, int problemNumber

  // temporary solution

List<String> problemList() {
  const List<String> _problems = [
    "Juniorki",
    "Reakcja na ryzyko",
    "Co leci w sieci",
    "Perspektywa detektywa",
    "Nisko zawieszona poprzeczka",
    "Nonsensy z sensem"
    ];
  return _problems;
}
List<String> ageList() {
  const List<String> _ages = [
    "Juniorzy",
    "<=V\nklasa",
    "VI - VIII\nklasa",
    "Lic./\ntechnik.",
    "Uczelnie\nWyższe",
    ];
  return _ages;
}
List<String> sceneShorts(){
  const List<String> _shorts = ['1', '2', '3', '4', '5','6'];
  return _shorts;
}
List<String> problemShorts(){
  const List<String> _shorts = ['J', '1', '2', '3', '4', '5'];
  return _shorts;
}
List<String> ageShorts(){
  const List<String> _shorts = ['J', 'I', 'II', 'III', 'IV'];
  return _shorts;
}