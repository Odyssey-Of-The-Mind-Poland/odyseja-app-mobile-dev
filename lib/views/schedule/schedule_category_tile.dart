import 'package:flutter/material.dart';
import 'package:ootm_app/data/ootm_icon_pack.dart';
import 'package:ootm_app/widgets/box_decoration.dart';
import 'package:ootm_app/widgets/category_box.dart';

import 'schedule.dart';

class ScheduleCategoryTile extends StatelessWidget {
  final String label;
  final String superScript;
  final String routeTitle;
  final String filterBy;
  final bool isEmpty;
  const ScheduleCategoryTile({Key key, @required this.label,
  this.superScript, this.routeTitle, this.filterBy, this.isEmpty}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _imageName;
    switch (filterBy) {
      case 'stage':
        _imageName = "assets/graphics/Harmo 1.png";
        break;
      case 'problem':
        _imageName = "assets/graphics/Harmo 2.png";
        break;
      case 'age':  
        _imageName = "assets/graphics/Harmo 3.png";
        break;
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: 96.0,
          height: 96.0,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              GreyBox(
              decoration: imageBoxDecoration(_imageName),
              label: this.label,
              fontSize: 13.0,
              onPressed: isEmpty ? null : 
                () {Navigator.of(context)
                .push(MaterialPageRoute<void>(builder: (BuildContext context) {
                  return ScheduleViewRoute(
                    title: routeTitle,
                    filterBy: this.filterBy,
                    filterValue: this.superScript,
                  );
                }));
              }
            ),
            if (isEmpty)
              Container(
                child: Center(child: Icon(OotmIconPack.locked, color: Colors.white)),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10.0)
                ),

              ),
            Transform.translate(
              offset: Offset(1.0,-1.0),
              child: SizedBox(
                height: 24.0,
                width: 24.0,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    this.superScript,
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white,
                  ),
                ),
              ),
            )
            ]
          )
        ),
      ),
    );
  }
}