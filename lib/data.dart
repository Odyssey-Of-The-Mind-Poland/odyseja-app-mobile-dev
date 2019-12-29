import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:async' show Future;

import 'dart:io';


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


class Performance {
  final int id;
  final String city;
  final String team;
  final String problem;
  final String age;
  final String play;
  final String spontan;
  final String stage;

  Performance({this.id, this.city, this.team, this.problem, this.age, this.play, this.spontan, this.stage});

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
    );
  }
}


class Info {
  final int id;
  final String infoText;
  final String city;
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