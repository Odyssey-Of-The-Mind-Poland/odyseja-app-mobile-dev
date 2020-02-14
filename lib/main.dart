/*Core classes of the OotmApp, responsible for app navigation and navBar.
*/
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

import 'package:ootm_app/routes/help_feedback.dart';
import 'package:ootm_app/routes/data_privacy.dart';
// Import routes
import 'home.dart';
import 'info.dart';
// import 'city.dart';
import 'favourites.dart';
import 'schedule.dart';

import 'ootm_icon_pack.dart';
import 'data.dart';
import 'common_widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  final documentsDir = await getApplicationDocumentsDirectory();
  Hive.registerAdapter(PerformanceAdapter());
  Hive.registerAdapter(PerformanceGroupAdapter());
  Hive.registerAdapter(InfoAdapter());
  // Hive.initFlutter();
  Hive.init(documentsDir.path);
  await Hive.openBox("cityAgnostic");
  runApp(MyApp());
}

// final keyScaffold = new GlobalKey<ScaffoldState>();
// final key = new GlobalKey<_MainFrameState>();

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("hello!");
    Box cityAgnostic = Hive.box("cityAgnostic");
    CitySet.generate();
    if (cityAgnostic.get("firstRun", defaultValue: true) == true) {
      print("firstRun");
      firstRun();
    } else {
      print("defaultRun");
      defaultRun();
    }
    // Future<void> loadCityBox() async {
    //   await Hive.openBox("Warszawa");
    //   // await Hive.openBox("Katowice");
    // }

    // loadCityBox();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context) => CitySelector()),
        ChangeNotifierProvider(builder: (context) => ChosenCity()),
        ChangeNotifierProvider(builder: (context) => EndDrawerProvider()),
        ],
        child: MaterialApp(
          // debugShowMaterialGrid: true,
          title: 'OotmApp',
          theme: ThemeData(
            primaryColor: Color(0xFFFF951A),
            fontFamily: 'Raleway', // Odyssey Orange
            // primaryTextTheme: TextTheme(
            //   body1: TextStyle(color: Color(0xFF333333)),
            //   title: TextStyle(color: Colors.white),
            // )
            ),
        home: MainFrame(),
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
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  static const double endDrawerAnimationOffset = -0.70;
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(endDrawerAnimationOffset, 0.0)
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
  }
  @override
  void dispose() {
    _controller.dispose();
    Hive.close();
    super.dispose();
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: <Widget>[
        OotmEndDrawer(
          endDrawerAnimationOffset: endDrawerAnimationOffset,
        ),
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
                onPanUpdate: (details) {
                  if (details.delta.dx > 0) {
                    // swiping in right direction
                    if (endDrawerProvider.opened) {
                      endDrawerProvider.change();
                    }
                  }
                },
                onTap: endDrawerProvider.opened ? 
                () => endDrawerProvider.change() : null,
                child: AbsorbPointer(
                  absorbing: endDrawerProvider.opened,
                  
                  child: MainFrameWindow()
                ),
              ),
            );
          }
        )
      ],
    ); 
  }
}



class MainFrameWindow extends StatefulWidget {
  MainFrameWindow({Key key}) : super(key: key);
  @override
  _MainFrameWindowState createState() => _MainFrameWindowState();
}

class _MainFrameWindowState extends State<MainFrameWindow> with SingleTickerProviderStateMixin{
  final _navigatorKey = GlobalKey<NavigatorState>();
  Animation<double> _animation;
  Animation<double> _fadeAnimation;
  AnimationController _controller;
  bool _visibility = false;

  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut,)
      ..addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        _visibility = true;
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
        _visibility = false;
        });
      }
    });
    _fadeAnimation = Tween<double>(begin: 0.0, end: 0.7).animate(_animation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // bool visibility = false;
  @override
  Widget build(BuildContext context) {
  final cityProvider = Provider.of<ChosenCity>(context);
    return Scaffold(
      // key: keyScaffold,
      body: Stack(
        children: <Widget>[
          navigatorDestinations(_navigatorKey),
          Consumer<CitySelector>(
            builder: (context, citySelector, widget) {
              if (citySelector.opened) {
                _controller.forward();
              }
              else {
                _controller.reverse();
              }
              List<Widget> cityButtons= [];
              double _offset = -0.25;
              List<City> cities = CitySet.cities.reversed.toList();
              for (City city in cities) {
                cityButtons.add(new SlideTransition(
                  position: new Tween<Offset>(
                    begin: Offset(0.0, 1.0),
                    end: Offset(0.0, _offset), 
                  ).animate(new CurvedAnimation(
                    curve: Curves.easeInOut,
                    parent: _controller,
                  )),
                  child: RawMaterialButton(
                    onPressed: () {
                      cityProvider.chosenCity = city;
                      citySelector.change();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 4.0),
                      child: Flex(
                        direction: Axis.horizontal,
                        children: <Widget>[
                          Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            height: 40.0,
                            decoration: orangeBoxDecoration(),
                            child: Text(
                              city.fullName,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                      ),
                    ),
                  ),
                ));
                _offset-=1;
              }
              
              return  
              _visibility ? Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  FadeTransition(
                    opacity: _fadeAnimation,
                    // child: ModalBarrier(color: Colors.red,),
                    child: IgnorePointer(
                      ignoring: true,
                                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black
                        ),
                      ),
                    ),
                  ),
                  ...cityButtons,
                ],
              ) : SizedBox();
            },
          )
        ],
      ),
      bottomNavigationBar: OotmNavBar(
        navigatorKey: _navigatorKey,
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
    final citySelectorProvider = Provider.of<CitySelector>(context);
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
            citySelectorProvider.change();
          }
        },
          items: [
            BottomNavigationBarItem(
              icon: Icon(OotmIconPack.navbar_home),
              title: Text('Home')
            ),
            BottomNavigationBarItem(
              icon: Icon(OotmIconPack.navbar_info),
              title: Text('Info')
            ),
            BottomNavigationBarItem(
              icon: Transform.translate(
                offset: Offset(0, -8),
                child: SizedOverflowBox(
                  size: Size(24.0, 24.0),
                  child: CityButton())),
              title: Text('City Selection'),
              ),
            BottomNavigationBarItem(
              icon: Icon(OotmIconPack.navbar_schedule),
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



class CityButton extends StatefulWidget {
  CityButton({Key key}) : super(key: key);
  // final List<City> cities = CitySet.cities;
  
  @override
  _CityButtonState createState() => _CityButtonState();
}

class _CityButtonState extends State<CityButton> {
  // bool _opened = false;
  @override
  Widget build(BuildContext context) {
  final citySelectorProvider = Provider.of<CitySelector>(context);
  final cityProvider = Provider.of<ChosenCity>(context);
  bool _opened = citySelectorProvider.opened;
    return RawMaterialButton(
      onPressed: () {
        setState(() {
          citySelectorProvider.change();
          print([_opened, citySelectorProvider.opened]);
        });
      },
      child: Container(
        width: 56.0,
        height: 56.0,
        decoration: orangeBoxDecoration(),
        child: _opened ?
            Icon(OotmIconPack.close,size: 24.0,color: Colors.white): 
            Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(DateFormat('dd.MM').format(cityProvider.chosenCity.eventDate), style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),),
        Text(cityProvider.chosenCity.shortName, style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
        ),
      ],
            ),
      ),
    );
  }
}



class CitySelector with ChangeNotifier {
  bool opened = false;

  void change() {
    opened = !opened;
    // print(opened);
    notifyListeners();
  }
}

class ChosenCity extends ChangeNotifier {
  City _chosenCity = CitySet.cities[0];

  City get chosenCity => _chosenCity;
  set chosenCity(City value) {
    _chosenCity = value;
    notifyListeners();
    print(_chosenCity.hiveName);
  }
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

class OotmEndDrawer extends StatelessWidget {
  final double endDrawerAnimationOffset;
  const OotmEndDrawer({Key key, this.endDrawerAnimationOffset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final endDrawerProvider = Provider.of<EndDrawerProvider>(context);
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width * this.endDrawerAnimationOffset.abs(),
        color: Color(0xFF333333),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: ListTile(
                title: Text(
                  "Ustawienia",
                  style: TextStyle(color: Colors.white, fontSize: 23.0, fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                  icon: Icon(OotmIconPack.close, color: Colors.white),
                  onPressed: () => endDrawerProvider.change(),
                  // ,
                ),
              ),
            ),
            // ListTile(
            //   leading: Icon(
            //     OotmIconPack.sbar_notifications, color: Colors.white,
            //   ),
            //   title: Text(
            //     "Powiadomienia",
            //     style: TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold),
            //   ),
            // ),
            ListTile(
              leading: Icon(OotmIconPack.menu_onboarding,color: Colors.white,),
              title: Text(
                "Samouczek",
                style: TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: Icon(OotmIconPack.menu_help_feedback, color: Colors.white,),
              title: Text(
                "Pomoc i feedback",
                style: TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (BuildContext context) {
                    return HelpFeedbackRoute();
                  })
                );
              },
            ),
            ListTile(
              leading: Icon(OotmIconPack.menu_privacy, color: Colors.white,),
              title: Text(
                "Dane i prywatność",
                style: TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (BuildContext context) {
                    return DataPrivacyRoute();
                  })
                );
              },
            ),
          ],
        ),),
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
      // switch (settings.name) {
      //   case '/city':
      //     builder = (BuildContext context) => SelectCity();
      //     break;
      //   }
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
        // maintainState: true,
        builder: builder,
        settings: settings,
        );
      }
  );
}