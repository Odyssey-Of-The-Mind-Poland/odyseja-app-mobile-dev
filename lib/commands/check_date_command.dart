import 'package:ootm_app/commands/base_command.dart';
import 'package:ootm_app/data/city.dart';
import 'package:ootm_app/models/app_model.dart';

class CheckDateCommand extends BaseCommand {
  DateTime regional = CitySet.cities.first.eventDate;
  DateTime finals = CitySet.cities.last.eventDate;
  DateTime today = DateTime.now();
  Duration startUpdates = Duration(days: 14);
  Duration stopUpdates = Duration(days: 1);

  Future<void> checkDate() async {
    if (today.isBefore(regional.subtract(startUpdates)))
      appModel.dateStatus = DateStatus.preEvent;
    else if (today.isBefore(regional.subtract(stopUpdates)))
      appModel.dateStatus = DateStatus.preRegio;
    else if (today.isBefore(finals.subtract(startUpdates)))
      appModel.dateStatus = DateStatus.regio;
    else if (today.isBefore(finals.subtract(stopUpdates)))
      appModel.dateStatus = DateStatus.preFinals;
    else if (today.isBefore(CitySet.cities.last.eventDate.add(Duration(days: 2))))
      appModel.dateStatus = DateStatus.finals;
    else
      appModel.dateStatus = DateStatus.postEvent;
  }
}
