/*Core classes of the OotmApp, responsible for displaying pages, navigation bar and fetching of the data from a webserver 
*/
// import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter/foundation.dart';
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
  Future<List<Performance>> performances;
  final String url = 'http://grzybek.bymarcin.com:8081/getAll';
  factory() => performances = fetchTimetableData(url);
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
    print('init');
    // pf = DefaultCacheManager().getSingleFile(url);
    // syncData();
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OotmApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // brightness: Brightness.dark,
        primaryTextTheme: TextTheme(
          title: TextStyle(color: Colors.white),
        )
      ),
      home: Scaffold(
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
              icon: Icon(Icons.person_outline),
              title: Text('Konto')
            ),
          ],
        ),
    ),
    );
  }
  // void syncData() async {
  //   String url = 'http://grzybek.bymarcin.com:8081/getAll';
  //   List<Performance> performances = await fetchTimetableData(url);
  //   // var _timetableData = DefaultCacheManager().getSingleFile(url);
  //   // return timetableDataToList(_timetableData.whenComplete(action));
  //   // timetableDataToList(_timetableData.then());
  //   // fetchTimetableData();
  //   // updateTimetable();
  //   // updateInfo();
  // }
}

Future<List<Performance>> fetchTimetableData(String url) async {
  final response = await http.get(url);
  print('fetchtimetabledata');
  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
    return timetableDataToList(response.body);
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Pobranie danych nie powiodło się.');
  }

}

List<Performance> timetableDataToList(String responseBody) {
  final parsedTT = json.decode(responseBody).cast<Map<String, dynamic>>();
  // print(parsedTT);
  return parsedTT.map<Performance>((json) => Performance.fromJson(json)).toList();
}

class Performance {
  final int id;
  final String city;
  final String team;
  final String problem;
  final String age;
  final String performance;
  final String spontan;
  final String stage;

  Performance({this.id, this.city, this.team, this.problem, this.age, this.performance, this.spontan, this.stage});

  factory Performance.fromJson(Map<String, dynamic> json) {
    return Performance(
      id: json['id'],
      city: json['city'],
      team: json['team'],
      problem: json['problem'],
      age: json['age'],
      performance: json['performance'],
      spontan: json['spontan'],
      stage: json['stage'],
    );
  }
}