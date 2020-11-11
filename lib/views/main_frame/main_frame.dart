import 'package:flutter/material.dart';
import 'package:ootm_app/commands/change_city_command.dart';
import 'package:ootm_app/commands/run_sequence_command.dart';
import 'package:ootm_app/data/city.dart';
import 'package:ootm_app/data/ootm_icon_pack.dart';
import 'package:ootm_app/models/city_data_model.dart';
import 'package:ootm_app/views/main_frame/bottom_bar.dart';
import 'package:ootm_app/widgets/box_decoration.dart';
import 'package:provider/provider.dart';

import '../../router.dart';
import 'end_drawer.dart';



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
    // Hive.close();
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

class _MainFrameWindowState extends State<MainFrameWindow> {
  bool isLoading = true;


  Future<bool> run() async {
    await RunSequenceCommand().run();
    print("done");
    return true;
  }


  @override
  Widget build(BuildContext context) {
    // final cityProvider = Provider.of<AppModel>(context);
    return FutureBuilder(
      future: run(),
      initialData: Text("Lol, brak danych"),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return DataScaffold();
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      }
    );
  }
}

class DataScaffold extends StatefulWidget {
  DataScaffold({Key key}) : super(key: key);

  @override
  _DataScaffoldState createState() => _DataScaffoldState();
}

class _DataScaffoldState extends State<DataScaffold> with SingleTickerProviderStateMixin {
  
  
  final _navigatorKey = GlobalKey<NavigatorState>();
  Animation<double> _animation;
  Animation<double> _fadeAnimation;
  AnimationController _controller;
  bool _visibility = false;
  // Box box = Hive.box("mainBox");

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
        // setState(() {
        _visibility = false;
        // });
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

  // int _selectedRoute = 0; 
  void _selectedTab(int index) {
    // setState(() {
    // });
    // _selectedRoute = index;
    _navigatorKey.currentState.pushNamed(_routeList[index]);
  }
  @override
  Widget build(BuildContext context) {
  // final cityProvider = Provider.of<ChosenCity>(context);
  final cityProvider = Provider.of<CityDataModel>(context);
    return Scaffold(
      extendBody: true,
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
              // double _offset = -0.25;
              double _offset = -1.4166;
              List<City> cities = CitySet.cities.reversed.toList();
              bool isData = true;
              for (City city in cities) {
                // isData = box.get(city.hiveName, defaultValue: false);
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
                      // cityProvider.chosenCity = city;
                      ChangeCityCommand().change(city);
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
      // bottomNavigationBar: OotmNavBar(
      //   navigatorKey: _navigatorKey,
      // ),
      bottomNavigationBar: OotmBottomAppBar(
        onTabSelected: _selectedTab,
        height: 56.0,
        iconSize: 24.0,
        selectedColor: Colors.orange,
        items: [
          BottomAppBarItem(iconData: OotmIconPack.navbar_home, isActive: true),
          BottomAppBarItem(iconData: OotmIconPack.navbar_info, isActive: true),
          BottomAppBarItem(iconData: OotmIconPack.navbar_schedule, isActive: true),
          BottomAppBarItem(iconData: OotmIconPack.favs_outline, isActive: true),
        ],
      ),
      // primary: true,
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