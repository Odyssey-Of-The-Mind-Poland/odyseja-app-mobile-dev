import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

enum DateStatus {
  preEvent,
  preRegio,
  regio,
  preFinals,
  finals,
  postEvent
  
}


class AppModel extends ChangeNotifier {
  DateStatus dateStatus;
  bool isRegioData = false;
  bool isFinalsData = false;
  Box mainBox;
  String savedCity;
 

  Future<void> loadDatabase() async {
    mainBox = await Hive.openBox("mainBox");
    isRegioData = mainBox.get("isRegioData", defaultValue: false);
    isFinalsData = mainBox.get("isFinalsData", defaultValue: false);
    savedCity = mainBox.get("chosenCity", defaultValue: "warszawa");
  }
}