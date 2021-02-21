import 'package:flutter/material.dart';
import 'package:ootm_app/commands/run_sequence_command.dart';
import 'package:ootm_app/data/ootm_icon_pack.dart';
import 'package:ootm_app/views/favourites/favourites.dart';
import 'package:ootm_app/views/home/home.dart';
import 'package:ootm_app/views/info/info.dart';
import 'package:ootm_app/views/main_frame/bottom_bar.dart';
import 'package:ootm_app/views/main_frame/city_button_overlay.dart';
import 'package:ootm_app/views/schedule/schedule.dart';
import 'package:provider/provider.dart';
import 'city_buttons_controller.dart';
import 'end_drawer.dart';

// Add a loading screen, which would allow async data loading functions to finish
// one per screen vs one for the whole app
class MainFrame extends StatefulWidget {
  const MainFrame({Key key}) : super(key: key);
  @override
  _MainFrameState createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  static const double endDrawerAnimationOffset = -0.70;
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(endDrawerAnimationOffset, 0.0))
        .animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
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
          if (endDrawerProvider.opened) {
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
              onTap: endDrawerProvider.opened
                  ? () => endDrawerProvider.change()
                  : null,
              child: AbsorbPointer(
                  absorbing: endDrawerProvider.opened, child: DataScaffold()),
            ),
          );
        })
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
  Future<bool> run() async {
    await RunSequenceCommand().run();
    // print("done");
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // final cityProvider = Provider.of<AppModel>(context);
    return FutureBuilder(
        future: run(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError)
              return Text("${snapshot.error}");
            else
              return MainFrame();
          }
          return Center(
              child: Container(
                  color: Theme.of(context).canvasColor,
                  child: Center(child: CircularProgressIndicator())));
        });
  }
}

class DataScaffold extends StatefulWidget {
  DataScaffold({Key key}) : super(key: key);

  @override
  _DataScaffoldState createState() => _DataScaffoldState();
}

class _DataScaffoldState extends State<DataScaffold> {
  static final _navigatorKey = GlobalKey<NavigatorState>();
  static final _infoKey = GlobalKey<NavigatorState>();
  static final _scheduleKey = GlobalKey<NavigatorState>();
  int _currentIndex = 0;

  final pages = [
    MyPage(
        key: Key('info'),
        name: '1',
        builder: (context) => Navigator(
              key: _infoKey,
              onGenerateRoute: (settings) => MaterialPageRoute(
                settings: settings,
                maintainState: true,
                builder: (context) => InfoPage(),
              ),
            )),
    MyPage(
        key: Key('schedule'),
        name: '2',
        builder: (context) => Navigator(
              key: _scheduleKey,
              onGenerateRoute: (settings) => MaterialPageRoute(
                  settings: settings,
                  maintainState: true,
                  builder: (context) => ScheduleMenuRoute()),
            )),
    MyPage(
        key: Key('favourites'),
        name: '3',
        builder: (context) => FavouritesPage()),
    MyPage(key: Key('home'), name: '0', builder: (context) => HomePage()),
  ];

  Future<bool> onWillPop() async {
    return !await _infoKey.currentState.maybePop() ||
        !await _scheduleKey.currentState.maybePop();
  }

  void _selectedTab(int index) async {
    if (index != _currentIndex) {
      setState(() {
        var element =
            pages.firstWhere((element) => element.name == index.toString());
        this.pages.remove(element);
        this.pages.add(element);
      });
      _currentIndex = index;
    } else if (index == 1) {
      await _infoKey.currentState.maybePop();
    } else if (index == 2) {
      await _scheduleKey.currentState.maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Provider.of<CityButtonsController>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Stack(
        children: <Widget>[
          WillPopScope(
              onWillPop: () => onWillPop(),
              child: Navigator(
                key: _navigatorKey,
                onPopPage: (route, result) => false,
                pages: List.of(pages),
              )),
          CityButtonOverlay(),
        ],
      ),
      bottomNavigationBar: OotmBottomAppBar(
        onTabSelected: (val) {
          if (cs.opened) {
            cs.change();
          }
          _selectedTab(val);
        },
        height: 56.0,
        iconSize: 24.0,
        selectedColor: Colors.orange,
        items: [
          BottomAppBarItem(iconData: OotmIconPack.navbar_home, isActive: true),
          BottomAppBarItem(iconData: OotmIconPack.navbar_info, isActive: true),
          BottomAppBarItem(
              iconData: OotmIconPack.navbar_schedule, isActive: true),
          BottomAppBarItem(iconData: OotmIconPack.favs_outline, isActive: true),
        ],
      ),
    );
  }
}

class MyPage<T> extends Page<T> {
  const MyPage({
    LocalKey key,
    @required String name,
    @required this.builder,
  }) : super(key: key, name: name);

  final WidgetBuilder builder;

  @override
  Route<T> createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: builder,
    );
  }

  @override
  String toString() => '$name';
}
