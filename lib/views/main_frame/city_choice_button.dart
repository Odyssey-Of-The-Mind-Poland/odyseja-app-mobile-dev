import 'package:flutter/material.dart';
import 'package:ootm_app/data/ootm_icon_pack.dart';
import 'package:ootm_app/models/city_data_model.dart';
import 'package:ootm_app/widgets/box_decoration.dart';
import 'package:provider/provider.dart';
import 'main_frame.dart';

class CityButton extends StatefulWidget {
  CityButton({Key key}) : super(key: key);

  @override
  _CityButtonState createState() => _CityButtonState();
}

class _CityButtonState extends State<CityButton> {
  // bool _opened = false;

  @override
  Widget build(BuildContext context) {
    final citySelectorProvider = Provider.of<CitySelector>(context);
    // final cityProvider = Provider.of<ChosenCity>(context);
    final cityProvider = Provider.of<CityDataModel>(context);
    bool _opened = citySelectorProvider.opened;
    return Container(
      width: 56.0,
      height: 56.0,
      decoration: orangeBoxDecoration(),
      child: RawMaterialButton(
        onPressed: () {
          setState(() {
            citySelectorProvider.change();
            // print([_opened, citySelectorProvider.opened]);
          });
        },
        child: _opened
            ? Icon(OotmIconPack.close, size: 24.0, color: Colors.white)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Text(DateFormat('dd.MM').format(cityProvider.chosenCity.eventDate), style: TextStyle(
                  Text(
                    cityProvider.chosenCity.shortName[0],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    cityProvider.chosenCity.shortName[1],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
