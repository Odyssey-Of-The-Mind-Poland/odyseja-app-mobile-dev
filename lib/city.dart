import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data.dart';

class SelectCity extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
      final chsnProvider = Provider.of<ChosenCity>(context);
      List<String> _citiesValues = [
        'Wrocław',
        'Warszawa',
        'Poznań',
        'Katowice',
        'Łódź',
        'Gdańsk',
        'Gdynia',
        ];
      List<String> _citiesNames = [
        "Eliminacje Regionalne - Wrocław",
        "Eliminacje Regionalne - Warszawa",
        "Eliminacje Regionalne - Poznań",
        "Eliminacje Regionalne - Katowice",
        "Eliminacje Regionalne - Łódź",
        "Eliminacje Regionalne - Gdańsk",
        "Finał Ogólnopolski - Gdynia",
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
        // padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            // ..._widgets,
          Expanded(child: ModalBarrier(color: Colors.red.withOpacity(0.5),)),
            ],
          

        )
      );
    }
}

class ChosenCity extends ChangeNotifier {
  City _chosenCity = CitySet.cities[0];

  City get chosenCity => _chosenCity;
  set chosenCity(City value) {
    _chosenCity = value;
    notifyListeners();
    print(_chosenCity.hiveName);
  }
}