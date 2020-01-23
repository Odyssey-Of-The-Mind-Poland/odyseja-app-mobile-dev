// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'city.dart';
import 'common_widgets.dart';
import 'data.dart';
// import 'ootm_icon_pack.dart';
import 'package:quiver/iterables.dart';
// import 'package:provider/provider.dart';

class ScheduleMenuRoute extends StatelessWidget {
  const ScheduleMenuRoute({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarOotm(
        leadingIcon: false,
        title: "Harmonogram",
      ),
      body: FutureBuilder(
        future: Hive.openBox('Warszawa'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
          Box cityBox = Hive.box('Warszawa');
          List<String> stages = cityBox.get('stages');
            // final data = snapshot.data.get(0);
            return Column(
          children: <Widget>[
            Expanded(
              child: ListView(
              // padding: EdgeInsets.only(left: 8.0, top: 8.0),
              children: <Widget>[
                SearchField(),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Headline(text: "Scena"),
                ),
                ScheduleTileList(
                  labels: stages,
                  superScripts: sceneShorts(),
                  routeTitle: "Scena",
                  filterBy: "stage",
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Headline(text: "Problem Długoterminowy"),
                ),
                ScheduleTileList(
                  routeTitle: "Problem",
                  labels: problemList(),
                  superScripts:  problemShorts(),
                  filterBy: "problem",
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Headline(text: "Grupa Wiekowa"),
                ),
                ScheduleTileList(
                  routeTitle: "Gr. Wiekowa",
                  labels: ageList(),
                  superScripts: ageShorts(),
                  filterBy: "age",
                ),
                ],
              ),
            ),
          ],
        );
        }
        else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
        }
      ),
    );
  }

}


class ScheduleTileList extends StatelessWidget {
  final List<Widget> tiles = new List<Widget>();
  final List<String> labels;
  final List<String> superScripts;
  final String routeTitle;
  final String filterBy;
  ScheduleTileList({this.labels, this.superScripts, this.routeTitle, this.filterBy});

  @override
  Widget build(BuildContext context) {

    for (var pair in zip([this.labels, this.superScripts])) {
      tiles.add(ScheduleCategoryTile(
        label: pair[0],
        superScript: pair[1],
        routeTitle: routeTitle + " " + pair[1],
        filterBy: this.filterBy,
      ));
    }
    return SizedBox(
      height: 138.0,
      child: ListView(
        padding: EdgeInsets.all(8.0),
        children: <Widget>[
          ...tiles,
          ],
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}


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
              label: this.label,
              fontSize: 13.0,
              onPressed: () {Navigator.of(context)
                .push(MaterialPageRoute<void>(builder: (BuildContext context) {
                  return ScheduleViewRoute(
                    title: routeTitle,
                    filterBy: this.filterBy,
                    filterValue: this.superScript,
                  );
              })
                );
              }
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

class ScheduleViewRoute extends StatelessWidget {
  final String title;
  final String filterBy;
  final String filterValue;
  const ScheduleViewRoute({Key key, this.title, this.filterBy, this.filterValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box("Warszawa").listenable(),
      builder: (context, box, widget) {

        List<Widget> performanceGroupWidgets = new List<Widget>();
        List<PerformanceGroup> pfGroups = box.get("performanceGroups").cast<PerformanceGroup>();

        switch (filterBy) {
          case 'stage':
            pfGroups = pfGroups.where((pg) => pg.stage.toString() == filterValue).toList();
            break;
          case 'problem':
            pfGroups = pfGroups.where((pg) => pg.problem == filterValue).toList();
            break;
          case 'age':  
            pfGroups = pfGroups.where((pg) => pg.age == filterValue).toList();
            break;
        }
        for (PerformanceGroup pg in pfGroups) {
          List<String> groupBoxKeys = pg.performanceKeys;
          List<Performance> performances = [for(String k in groupBoxKeys) box.get(k)];
          performanceGroupWidgets.add(
            new PerformanceGroupWidget(data: performances, problem: pg.problem, age: pg.age, stage: pg.age, filterBy: filterBy)
          );
        }


        return Scaffold(
          appBar: AppBarOotm(
            leadingIcon: true,
            title: title,
          ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(children: <Widget>[...performanceGroupWidgets],),
            ),
        );
      }
    );
  }
}


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
            labelText: "Szukaj drużyny...",
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