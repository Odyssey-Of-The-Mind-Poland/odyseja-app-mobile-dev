import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        future: Storage(fileName: 'timeTableGetAll.json').readFileSchedule(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Column(
          children: <Widget>[
            Expanded(
              child: ListView(
              // padding: EdgeInsets.only(left: 8.0, top: 8.0),
              children: <Widget>[
                SearchField(),
                Headline(text: "Scena"),
                ScheduleTileList(
                  labels: sceneList(),
                  superScripts: ["1", "2", "3", "4", "5"],
                  routeTitle: "Scena",
                  data: snapshot.data,
                  filterBy: "stage",
                ),
                Headline(text: "Problem Długoterminowy"),
                ScheduleTileList(
                  routeTitle: "Problem",
                  labels: problemList(),
                  superScripts:  ["J", "1", "2", "3", "4", "5"],
                  data: snapshot.data,
                  filterBy: "problem",
                ),
                Headline(text: "Grupa Wiekowa"),
                ScheduleTileList(
                  routeTitle: "Grupa Wiekowa",
                  labels: ageList(),
                  superScripts: ["J", "I", "II", "III", "IV", "V"],
                  data: snapshot.data,
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
  final List<Performance> data;
  final String filterBy;
  ScheduleTileList({this.labels, this.superScripts, this.routeTitle, this.data, this.filterBy});

  @override
  Widget build(BuildContext context) {

    List<Performance> _filteredData(String filterValue) {
      switch (filterBy) {
        case 'stage':
          return this.data.where((p) => p.stage == filterValue).toList();
        case 'problem':
          return this.data.where((p) => p.problem == filterValue).toList();
        case 'age':  
          return this.data.where((p) => p.age == filterValue).toList();
          break;
      }
      return this.data;
    }
    for (var pair in zip([labels, superScripts])) {
      tiles.add(ScheduleCategoryTile(
        label: pair[0],
        superScript: pair[1],
        routeTitle: routeTitle + " " + pair[1],
        data: _filteredData(pair[1]),
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
  final List<Performance> data;
  const ScheduleCategoryTile({Key key, @required this.label,
  this.superScript, this.routeTitle, this.data}) : super(key: key);

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
                    data: this.data,
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
  final List<Performance> data;
  const ScheduleViewRoute({Key key, this.title, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
        var problems = new List();
    var ages = new List();
    var stages = new List();

    for (var p in this.data) {
      problems.add(p.problem);
      ages.add(p.age);
      stages.add(p.stage);
    }
    var problemsPresent = Set.of(problems);
    var agesPresent = Set.of(ages);
    var stagesPresent = Set.of(stages);

    List<Widget> performanceGroups = new List<Widget>();
    for (var pr in problemsPresent) {
      for (var ag in agesPresent) {
        for (var st in stagesPresent) {
          List<Performance> groupData = this.data.where(
            (p) =>
            p.problem == pr &&
            p.age == ag &&
            p.stage == st
          ).toList();
          if (groupData.isNotEmpty) {
            performanceGroups.add(
              new PerformanceGroup(data: groupData)
            );
          }
        }
      }
    }
    return Scaffold(
      appBar: AppBarOotm(
        leadingIcon: true,
        title: title,
      ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(children: <Widget>[...performanceGroups],),
        ),
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