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

// void firstRun() {
//   // TODO problems
//   for (String city in cities()) {
//     CityData(city: city).syncData();
//   }
// }
// List<CityData> cityDataList() {
  
  
//   return null;
// }

class CityData {
  final String hiveName;
  final String apiName;
  Box settings;
  Box box;
  List<int> favIndices; 
  CityData({@required this.hiveName, @required this.apiName});

  Future<void> syncData() async {
    this.box = await Hive.openBox(this.hiveName);
    settings = Hive.box("settings");
    syncSchedule();
    syncInfo();
    // syncStages();
    // settings.put("${this.city}_syncDate", DateTime.now());
  }
    
  Future<void> syncSchedule() async {
    // this.schedule = await Hive.openBox(this.city+"_schedule");
    try {
      final response = await http.get(urlSchedule(this.apiName));
      if (response.statusCode == 200) {
        // salveFavs();
        List<Performance> pfList = scheduleToList(response.body);
        List<String> keys = new List<String>.generate(pfList.length, (i) => "p$i");
        Map map = Map.fromIterables(keys, pfList);
        this.box.putAll(map);
        this.box.put("performances", keys);
      }
    } catch (e) {
      throw Exception("Pobranie harmonogramu nie powiodło się.");
    }
  }

  Future<void> syncInfo() async {
    try {
      final response = await http.get(urlInfo(this.apiName));
      if (response.statusCode == 200) {
        this.box.put("info", infoToList(response.body));
      }
    } catch (e) {
      throw Exception("Pobranie harmonogramu nie powiodło się.");
    }
  }

  Future<void> syncStages() async {
    try {
      final response = await http.get(urlStages(this.apiName));
      if (response.statusCode == 200) {
        // this.stages.addAll(scheduleToList(response.body));
      }
    } catch (e) {
      throw Exception("Pobranie harmonogramu nie powiodło się.");
    }
  }
  void salveFavs() {

  }
  void embossFavs() {

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
  const List<String> _shorts = ['1', '2', '3', '4', '5'];
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


class CitySet {
  static List<City> cities = new List<City>();

  CitySet({cities});

  factory CitySet.generate() {
    // List<City> cities = new List<City>(); 
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
      DateTime(2020,29,02),
      DateTime(2020,01,03),
      DateTime(2020,07,03),
      DateTime(2020,08,03),
      DateTime(2020,14,03),
      DateTime(2020,15,03),
      DateTime(2020,04,04),
      ];
    return _dates;
  }
}