/*Core classes of the OotmApp, responsible for app navigation and navBar.
*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

import 'data/info.dart';
import 'data/performance.dart';
import 'data/performance_group.dart';
import 'models/fav_model.dart';
import 'views/main_frame/main_frame.dart';
import 'themes.dart';
import 'models/app_model.dart';
import 'models/city_data_model.dart';
import 'commands/base_command.dart' as Commands;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    Hive.initFlutter();
  } else {
    final documentsDir = await getApplicationDocumentsDirectory();
    Hive.init(documentsDir.path);
  }
  Hive.registerAdapter(PerformanceAdapter());
  Hive.registerAdapter(PerformanceGroupAdapter());
  Hive.registerAdapter(InfoAdapter());
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext _) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c) => CitySelector()),
        ChangeNotifierProvider(create: (c) => AppModel()),
        ChangeNotifierProvider(create: (c) => CityDataModel()),
        ChangeNotifierProvider(create: (c) => FavModel()),
        // ChangeNotifierProvider(create: (c) => ChosenCityModel()),
        // ChangeNotifierProvider(builder: (context) => EndDrawerProvider()),
        ],
      child: Builder(builder: (context) {
        Commands.init(context);
        return MaterialApp(
          // debugShowMaterialGrid: true,
          title: 'OotmApp',
          theme: defaultTheme(),
          home: WillPopScope(
            onWillPop: () async => await Navigator.of(context).maybePop(),
            child: MainFrameWindow()
          ),
        );
      }
    ));
  }
}


// class MainFrame extends StatefulWidget {

//   const MainFrame({Key key}) : super(key: key);
//   @override
//   _MainFrameState createState() => _MainFrameState();
// }

// class _MainFrameState extends State<MainFrame> with SingleTickerProviderStateMixin{
//   AnimationController _controller;
//   Animation<Offset> _offsetAnimation;
//   static const double endDrawerAnimationOffset = -0.70;
//   // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 500),
//       vsync: this,
//     );
//     _offsetAnimation = Tween<Offset>(
//       begin: Offset.zero,
//       end: const Offset(endDrawerAnimationOffset, 0.0)
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.linear,
//     ));
//   }
//   @override
//   void dispose() {
//     _controller.dispose();
//     // Hive.close();
//     super.dispose();
//   }
  
  
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.topRight,
//       children: <Widget>[
//         OotmEndDrawer(
//           endDrawerAnimationOffset: endDrawerAnimationOffset,
//         ),
//         Consumer<EndDrawerProvider>(
//           builder: (context, endDrawerProvider, child) {
//             if(endDrawerProvider.opened) {
//               _controller.forward();
//             } else {
//               _controller.reverse();
//             }
//             return SlideTransition(
//               position: _offsetAnimation,
//               child: GestureDetector(
//                 onPanUpdate: (details) {
//                   if (details.delta.dx > 0) {
//                     // swiping in right direction
//                     if (endDrawerProvider.opened) {
//                       endDrawerProvider.change();
//                     }
//                   }
//                 },
//                 onTap: endDrawerProvider.opened ? 
//                 () => endDrawerProvider.change() : null,
//                 child: AbsorbPointer(
//                   absorbing: endDrawerProvider.opened,
                  
//                   child: MainFrameWindow()
//                 ),
//               ),
//             );
//           }
//         )
//       ],
//     ); 
//   }
// }

// class ChosenCity extends ChangeNotifier {
//   static final Box box = Hive.box("mainBox");
//   City _chosenCity;
//   City get chosenCity => _chosenCity;
//   set chosenCity(City value) {
//     _chosenCity = value;
//     notifyListeners();
//     box.put("savedCity", _chosenCity.hiveName);
//     print(_chosenCity.hiveName);
//   }
// }