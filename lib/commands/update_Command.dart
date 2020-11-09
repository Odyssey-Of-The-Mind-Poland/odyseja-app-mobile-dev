import 'package:ootm_app/data/city.dart';
import 'package:ootm_app/models/app_model.dart';
import 'package:ootm_app/services/api_endpoints.dart';
import '../services/data_service.dart';

import 'base_command.dart';

class UpdateCommand extends BaseCommand {
  List<City> cities = CitySet.cities;
  bool isUpdateSuccess;
  
  
  Future<void> runUpdate() async {
    switch (appModel.dateStatus) {
      case DateStatus.preEvent:
        break;
      case DateStatus.preRegio:
        isUpdateSuccess = await _download(cities.sublist(0, cities.length - 1));
        break;
      case DateStatus.regio:
        if (appModel.isRegioData == false)
          isUpdateSuccess = await _download(cities.sublist(0, cities.length - 1));
        break;
      case DateStatus.preFinals:
        if (appModel.isRegioData == false)
          isUpdateSuccess = await _download(cities);
          else
          isUpdateSuccess = await _download([cities.last]);
        break;
      case DateStatus.finals:
        if (appModel.isRegioData == false)
          isUpdateSuccess = await _download(cities.sublist(0, cities.length - 1));
        if (appModel.isFinalsData == false)
          isUpdateSuccess = await _download([cities.last]);
        break;
      case DateStatus.postEvent:
        if (appModel.isRegioData == false)
          isUpdateSuccess = await _download(cities.sublist(0, cities.length - 1));
        if (appModel.isFinalsData == false)
          isUpdateSuccess = await _download([cities.last]);
        break;
    }
  }


  Future<bool> _download(List cities) async {
    for (City city in cities) {
      cityDataModel.chosenCity = city;
      assert(true, print("city.shortName[0]"));
      cityDataModel.openCityDatabase();

      String scheduleData = await DataService().downloadData(urlSchedule(city.apiName));
      if (scheduleData.isEmpty)
        return false;
      
      cityDataModel.scheduleToList(scheduleData);
      cityDataModel.storeSchedule();

      String infoData = await DataService().downloadData(urlInfo(city.apiName));
      if (infoData.isEmpty)
        return false;
      
      cityDataModel.infoToList(infoData);
      cityDataModel.storeInfo();

      cityDataModel.closeCityDatabase();
    }
  return true;
  }
}