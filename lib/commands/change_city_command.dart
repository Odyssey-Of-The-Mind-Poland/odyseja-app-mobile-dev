import 'package:ootm_app/data/city.dart';
import 'base_command.dart';

class ChangeCityCommand extends BaseCommand {
  Future<void> change(City newCity) async {
    await cityDataModel.closeCityDatabase();
    cityDataModel.chosenCity = newCity;
    await cityDataModel.openCityDatabase();
    await cityDataModel.loadCityDatabase();
    favModel.favList = cityDataModel.pfGroups;
  }
}
