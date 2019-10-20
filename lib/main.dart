/*Core classes of the OotmApp, responsible for displaying pages, navigation bar and fetching of the data from a webserver 
*/
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:async';

// Import pages
import './Account.dart';
import './City.dart';
import './Info.dart';
import './Map.dart';
import './Timetable.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  int _selected = 0;
  final _pages = [
    CityPage(),
    InfoPage(),
    TimetablePage(),
    MapPage(),
    AccountPage(),
  ];
  @override
  void initState() {
    super.initState();
    syncData();
    // testStorage();
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OotmApp',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        // brightness: Brightness.dark,
        primaryTextTheme: TextTheme(
          title: TextStyle(color: Colors.white),
        )
      ),
      home: ChangeNotifierProvider(
        builder: (context) => ChosenCity(),
              child: Scaffold(
          // appBar: AppBar(),
          body: SafeArea(child: _pages[_selected]),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            // showUnselectedLabels: false,
            currentIndex: _selected,
            onTap: (int index) {
              setState(() {
                _selected = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.location_city),
                title: Text('Miasto')
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.info_outline),
                title: Text('Info')
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.date_range),
                title: Text('Harmonogram')
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                title: Text('Mapa')
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                title: Text('Zaznaczone')
              ),
            ],
          ),
    ),
      ),
    );
  }
}

// https://flutter.dev/docs/cookbook/persistence/reading-writing-files
class Storage {
  String fileName; 
  String path;
  File file;
  String content;

  Storage(this.fileName);

  set setFileName(String fileName) {
    this.fileName = fileName;
  }
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }
  Future<File> get _localFile async {
    this.path = await _localPath;

    return File('${this.path}/${this.fileName}');
  }
  Future<List<Performance>> readFileTT() async {
    try {
      this.file = await _localFile;
      this.content = await file.readAsString();

      return timetableDataToList(this.content);
    } catch (e) {
      return null;
    }
  }
  // Future<List<Info>> readFileInfo() async {
  //   try {
  //     this.file = await _localFile;
  //     this.content = await this.file.readAsString();
  //     return this.content;
  //   } catch (e) {
  //     return null;
  //   }
  // }
  Future<File> writeFile(String data) async {
    this.file = await _localFile;

    // Write the file
    return this.file.writeAsString(data);
  }
}

void syncData() async {
  final String urlTimetable = 'http://grzybek.bymarcin.com:8081/getAll';
  try {
    final response = await http.get(urlTimetable);
    if (response.statusCode == 200) {
      // Storage('infoGetAll.json').writeFile('response.body');
      Storage('timeTableGetAll.json').writeFile(response.body);
    }
  } catch (e) {
    throw Exception('Pobranie danych nie powiodło się.');
  }
}

List<Performance> timetableDataToList(String responseBody) {
  final parsedTT = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsedTT.map<Performance>((json) => Performance.fromJson(json)).toList();
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

// class Info {

// }
