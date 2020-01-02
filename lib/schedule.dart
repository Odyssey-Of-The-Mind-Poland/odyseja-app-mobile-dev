import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'common_widgets.dart';
import 'ootm_icon_pack.dart';

class ScheduleRoute extends StatelessWidget {
  const ScheduleRoute({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: ootmAppBar("Harmonogram", false),
          body: Column(
        children: <Widget>[
          SearchField(),
          Expanded(
              child: ListView(
              // padding: EdgeInsets.only(left: 8.0, top: 8.0),
              children: <Widget>[
                headline("Scena"),
                listMockup(),
                headline("Problem Długoterminowy"),
                listMockup(),
                headline("Grupa Wiekowa"),
                listMockup(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget headline(String _title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        _title,
        style: TextStyle(
          fontSize: 17.0,
          fontWeight: FontWeight.bold,
        ),),
    );
  } 
  Widget listMockup() {
    return SizedBox(
      height: 138.0,
      child: ListView(
        padding: EdgeInsets.all(8.0),
        children: <Widget>[
          PerformanceTile(label: "1",),
          PerformanceTile(label: "2",),
          PerformanceTile(label: "3",),
          PerformanceTile(label: "4",),
          PerformanceTile(label: "5",),
          ],
          scrollDirection: Axis.horizontal,
        ),
    );
  }
}


class PerformanceTile extends StatelessWidget {
  final String label;
  const PerformanceTile({Key key, @required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: 96.0,
          height: 96.0,
          child: GreyBox(
            label: this.label,
            onPressed: () {Navigator.of(context)
              .push(MaterialPageRoute<void>(builder: (BuildContext context) {
                return Scaffold(
                  appBar: ootmAppBar(this.label, true),
                  body: Column(
                    children: <Widget>[
                      PerformanceCard(),
                      PerformanceCard(),
                      PerformanceCard(),
                      PerformanceCard(),
                      PerformanceCard(),
                    ],
                  ));
                })
              );
            }
          )
        ),
      ),
    );
  }
}


class PerformanceCard extends StatefulWidget {
  PerformanceCard({Key key}) : super(key: key);

  @override
  _PerformanceCardState createState() => _PerformanceCardState();
}

class _PerformanceCardState extends State<PerformanceCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        height: 48.0,
        child: RawMaterialButton(
          onPressed: null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "09:45",
                  style: TextStyle(
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  "Prywatna szkoła podstawowa czy coś w Radomiu lub jakiejś innej Rosji",
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 13.0,
                  ),
                  overflow: TextOverflow.fade,
                ),
              ),
              IconButton(
                icon: Icon(OotmIconPack.sbar_help),
                onPressed: null,
              )],
          )
         ),
         decoration: whiteBoxDecoration(),
      ),
    );
  }
}


// GestureDetector(onPanUpdate: (details) {
//   if (details.delta.dx > 0) {
//     // swiping in right direction
//   }

class SearchField extends StatefulWidget {
  SearchField({Key key}) : super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        // padding: EdgeInsets.symmetric(horizontal: 16.0),
        height: 48.0,
        child: TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 8.0),
            labelText: "Szukaj drużyny",
            hasFloatingPlaceholder: false,
            // icon: Icon(Icon),
          ),
        ),
        decoration: whiteBoxDecoration(),
      ),
    );
  }
}
// });