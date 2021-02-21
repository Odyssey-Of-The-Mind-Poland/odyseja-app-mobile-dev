import 'package:flutter/widgets.dart';

class CityButtonsController with ChangeNotifier {
  bool opened = false;

  void change() {
    opened = !opened;
    notifyListeners();
  }
}
