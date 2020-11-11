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
import 'views/main_frame/end_drawer.dart';
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
        ChangeNotifierProvider(create: (c) => EndDrawerProvider()),
        ],
      child: Builder(builder: (context) {
        Commands.init(context);
        return MaterialApp(
          // debugShowMaterialGrid: true,
          title: 'OotmApp',
          theme: defaultTheme(),
          home: MainFrame(),
        );
      })
    );
  }
}