import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'City.dart';
import 'data.dart';
// import 'main.dart';


class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    final cityProvider = Provider.of<ChosenCity>(context);
    print("info");
    return FutureBuilder<List<Info>>(
      future: Storage(fileName: 'infoGetAll.json').readFileInfo(),
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if (_snapshot.hasData) {
          var _dataSubset = _snapshot.data.where(
            ((p) => p.city == cityProvider.chosenCity)).toList();

          List<Widget> _infoTiles = new List<Widget>();
          for (Info _infoItem in _snapshot.data) {
            _infoTiles.add(new GreyBox(
              label: _infoItem.infName,
              data: _infoItem.infoText,
            ));
          }
          
          return GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            children: <Widget>[
              ..._infoTiles,
              GreyBox(label: "Lo\u00adrem ip\u00adsum"), 
              GreyBox(label: "dolor sit amet", data: "# headline \n something something"),
              GreyBox(label: "consectetur adipiscing elit"),
              GreyBox(label: "sed do eiusmod"),
              GreyBox(label: "tempor incididunt"),
              ],
            );
        }
        else if (_snapshot.hasError) {
          return Text("${_snapshot.error}");
        }
        return CircularProgressIndicator();
        }
    );
  }

  // void pressTile() {
  //   Navigator.of(context)
  //     .push(MaterialPageRoute<void>(builder: (BuildContext context) {
  //       return Scaffold(
  //         appBar: label,
  //         body: Text("data"));
  //       }
  //     ));
  //   }
}

class GreyBox extends StatelessWidget {
  final String label;
  final String data;
  final GestureTapCallback onPressed;
  GreyBox({this.onPressed, @required this.label, this.data});

  @override
  Widget build(BuildContext context) {
  return Container(
    // alignment: Alignment.bottomLeft,
    // width: 96.0,
    // height: 96.0,
    child: RawMaterialButton(
      // padding: EdgeInsets.all(8.0),
      onPressed: () {Navigator.of(context)
  .push(MaterialPageRoute<void>(builder: (BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(this.label),),
      body: Markdown(data: this.data));
      // body: Markdown(data: "# headline \n something something",));
    }
  ));},
      child: Align(
        alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
          this.label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
            ), 
          softWrap: true,
          ),
              ),
      ),
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      color: Color(0xFF333333),
      boxShadow: [BoxShadow(
        color: Color(0x52333333),
        blurRadius: 6.0,
        offset: Offset(0.0, 3.0),
        )]
      ),
    );

  }
}