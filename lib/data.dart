import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:async' show Future;
import 'package:hive/hive.dart';
import 'dart:io';

// part 'performance.g.dart';
// part 'info.g.dart';
part 'data.g.dart';


void syncSchedule() async {
  final String urlTimetable = 'http://grzybek.xyz:8081/timeTable/getAll';
  try {
    final response = await http.get(urlTimetable);
    if (response.statusCode == 200) {
      Storage(fileName: 'timeTableGetAll.json').writeFile(response.body);
    }
  } catch (e) {
    throw Exception('Pobranie harmonogramu nie powiodło się.');
  }
}
void syncInfo() async {
  final String urlInfo = 'http://grzybek.xyz:8081/info/getAllInfo';
  try {
    final response = await http.get(urlInfo);
    if (response.statusCode == 200) {
      Storage(fileName: 'infoGetAll.json').writeFile(response.body);
    }
  } catch (e) {
    throw Exception('Pobranie info nie powiodło się.');
  }
}


/* Storage class is based on an example from flutter's documentation:
https://flutter.dev/docs/cookbook/persistence/reading-writing-files
It's reuse is governed by an unspecified BSD license.
*/ 
Future<void> savePerformances(String city) async {
  Box box = await Hive.openBox(
    city,
    compactionStrategy: (int total, int deleted) {
      return deleted > 1;
    }
  );
  List<Performance> performanceList = new List<Performance>();
  performanceList = await Storage(fileName: 'timeTableGetAll.json').readFileSchedule();
  box.add(performanceList);
}

class Storage {
  String fileName; 
  String content;

  Storage({@required this.fileName});


  Future<File> get _localFile async {
    final _directory = await getApplicationDocumentsDirectory();

    return File('${_directory.path}/${this.fileName}');
  }


  Future<File> writeFile(String data) async {
    File _file = await _localFile;

    return _file.writeAsString(data);
  }


  Future<List<Performance>> readFileSchedule() async {
    try {
      File _file = await _localFile;
      this.content = await _file.readAsString();
      // this.content = await rootBundle.loadString('assets/getAll.json');

      return scheduleToList(this.content);
    } catch (e) {
      return null;
    }
  }


  Future<List<Info>> readFileInfo() async {
    try {
      File _file = await _localFile;
      this.content = await _file.readAsString();
      return infoToList(this.content);
    } catch (e) {
      return null;
    }
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
      break;
    case "Poznań" :
      const List<String> _scenes = [
        "Sala 17",
        "Sala Koralowa",
        "Sala 430",
        "Sala 109",
        "Sala 210",
        ];
      return _scenes;
      break;
    case "Katowice" :
      const List<String> _scenes = [
        "Sala 17",
        "Sala Koralowa",
        "Sala 430",
        "Sala 109",
        "Sala 210",
        ];
      return _scenes;
      break;
    case "Warszawa" :
      const List<String> _scenes = [
        "Sala 17",
        "Sala Koralowa",
        "Sala 430",
        "Sala 109",
        "Sala 210",
        ];
      return _scenes;
      break;
    case "Łódź" :
      const List<String> _scenes = [
        "Sala 17",
        "Sala Koralowa",
        "Sala 430",
        "Sala 109",
        "Sala 210",
        ];
      return _scenes;
      break;
    case "Gdańsk" :
      const List<String> _scenes = [
        "Sala 17",
        "Sala Koralowa",
        "Sala 430",
        "Sala 109",
        "Sala 210",
        ];
      return _scenes;
      break;
    case "Gdynia_sobota" :
      const List<String> _scenes = [
        "Sala 17",
        "Sala Koralowa",
        "Sala 430",
        "Sala 109",
        "Sala 210",
        ];
      return _scenes;
      break;
    case "Gdynia_niedziela" :
      const List<String> _scenes = [
        "Sala 17",
        "Sala Koralowa",
        "Sala 430",
        "Sala 109",
        "Sala 210",
        ];
      return _scenes;
      break;
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

List<String> eventList() {
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
List<String> cities() {
  const List<String> _events = [
    "Wrocław",
    "Poznań",
    "Katowice",
    "Warszawa",
    "Łódź",
    "Gdańsk",
    "Gdynia_sobota",
    "Gdynia_niedziela",
  ];
  return _events;
}