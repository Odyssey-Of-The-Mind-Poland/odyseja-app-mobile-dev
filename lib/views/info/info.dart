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
    for (int i = 0; i < 9; i++) {
      _infoTilesAll.add(new InfoTile(
        label: info[i].infName,
        index: i,
        imageName: "assets/graphics/Info 1.png",
      ));
    }
    List<Widget> _infoTilesTeams = [];
    for (int i = 9; i < 18; i++) {
      _infoTilesTeams.add(new InfoTile(
        label: info[i].infName,
        index: i,
        imageName: "assets/graphics/Info 3.png",
      ));
    }
    List<Widget> _infoTilesThanks = [];
    for (int i = 18; i < 21; i++) {
      _infoTilesThanks.add(new InfoTile(
        label: info[i].infName,
        index: i,
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
