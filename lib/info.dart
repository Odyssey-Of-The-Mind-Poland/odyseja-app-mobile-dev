import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
// import 'city.dart';
import 'data.dart';
import 'common_widgets.dart';
import 'package:hive/hive.dart';
import 'main.dart';


class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    final cityProvider = Provider.of<ChosenCity>(context);
    print("info");
    return FutureBuilder(
      future: Hive.openBox(cityProvider.chosenCity.hiveName),
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if (_snapshot.hasData) {
          List<Info> info = _snapshot.data.get("info").cast<Info>();
          
          List<Widget> _infoTilesAll = new List<Widget>();
          for (Info _infoItem in info.sublist(0,9)) {
            _infoTilesAll.add(new InfoTile(
              label: _infoItem.infName,
              data: _infoItem.infoText,
              imageName: "assets/graphics/Info 1.png",

            ));
          }
          List<Widget> _infoTilesTeams = new List<Widget>();
          for (Info _infoItem in info.sublist(9,18)) {
            _infoTilesTeams.add(new InfoTile(
              label: _infoItem.infName,
              data: _infoItem.infoText,
              imageName: "assets/graphics/Info 3.png",
            ));
          }
          List<Widget> _infoTilesThanks = new List<Widget>();
          for (Info _infoItem in info.sublist(18,21)) {
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
                title: "Info",
                bottom: TabBar(
                  indicatorColor: Color(0xFFFF951A),
                  labelPadding: EdgeInsets.only(bottom: 4.0),
                  tabs: [
                    Text("Dla wszystkich"),
                    Text("Dla drużyn"),
                    Text("Podziękowania"),
                    ]
                  ),
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
        else if (_snapshot.hasError) {
          return Text("${_snapshot.error}");
        }
        return CircularProgressIndicator();
        }
    );
  }

}

class InfoGridView extends StatelessWidget {
  final List<Widget> children;
  const InfoGridView({Key key, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 16.0,
      mainAxisSpacing: 16.0,
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      children: this.children,
    );
  }
}

class InfoTile extends StatelessWidget {
  final String label;
  final String data;
  final String imageName;
  const InfoTile({Key key, @required this.label, this.data, this.imageName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GreyBox(
      decoration: imageBoxDecoration(this.imageName),
      label: this.label,
      fontSize: 15.0,
      onPressed: () {Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBarOotm(
              leadingIcon: true,
              title: this.label,
            ),
            body: Markdown(data: this.data));
            // body: Markdown(data: "# headline \n something something",));
          })
        );
      }      // child: child,
    );
  }
}