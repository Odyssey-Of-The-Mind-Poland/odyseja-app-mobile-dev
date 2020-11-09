import 'package:flutter/material.dart';
import 'package:ootm_app/models/app_model.dart';
import 'package:ootm_app/models/city_data_model.dart';
import 'package:provider/provider.dart';

BuildContext _mainContext;
void init(BuildContext c) => _mainContext = c;
class BaseCommand {
  AppModel appModel = _mainContext.read();
  CityDataModel cityDataModel = _mainContext.read();
}