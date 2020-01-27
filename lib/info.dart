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
          // print(_snapshot.data);
          // print(_snapshot.data.get("info"));
          List<Info> info = _snapshot.data.get("info").cast<Info>();
          // List<Info> dataSubset = info.where(
          //   ((p) => p.city == cityProvider.chosenCity)).toList();
          // dataSubset = info;
          List<Widget> _infoTiles = new List<Widget>();
          for (Info _infoItem in info) {
            _infoTiles.add(new InfoTile(
              label: _infoItem.infName,
              data: _infoItem.infoText,
            ));
          }
          
          return Scaffold(
            appBar: AppBarOotm(
              leadingIcon: false,
              title: "Info",
            ),
            body: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              children: <Widget>[
                ..._infoTiles,
                InfoTile(label: "Lo\u00adrem ip\u00adsum", data: "# headline \n something something"), 
                InfoTile(label: "dolor sit amet", data: "# headline \n something something"),
                InfoTile(label: "consectetur adipiscing elit", data: "# headline \n something something"),
                InfoTile(label: "sed do eiusmod", data: "# headline \n something something"),
                InfoTile(label: "tempor incididunt", data: "# headline \n something something"),
                ],
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
class InfoTile extends StatelessWidget {
  final String label;
  final String data;
  const InfoTile({Key key, @required this.label, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GreyBox(
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