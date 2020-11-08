import '../data/city.dart';
import 'package:hive/hive.dart';


enum DateStatus {
  preEvent,
  preRegio,
  regio,
  preFinals,
  finals,
  postEvent
  
}


class AppModel {
  DateStatus dateStatus;
  String chosenCityName;
  bool isRegioData;
  bool isFinalsData;
  Box mainBox;
 

  Future<void> loadDatabase() async {
    mainBox = await Hive.openBox("mainBox");
    isRegioData = mainBox.get("isRegioData", defaultValue: false);
    isFinalsData = mainBox.get("isFinalsData", defaultValue: false);
  }


  Future<void> loadChosenCity() async {
    mainBox = await Hive.openBox("mainBox");
    chosenCityName = mainBox.get("chosenCity", defaultValue: "poznan");
  }

}