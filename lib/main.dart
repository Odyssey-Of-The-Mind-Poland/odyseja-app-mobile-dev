/*Core classes of the OotmApp, responsible for app navigation and navBar.
*/
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter/services.dart' show rootBundle;


// Import routes
import './home.dart';
import './info.dart';
import './city.dart';
import './favourites.dart';
import 'schedule.dart';

import 'ootm_icon_pack.dart';
import 'data.dart';
import 'common_widgets.dart';

void main() => runApp(MyApp());

// final keyScaffold = new GlobalKey<ScaffoldState>();
final key = new GlobalKey<_MainFrameState>();

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    syncSchedule();
    syncInfo();
    print("hello!");
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
      home: SafeArea(
        child: MainFrame(),
      ),
    );
  }
}


class MainFrame extends StatefulWidget {

  const MainFrame({Key key}) : super(key: key);
  @override
  _MainFrameState createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> with SingleTickerProviderStateMixin{
  final _navigatorKey = GlobalKey<NavigatorState>();
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.64, 0.0)
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
  
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context) => ChosenCity()),
        ChangeNotifierProvider(builder: (context) => EndDrawerProvider()),
        ],
      child: Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          Drawer(child: Container(color: Colors.grey, child: Text("Ustawienia"),)),
          Consumer<EndDrawerProvider>(
            builder: (context, endDrawerProvider, child) {
              if(endDrawerProvider.opened) {
                _controller.forward();
              } else {
                _controller.reverse();
              }
              return SlideTransition(
                position: _offsetAnimation,
                child: GestureDetector(
                  onTap: endDrawerProvider.opened ? 
                  () => endDrawerProvider.change() : null,
                  child: AbsorbPointer(
                    absorbing: endDrawerProvider.opened,
                    child: Scaffold(
                      // key: keyScaffold,
                      body: navigatorDestinations(_navigatorKey),
                      bottomNavigationBar: OotmNavBar(
                        navigatorKey: _navigatorKey,
                      )
                    ),
                  ),
                ),
              );
            }
          )
        ],
      )
    ); 
  }
}


class OotmNavBar extends StatefulWidget {
  static const _routeList = [
    '/',
    '/info',
    '/city',
    '/schedule',
    '/favs',
    ];
  final navigatorKey;
  OotmNavBar({Key key, this.navigatorKey}) : super(key: key);

  @override
  _OotmNavBarState createState() => _OotmNavBarState();
}

class _OotmNavBarState extends State<OotmNavBar> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        navBarBackground(),
        BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        selectedItemColor: Color(0xFFFF951A),
        unselectedItemColor: Color(0xFF333333),
        currentIndex: _selected,
        onTap: (int index) {
          if(index != 2) {
            setState(() {
              _selected = index;
            });
            widget.navigatorKey.currentState.pushNamed(OotmNavBar._routeList[index]);
          } else {
            void _showBottomSheet(context) {
                showModalBottomSheet(
                  // useRootNavigator: true,
                  // clipBehavior: ,
                  context: context,
                  builder: (BuildContext bc) {
                    return Container(
                      child: Text("lol"),
                      height: 400.0,
                    );
                  }
                );
            }
          _showBottomSheet(context);
          }
        },
          items: [
            BottomNavigationBarItem(
              icon: Icon(OotmIconPack.home),
              title: Text('Home')
            ),
            BottomNavigationBarItem(
              icon: Icon(OotmIconPack.info),
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
              icon: Icon(OotmIconPack.schedule),
              title: Text('Harmonogram')
            ),
            BottomNavigationBarItem(
              icon: Icon(OotmIconPack.favs_outline),
              title: Text('Ulubione')
            ),
          ],
    ),
    ]
  );
  }
}


Navigator navigatorDestinations(Key _navigatorKey) {
  return Navigator(
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
          builder = (BuildContext context) => ScheduleMenuRoute();
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
  );
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
      decoration: orangeBoxDecoration()
    );
  }


Widget navBarBackground() {
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