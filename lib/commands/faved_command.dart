import 'package:ootm_app/commands/base_command.dart';
import 'package:ootm_app/data/performance.dart';

class FavedCommand extends BaseCommand {
  
  Future<void> save(Performance performance) async {
    await cityDataModel.updatePerformanceList(performance);
    favModel.favList = cityDataModel.pfGroups;
  }
}