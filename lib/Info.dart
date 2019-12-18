import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    print("info");
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 16.0,
      mainAxisSpacing: 16.0,
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      children: <Widget>[
        GreyBox(label: "Parking i dojazd"),
        GreyBox(label: "Przygoto-\nwania"),
        GreyBox(label: "Parking i dojazd"),
        GreyBox(label: "Parking i dojazd"),
        GreyBox(label: "Parking i dojazd"),
        GreyBox(label: "Parking i dojazd"),
        GreyBox(label: "Parking i dojazd"),
        GreyBox(label: "Parking i dojazd"),
        GreyBox(label: "Parking i dojazd"),
        ],
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
  final GestureTapCallback onPressed;
  GreyBox({this.onPressed, @required this.label});

  @override
  Widget build(BuildContext context) {
  return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.bottomLeft,
        width: 96.0,
        height: 96.0,
        child: RawMaterialButton(
          padding: EdgeInsets.all(8.0),
          onPressed: () {Navigator.of(context)
      .push(MaterialPageRoute<void>(builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: Text(this.label),),
          body: Text("data"));
        }
      ));},
          child: Text(
            this.label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.0,
              ), 
            softWrap: true,
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
        ),
      );

  }
}