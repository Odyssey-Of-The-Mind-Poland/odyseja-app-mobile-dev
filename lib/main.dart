/*Core classes of the OotmApp, responsible for displaying pages, navigation bar and fetching data from a webserver.
*/
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter/services.dart' show rootBundle;


// Import routes
import './Home.dart';
import './Info.dart';
import './City.dart';
import './Timetable.dart';
import './Favourites.dart';

import 'ootm_icon_pack.dart';
import 'data.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
 const MyApp({ Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    syncSchedule();
    syncInfo();
    print("hello!");
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
  // @override
  // void initState() {
    // super.initState();
  // }
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