import 'package:flutter/material.dart';
import 'package:ootm_app/models/city_data_model.dart';
import 'package:ootm_app/views/info/info_tile.dart';
import 'package:ootm_app/widgets/appbar.dart';
import 'package:provider/provider.dart';
import '../../data/info.dart';
import 'info_grid.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    final cityProvider = Provider.of<CityDataModel>(context);
    List<Info> info = cityProvider.infoList;
    List<Widget> _infoTilesAll = [];
    for (Info _infoItem in info.sublist(0, 9)) {
      _infoTilesAll.add(new InfoTile(
        label: _infoItem.infName,
        data: _infoItem.infoText,
        imageName: "assets/graphics/Info 1.png",
      ));
    }
    List<Widget> _infoTilesTeams = [];
    for (Info _infoItem in info.sublist(9, 18)) {
      _infoTilesTeams.add(new InfoTile(
        label: _infoItem.infName,
        data: _infoItem.infoText,
        imageName: "assets/graphics/Info 3.png",
      ));
    }
    List<Widget> _infoTilesThanks = [];
    for (Info _infoItem in info.sublist(18, 21)) {
      _infoTilesThanks.add(new InfoTile(
        label: _infoItem.infName,
        data: _infoItem.infoText,
        imageName: "assets/graphics/Info 2.png",
      ));
    }

    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBarOotm(
          leadingIcon: false,
          title: Text("Info"),
          bottom: TabBar(
              indicatorColor: Color(0xFFFF951A),
              labelPadding: EdgeInsets.only(bottom: 4.0),
              tabs: [
                Text("Dla wszystkich"),
                Text("Dla drużyn"),
                Text("Podziękowania"),
              ]),
        ),
        body: TabBarView(
          children: <Widget>[
            InfoGridView(children: <Widget>[..._infoTilesAll]),
            InfoGridView(children: <Widget>[..._infoTilesTeams]),
            InfoGridView(children: <Widget>[..._infoTilesThanks]),
          ],
        ),
      ),
    );
  }
}
