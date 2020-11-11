import 'package:ootm_app/commands/check_date_command.dart';
import 'package:ootm_app/commands/update_Command.dart';
import 'package:ootm_app/data/city.dart';
import 'base_command.dart';

class RunSequenceCommand extends BaseCommand {


  Future<void> run() async {
    assert(true, print("run()"));
    CitySet.generate();
    await CheckDateCommand().checkDate();
    await appModel.loadDatabase();
    // await UpdateCommand().runUpdate();
    await cityDataModel.loadChosenCity(appModel.savedCity);
    await cityDataModel.openCityDatabase();
    await cityDataModel.loadCityDatabase();
    // process favouristes
    favModel.favList = cityDataModel.pfGroups;
  }
  
}
