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
  runApp(CentralProvider());
}

// final keyScaffold = new GlobalKey<ScaffoldState>();
// final key = new GlobalKey<_MainFrameState>();



class CentralProvider extends StatelessWidget {
  const CentralProvider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Box box = Hive.box("cityAgnostic");
    CitySet.generate();

    if (box.get("firstRun", defaultValue: true) == true) {
      print("firstRun");
      firstRun();
    } else {
      print("defaultRun");
      defaultRun();
    }


    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context) => CitySelector()),
        ChangeNotifierProvider(builder: (context) => ChosenCity()),
        ChangeNotifierProvider(builder: (context) => EndDrawerProvider()),
        ],
      child: MyApp()
    );
  }
}

void showCitySelectionDialog() {
}



class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cityProvider = Provider.of<ChosenCity>(context);
    Box box = Hive.box("cityAgnostic");
    DateTime time = DateTime.now();
    DateTime today = DateTime(time.year, time.month, time.day);
    List<City> cities = CitySet.cities;
    String savedHiveName = box.get("savedCity");
    City savedCity;

    if (savedHiveName != null) {
      savedCity = cities.firstWhere((city) => city.hiveName == savedHiveName);
    } else {
      // TODO cities[0] assert that cities[0] has data, which might not be the case. ``
      savedCity = cities[0];
    }
    cityProvider.chosenCity = savedCity;
    
    for (City city in cities) {
      if (today.isAfter(city.eventDate)) {
        if (today.isAfter(savedCity.eventDate)) {
          showCitySelectionDialog();
          print("time for city change!");
          break;
        }
      }
    }

    
    // cityProvider.chosenCity = CitySet.cities[5];
    // Future<void> loadCityBox() async {
    //   await Hive.openBox("Warszawa");
    //   // await Hive.openBox("Katowice");
    // }

    // loadCityBox();

    return MaterialApp(
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
  Box box = Hive.box("cityAgnostic");

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
  static const _routeList = [
    '/',
    '/info',
    '/schedule',
    '/favs',
    ];
  // bool visibility = false;
  void _selectedTab(int index) {
    setState(() {
    });
    _navigatorKey.currentState.pushNamed(_routeList[index]);
  }
  
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
              bool isData;
              for (City city in cities) {
                // isData = box.get(city.hiveName, defaultValue: false);
                isData = box.get(city.hiveName);
                cityButtons.add(new SlideTransition(
                  position: new Tween<Offset>(
                    begin: Offset(0.0, 1.0),
                    end: Offset(0.0, _offset), 
                  ).animate(new CurvedAnimation(
                    curve: Curves.easeInOut,
                    parent: _controller,
                  )),
                  child: RawMaterialButton(
                    onPressed: isData ? () {
                      cityProvider.chosenCity = city;
                      citySelector.change();
                    // } : Scaffold.of(context).showSnackBar(SnackBar(content: Text("Prosimy uzbroić się w cierpliwość :)"))),
                    } : null,
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  city.fullName,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (!isData) Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Icon(OotmIconPack.locked, size: 14.0, color: Colors.white,),
                                ), 
                              ],
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
      // body: Container(),
      // bottomNavigationBar: OotmNavBar(
      //   navigatorKey: _navigatorKey,
      // )
      // appBar: AppBar(title: Text("Hello!"),),
      bottomNavigationBar: OotmBottomAppBar(
        onTabSelected: _selectedTab,
        height: 56.0,
        iconSize: 24.0,
        selectedColor: Colors.orange,
        items: [
          BottomAppBarItem(iconData: OotmIconPack.navbar_home),
          BottomAppBarItem(iconData: OotmIconPack.navbar_info),
          BottomAppBarItem(iconData: OotmIconPack.navbar_schedule),
          BottomAppBarItem(iconData: OotmIconPack.favs_outline),
        ],
      ),
      // primary: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Transform.translate(
        offset: Offset(0.0, 20.0),
        child: CityButton()
        ),
    );
  }
}

class BottomAppBarItem {
  BottomAppBarItem({this.iconData});
  IconData iconData;
}

class OotmBottomAppBar extends StatefulWidget {
  final List<BottomAppBarItem> items;
  final ValueChanged<int> onTabSelected;
  final Color selectedColor;
  final double height;
  final Color color;
  final double iconSize;
  OotmBottomAppBar({
    Key key,
    this.items,
    this.onTabSelected,
    this.selectedColor,
    this.height,
    this.color,
    this.iconSize
    }) : super(key: key);

  @override
  _OotmBottomAppBarState createState() => _OotmBottomAppBarState();
}

class _OotmBottomAppBarState extends State<OotmBottomAppBar> {
  int _selectedIndex = 0;

  _updateIndex(int index) {
    widget.onTabSelected(index);
    // setState(() {
      _selectedIndex = index;
    // });
  }
  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(widget.items.length, (int index) {
    return _buildTabItem(
      item: widget.items[index],
      index: index,
      onPressed: _updateIndex,
    );
  });
  items.insert(items.length >> 1, _buildMiddleTabItem());

  return BottomAppBar(
        child: Stack(
          // alignment: Alignment.,
          children: <Widget>[
            navBarBackground(),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: items,
            ),
          ],
        ),
        // shape: CircularNotchedRectangle(),
        // color: Colors.white
        color: Colors.transparent
  );
  }

  Widget _buildTabItem({
    BottomAppBarItem item,
    int index,
    ValueChanged<int> onPressed,
    }) {
    Color color = _selectedIndex == index ? widget.selectedColor : widget.color;
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onPressed(index),
            child: Icon(item.iconData, color: color, size: widget.iconSize),
          ),
        ),
      ),
    );
  }

  Widget _buildMiddleTabItem() {
    return Expanded(child: SizedBox());
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
    notifyListeners();
  }
}

class ChosenCity extends ChangeNotifier {
  static final Box box = Hive.box("cityAgnostic");
  City _chosenCity;

  City get chosenCity => _chosenCity;
  set chosenCity(City value) {
    _chosenCity = value;
    notifyListeners();
    box.put("savedCity", _chosenCity.hiveName);
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