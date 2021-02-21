import 'dart:convert';
import 'package:ootm_app/data/info.dart';
import 'package:ootm_app/data/performance.dart';
import 'package:flutter/services.dart';

import 'package:ootm_app/commands/check_date_command.dart';
// import 'package:ootm_app/commands/update_Command.dart';
import 'package:ootm_app/data/city.dart';
import 'base_command.dart';

class RunSequenceCommand extends BaseCommand {
  Future<String> loadAsset(String fileName) async {
    return await rootBundle.loadString('assets/$fileName');
  }

  Future<void> loadOfflineJson() async {
    List<City> cities = CitySet.cities;
    List<Performance> pfList = [];
    List<Info> infoList = [];

    String scheduleData = await loadAsset("getAll.json");
    String infoData = await loadAsset("getInfo.json");

    pfList = scheduleToList(scheduleData);
    infoList = infoToList(infoData);

    for (City city in cities) {
      cityDataModel.chosenCity = city;

      await cityDataModel.openCityDatabase();

      cityDataModel.pfList =
          pfList.where((e) => e.city == city.hiveName).toList();
      if (cityDataModel.pfList.isNotEmpty) await cityDataModel.storeSchedule();

      cityDataModel.infoList =
          infoList.where((e) => e.city == city.hiveName).toList();
      if (cityDataModel.infoList.isNotEmpty) await cityDataModel.storeInfo();

      await cityDataModel.closeCityDatabase();
    }
  }

  Future<void> run() async {
    CitySet.generate();
    await CheckDateCommand().checkDate();
    await appModel.loadDatabase();
    // await UpdateCommand().runUpdate();
    await loadOfflineJson();
    await cityDataModel.loadChosenCity(appModel.savedCity);
    await cityDataModel.openCityDatabase();
    await cityDataModel.loadCityDatabase();
    // process favouristes
    favModel.favList = cityDataModel.pfGroups;
  }
}

List<Performance> scheduleToList(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Performance>((json) => Performance.fromJson(json)).toList();
}

List<Info> infoToList(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Info>((json) => Info.fromJson(json)).toList();
}
