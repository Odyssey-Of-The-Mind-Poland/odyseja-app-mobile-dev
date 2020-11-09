import 'package:flutter/material.dart';
import 'package:ootm_app/views/favourites/favourites.dart';
import 'package:ootm_app/views/home/home.dart';
import 'package:ootm_app/views/info/info.dart';
import 'package:ootm_app/views/schedule/schedule.dart';

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