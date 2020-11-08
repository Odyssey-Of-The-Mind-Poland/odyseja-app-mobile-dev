import 'package:ootm_app/commands/check_date_command.dart';
import 'package:ootm_app/commands/update_Command.dart';
import 'base_command.dart';

class RunSequence extends BaseCommand {


  void run() async {
    await CheckDateCommand().checkDate();
    await appModel.loadDatabase();
    await UpdateCommand().runUpdate();
    // UpdateCityChoice
  }
  
}
