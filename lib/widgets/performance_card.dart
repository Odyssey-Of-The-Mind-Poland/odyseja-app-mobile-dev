import 'package:flutter/material.dart';
import 'package:ootm_app/data/performance.dart';

import 'box_decoration.dart';

class PerformanceCard extends StatelessWidget {
  final Performance performance;
  final Color favColor;

  PerformanceCard({Key key, @required this.performance, @required this.favColor}): super(key: key);

  @override
  Widget build(BuildContext context) {
    bool finals;
    String day;
    if (performance.city == "Gdynia_Sobota") {
      finals = true;
      day = "Sobota";
    } else if (performance.city == "Gdynia_Niedziela"){
      finals = true;
      day = "Niedziela";
    } else {
      finals = false;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: 48.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: finals ?
              Stack(
                // overflow: Overflow.visible,
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Positioned(
                    bottom: 24.0,
                    child: Text(day, style: TextStyle(fontSize: 8.0),)),
                  Text(
                    performance.play,
                    style: TextStyle(
                      height: 1.5,
                      color: Colors.black,
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
              : 
              Text(
                performance.play,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Text(
                performance.team,
                softWrap: true,
                style: TextStyle(
                  color: performance.faved ?
                    this.favColor
                    :
                    Colors.black,
                  fontSize: 13.0,
                ),
                overflow: TextOverflow.fade,
              ),
            ),
            IconButton(
              icon: Icon(Icons.keyboard_arrow_right),
              onPressed: null,
              padding: EdgeInsets.all(0.0),
            )],
        ),
            decoration: whiteBoxDecoration(),
        ),
    );
  }
}