import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ootm_app/data.dart';
import 'common_widgets.dart';

class FavouritesPage extends StatefulWidget {
  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  @override
    Widget build(BuildContext context) {
      // Box box = Hive.box("Warszawa");
      // List<String> boxKeys = box.get("performances");
      // List<Performance> pfList = [for(String k in boxKeys) box.get(k)];
      // pfList.retainWhere((p) => p.faved == true);

      // int _selected = 0;
      return Scaffold(
        appBar: AppBarOotm(
          leadingIcon: false,
          title: "Ulubione",
        ),
        body: Column(
          children: <Widget>[
            ValueListenableBuilder(
              valueListenable: Hive.box("Warszawa").listenable(),
              builder: (context, box, widget) {
      List<PerformanceGroup> pfGroups = box.get("performanceGroups").cast<PerformanceGroup>();
                return
                          Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: pfGroups.length,
                  itemBuilder: (BuildContext context, int i) {
                    List<String> groupBoxKeys = pfGroups[i].performanceKeys;
                    List<Performance> performances = [for(String k in groupBoxKeys) box.get(k)];
                    performances.retainWhere((p) => p.faved == true);
                    if (performances.isNotEmpty) {
                      return new PerformanceGroupWidget(
                        data: performances,
                        stage: pfGroups[i].stage.toString(),
                        problem: pfGroups[i].problem,
                        age: pfGroups[i].age,
                      );
                    }
                    return SizedBox();
                  },
                ),
              );
              },
            ),
            // CupertinoSlidingSegmentedControl(
            //   backgroundColor: Colors.white,
            //   thumbColor: Color(0xFFFF951A),
            //   groupValue: _selected,
            //   onValueChanged: (int index) => _selected = index,
            //   children: {
            //     0: Text("Wszystkie"),
            //     1: Text("Filtry")
            //   },
            // ),

            ],
        ),
      );
    }
}