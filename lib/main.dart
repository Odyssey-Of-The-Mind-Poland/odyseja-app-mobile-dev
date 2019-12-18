/*Core classes of the OotmApp, responsible for displaying pages, navigation bar and fetching data from a webserver.
*/
import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:async' show Future;

// Import pages
import './Home.dart';
import './Info.dart';
import './City.dart';
import './Timetable.dart';
import './Favourites.dart';
import 'ootm_icon_pack.dart';
// import 'Widgets.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
 const MyApp({ Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  int _selected = 0;
  final _navigatorKey = GlobalKey<NavigatorState>();
  final _routeList = [
    '/',
    '/info',
    '/city',
    '/schedule',
    '/favs',
  ];
  @override
  void initState() {
    super.initState();
    syncData();
    print("hello!");
  }
  Widget build(BuildContext context) {
    print("material");
    return MaterialApp(
      title: 'OotmApp',
      theme: ThemeData(
        primaryColor: Color(0xFFFF951A),
        fontFamily: 'Raleway', // Odyssey Orange
        // primaryTextTheme: TextTheme(
        //   body1: TextStyle(color: Color(0xFF333333)),
        //   title: TextStyle(color: Colors.white),
        // )
        ),
      home: ChangeNotifierProvider(
        builder: (context) => ChosenCity(),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
          screenBackground(),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text("Extravaganza"),
              centerTitle: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              textTheme: TextTheme(
                title: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 31,
                  )
                ),
              actions: <Widget>[
                IconButton(
                  disabledColor: Colors.black,
                  icon: Icon(OotmIconPack.sbar_button),
                  onPressed: null
                  )
                ],
              ),
              // CZX is the provider of the solution below.
              // https://stackoverflow.com/questions/49681415/flutter-persistent-navigation-bar-with-named-routes
            body: Navigator(
              key: _navigatorKey,
              initialRoute: '/',
              onGenerateRoute: (RouteSettings settings) {
                WidgetBuilder builder;
                switch (settings.name) {
                  case '/':
                    builder = (BuildContext context) => HomePage();
                    break;
                  }
                switch (settings.name) {
                  case '/info':
                    builder = (BuildContext context) => InfoPage();
                    break;
                  }
                switch (settings.name) {
                  case '/city':
                    builder = (BuildContext context) => SelectCity();
                    break;
                  }
                switch (settings.name) {
                  case '/schedule':
                    builder = (BuildContext context) => TimetablePage();
                    break;
                  }
                switch (settings.name) {
                  case '/favs':
                    builder = (BuildContext context) => FavouritesPage();
                    break;
                  }
                return MaterialPageRoute(
                  maintainState: false,
                  builder: builder,
                  settings: settings,
                  );
                }
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              showUnselectedLabels: false,
              showSelectedLabels: false,
              selectedItemColor: Color(0xFFFF951A),
              unselectedItemColor: Color(0xFF333333),
              currentIndex: _selected,
              onTap: (int index) {
                setState(() {
                  _selected = index;
                });
                _navigatorKey.currentState.pushNamed(_routeList[index]);
                // _navigatorKey.pushNamed(context, "/list");
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  title: Text('Home')
                ),

                BottomNavigationBarItem(
                  icon: Icon(Icons.info_outline),
                  title: Text('Info')
                ),

                BottomNavigationBarItem(
                  icon: Transform.translate(
                    offset: Offset(0, -8),
                    child: SizedOverflowBox(
                      size: Size(24.0, 24.0),
                      child: orangeQuadButton("E.R.", "POZ", false))),
                  title: Text('City Selection'),
                  ),

                BottomNavigationBarItem(
                  icon: Icon(Icons.date_range),
                  title: Text('Harmonogram')
                ),

                BottomNavigationBarItem(
                  icon: Icon(Icons.star_border),
                  title: Text('Ulubione')
                ),
              ],
          ),
    ),
      ],
      )));
  }
}
  Widget orangeQuadButton(String _eventClass, String _eventCity, bool _opened) {
    return Container(
          width: 56.0,
          height: 56.0,
          child: _opened ? Icon(OotmIconPack.close,size: 24.0,color: Colors.white,): Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(_eventClass, style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),),
              Text(_eventCity, style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
              ),
            ],
          ),
          decoration: orangeButtonDecoration()
          );
  }


BoxDecoration orangeButtonDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(10.0),
    color: const Color(0xFFFF951A),
    boxShadow: [BoxShadow(
      color: const Color(0x52FD8800),
      blurRadius: 6.0,
      offset: const Offset(0.0, 3.0),
      )]
    );
} 


Widget screenBackground() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xFFFAFAFA),
            ),
          ),
        navBarBackground()
        ]
      );
    }


Widget navBarBackground () {
    return Container(
      height: 56.0,
      decoration: BoxDecoration(
        color: Color(0xFFFAFAFA),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
          ),
        boxShadow: [
          BoxShadow(
            blurRadius: 6.0,
            offset: Offset(0.0, -3.0),
            color: Color(0x3333333D),
            )
          ],
        ),
      // child: Expansion(),
      );
}  


void syncData() async {
  final String urlTimetable = 'http://grzybek.xyz:8081/timeTable/getAll';
  final String urlInfo = 'http://grzybek.xyz:8081/info/getAllInfo';
  try {
    final response = await http.get(urlTimetable);
    if (response.statusCode == 200) {
      Storage(fileName: 'timeTableGetAll.json').writeFile(response.body);
    }
  } catch (e) {
    throw Exception('Pobranie harmonogramu nie powiodło się.');
  }

  try {
    final response = await http.get(urlInfo);
    if (response.statusCode == 200) {
      Storage(fileName: 'infoGetAll.json').writeFile('response.body');
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
  String path;
  File file;
  String content;

  Storage({@required this.fileName});

  set setFileName(String fileName) {
    this.fileName = fileName;
  }


  Future<File> get _localFile async {
    final _directory = await getApplicationDocumentsDirectory();
    this.path = _directory.path;

    return File('${this.path}/${this.fileName}');
  }


  Future<File> writeFile(String data) async {
    this.file = await _localFile;

    return this.file.writeAsString(data);
  }


  Future<List<Performance>> readFileSchedule() async {
    try {
      this.file = await _localFile;
      this.content = await file.readAsString();
      // this.content = await rootBundle.loadString('assets/getAll.json');

      return scheduleToList(this.content);
    } catch (e) {
      return null;
    }
  }


  Future<List<Info>> readFileInfo() async {
    try {
      this.file = await _localFile;
      this.content = await this.file.readAsString();
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
  final String infNam;

  Info({this.id, this.infoText, this.city, this.infNam});

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      id: json['id'],
      infoText: json['infoText'],
      city: json['city'],
      infNam: json['infName']
    );
  }
}


// http://grzybek.xyz:8081/timeTable/getProblems
// int id, String problemName, int problemNumber