import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// TODO: default city selection and persitance. 
class CityPage extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
      final chsnProvider = Provider.of<ChosenCity>(context);
      List<String> _citiesValues = [
        'Wrocław',
        'Poznań',
        'Katowice',
        'Warszawa',
        'Łódź',
        'Gdańsk',
        'Gdynia_Sobota',
        'Gdynia_Niedziela'
      ];
      List<String> _citiesNames = [
        'Wrocław',
        'Poznań',
        'Katowice',
        'Warszawa',
        'Łódź',
        'Gdańsk',
        'Gdynia Sobota',
        'Gdynia Niedziela'
      ];
      List<Widget> _widgets = [];
      for (var i =0; i< _citiesNames.length; i++) {
        _widgets.add(new Row(
          children: [
            Radio(
              value: _citiesValues[i],
              groupValue: chsnProvider.chosenCity,
              onChanged: (value) => chsnProvider.chosenCity = value,
            ),
            Text(_citiesNames[i]),
          ]
        ));
      }
      return Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [..._widgets]
        )
      );
    }
}

class ChosenCity extends ChangeNotifier {
  String _chosenCity = 'Wrocław';

  String get chosenCity => _chosenCity;
  set chosenCity(String value) {
    _chosenCity = value;
    notifyListeners();
  }
}