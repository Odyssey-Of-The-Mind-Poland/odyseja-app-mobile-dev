import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CityPage extends StatelessWidget {
  // TODO: default city selection and persitance. 
  // int chosencity = 0;
  // void changeValue(int value) => setState(() => chosencity = value);
  @override
    Widget build(BuildContext context) {
      final chsnProvider = Provider.of<ChosenCity>(context);
      // return Text("Miasta");
      return Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                  value: 'Wrocław',
                  groupValue: chsnProvider.chosenCity,
                  onChanged: (value) => chsnProvider.chosenCity = value,
                ),
                Text('Wrocław'),
              ]
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 'Poznań',
                  groupValue: chsnProvider.chosenCity,
                  onChanged: (value) => chsnProvider.chosenCity = value,
                ),
                Text('Poznań'),
              ],
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 'Katowice',
                  groupValue: chsnProvider.chosenCity,
                  onChanged: (value) => chsnProvider.chosenCity = value,
                ),
                Text('Katowice'),
              ],
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 'Warszawa',
                  groupValue: chsnProvider.chosenCity,
                  onChanged: (value) => chsnProvider.chosenCity = value,
                ),
                Text('Warszawa'),
              ],
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 'Łódź',
                  groupValue: chsnProvider.chosenCity,
                  onChanged: (value) => chsnProvider.chosenCity = value,
                ),
                Text('Łódź'),
              ],
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 'Gdańsk',
                  groupValue: chsnProvider.chosenCity,
                  onChanged: (value) => chsnProvider.chosenCity = value,
                ),
                Text('Gdańsk'),
              ],
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 'Gdynia_Sobota',
                  groupValue: chsnProvider.chosenCity,
                  onChanged: (value) => chsnProvider.chosenCity = value,
                ),
                Text('Gdynia Sobota'),
              ],
            ),
            Row(
              children: <Widget>[
                Radio(
                  value: 'Gdynia_Niedziela',
                  groupValue: chsnProvider.chosenCity,
                  onChanged: (value) => chsnProvider.chosenCity = value,
                ),
                Text('Gdynia Niedziela'),
              ],
            ),
          ]
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