import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async' show Future;
import 'package:hive/hive.dart';

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

void firstRun() {
  // FUTURE: getCities, to get events and dates for the current year.
  // FUTURE: getProblems, to get problem names for the current year.
  // CitySet.generate();
  Box cityAgnostic = Hive.box("cityAgnostic");
  syncRegio();
  syncFinals();
  cityAgnostic.put("firstRun", false);
}

void defaultRun() {
  // first city of regional eliminations; the start of the season
  DateTime regioSeasonS = CitySet.cities.first.eventDate;
  // last city of regional eliminations; the end of the season
  DateTime regioSeasonE = CitySet.cities.elementAt(CitySet.cities.length - 2).eventDate;
  DateTime finalsSeason = CitySet.cities.last.eventDate;
  DateTime today = DateTime.now();
  syncRegio(); // DEBUG
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
    apiNameList: finals.apiName,
  ).syncData();
}


class CityData {
  final String hiveName;
  final String apiName;
  final List<String> apiNameList;
  Box cityAgnostic;
  Box cityBox;
  List<int> favIndices; 
  CityData({@required this.hiveName, this.apiName, this.apiNameList,});

  Future<void> syncData() async {
    this.cityBox = await Hive.openBox(this.hiveName);
    cityAgnostic = await Hive.openBox("cityAgnostic");

    bool gotSchedule = await _syncSchedule();
    bool gotInfo = await _syncInfo();
    // syncStages();
    if (gotSchedule == true && gotInfo == true) {
      cityAgnostic.put(this.hiveName, true);
    } else {
      cityAgnostic.put(this.hiveName, false);
    }
    cityBox.close();
  }
    
  Future<bool> _syncSchedule() async {

    List<String> _apiNameList = new List<String>();
    if (this.apiName != null && this.apiNameList == null) {
      _apiNameList.add(this.apiName);
    }
    else if (this.apiName == null && this.apiNameList != null) {
      _apiNameList = this.apiNameList;
    }
    else {
      throw Exception("apiName and apiNameList fields cannot be used simultaneously!");
    }

    List<Performance> pfList = new List<Performance>();
    try {
      for (String _apiName in _apiNameList) {
        final response = await http.get(urlSchedule(_apiName));
        if (response.statusCode == 200) {
          pfList.addAll(scheduleToList(response.body));
        }
        else return false;
      }
    } catch (e) {
      throw Exception("Pobranie harmonogramu nie powiodło się.");
    }

    if (this.cityBox.get("performances") != null) {
      assert(true, "Loading old favs");
      List<String> boxKeys = this.cityBox.get("performances");
      List<Performance> pfListOld = [for(String k in boxKeys) this.cityBox.get(k)];
      List<Performance> pfListOldFavs = pfListOld.where((p) => p.faved == true).toList();
      List<int> indexes = pfListOldFavs.map((p) => p.id).toList();
      
      if (pfListOldFavs.isNotEmpty) {
        pfList.forEach((p) {
          if (indexes.contains(p.id)) {
            p.faved = true;
          }
        });
      }
    }

    List<String> keys = new List<String>.generate(pfList.length, (i) => "p$i");
    Map map = Map.fromIterables(keys, pfList);
    this.cityBox.putAll(map);
    this.cityBox.put("performances", keys);
    return true;
  }

  Future<bool> _syncInfo() async {
    try {
      final response = await http.get(urlInfo(this.apiName));
      if (response.statusCode == 200) {
        this.cityBox.put("info", infoToList(response.body));
        return true;
      }
    } catch (e) {
      throw Exception("Pobranie harmonogramu nie powiodło się.");
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
  dynamic apiName;
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
  static List<dynamic> apiNames() {
    const List<dynamic> _events = [
      "Wrocław",
      "Poznań",
      "Katowice",
      "Warszawa",
      "Łódź",
      "Gdańsk",
      ["Gdynia_sobota","Gdynia_niedziela"],
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
      "Wroclaw",
      "Poznan",
      "Katowice",
      "Warszawa",
      "Lodz",
      "Gdansk",
      "Gdynia",
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
      play: json['performance'],
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


// http://grzybek.xyz:8081/timeTable/getProblems
// int id, String problemName, int problemNumber

  // temporary solution

List<String> sceneList(String city) {
  switch (city) {
    case "Wrocław":
      const List<String> _scenes = [
        "Sala 17",
        "Sala Koralowa",
        "Sala 430",
        "Sala 109",
        "Sala 210",
        ];
      return _scenes;
    case "Poznań" :
      const List<String> _scenes = [
        "Sala 17",
        "Sala Koralowa",
        "Sala 430",
        "Sala 109",
        "Sala 210",
        ];
      return _scenes;
    case "Katowice" :
      const List<String> _scenes = [
        "Sala 17",
        "Sala Koralowa",
        "Sala 430",
        "Sala 109",
        "Sala 210",
        ];
      return _scenes;
    case "Warszawa" :
      const List<String> _scenes = [
        "Sala 17",
        "Sala Koralowa",
        "Sala 430",
        "Sala 109",
        "Sala 210",
        ];
      return _scenes;
    case "Łódź" :
      const List<String> _scenes = [
        "Sala 17",
        "Sala Koralowa",
        "Sala 430",
        "Sala 109",
        "Sala 210",
        ];
      return _scenes;
    case "Gdańsk" :
      const List<String> _scenes = [
        "Sala 17",
        "Sala Koralowa",
        "Sala 430",
        "Sala 109",
        "Sala 210",
        ];
      return _scenes;
    case "Gdynia_sobota" :
      const List<String> _scenes = [
        "Sala 17",
        "Sala Koralowa",
        "Sala 430",
        "Sala 109",
        "Sala 210",
        ];
      return _scenes;
    case "Gdynia_niedziela" :
      const List<String> _scenes = [
        "Sala 17",
        "Sala Koralowa",
        "Sala 430",
        "Sala 109",
        "Sala 210",
        ];
      return _scenes;
    // default:
  }
  Exception("No such city");
  return null;
}
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
  const List<String> _shorts = ['J', 'I', 'II', 'III', 'IV', 'V'];
  return _shorts;
}