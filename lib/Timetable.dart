// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'City.dart';
import 'custom_expansion_tile.dart' as Custom;

class TimetablePage extends StatefulWidget {
  @override
  TimetablePageState createState() => TimetablePageState();
}
  
class TimetablePageState extends State<TimetablePage> {
  final List<Performance> _savedSet = <Performance>[];
  @override
  Widget build(BuildContext context) {
    print("TimetablePage");
    return Container(
      child: Column(
        children: [
          ListTile(
            title: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Szukaj',
              ),
            ),
            trailing: Icon(Icons.filter_list),
          ),
          _timetable(),
          // null,
        ]
      )
    );
  }
  Widget _timetable() {
    final chsnProvider = Provider.of<ChosenCity>(context);
    return FutureBuilder<List<Performance>>(
      future: Storage(fileName: 'timeTableGetAll.json').readFileSchedule(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          var dataSubset = snapshot.data.where(((p) => p.city == chsnProvider.chosenCity)).toList();

          var problems = new List();
          var ages = new List();
          var stages = new List();

          for (var p in dataSubset) {
            problems.add(p.problem);
            ages.add(p.age);
            stages.add(p.stage);
          }
          var problemsPresent = Set.of(problems);
          var agesPresent = Set.of(ages);
          var stagesPresent = Set.of(stages);

          List<Widget> blockList = new List<Widget>();
          // print('\n$problemsPresent\n $agesPresent\n$stagesPresent');
          for (var pr in problemsPresent) {
            for (var ag in agesPresent) {
              for (var st in stagesPresent) {
                List blockData = dataSubset.where(
                  (p) =>
                  p.problem == pr &&
                  p.age == ag &&
                  p.stage == st
                ).toList();
                if (blockData.isNotEmpty) {
                  // print('$pr, $ag, $st\nLiczba drużyn: ${blockData.length}');
                  blockList.add(_playBlock(blockData));
                }
              }
            }
          }
          return Expanded(
              child: ListView(
                children: <Widget>[...blockList],
              )
          );
        }
        else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      }
    );
  }

  Widget _playBlock(List<Performance> blockData) {
    print("playblock!");
    List<Widget> playList = new List<Widget>();
    for (var play in blockData) playList.add(_playItem(play));
    return Custom.ExpansionTile(
      // backgroundColor: Colors.teal[300],
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text('Problem:'),
              Text(blockData[0].problem),
            ],
          ),
          Column(
            children: <Widget>[
              Text('Kategoria\nwiekowa:'),
              Text(blockData[0].age),
            ],
          ),      
          Column(
            children: <Widget>[
              Text('Scena:'),
              Text(blockData[0].stage.substring(6,7)),
            ],
          ),
        ],
    ),
    children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text('P'),
          Text('Drużyna'),
          Text('S'),
        ],
      ),
      ...playList,
    ],
    );
  }
Widget _playItem(Performance performance) {
    print("playitem!");
    final bool saved = _savedSet.contains(performance);
    return ListTile(
      dense: true,
      title: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text(performance.play)),
          Expanded(
            flex: 10,
            child: Text(performance.team, textAlign: TextAlign.center,)),
          Expanded(
            flex: 2,
            child: Text(performance.spontan)),
        ]
      ),
      trailing: IconButton(
        icon: Icon(
          saved ? Icons.favorite : Icons.favorite_border,
          color: saved ? Colors.orangeAccent : null),
        iconSize: 12.0,
        onPressed: () {
          setState(() {
            if (saved) {
              _savedSet.remove(performance);
                  print("removed!");
            } else {
              _savedSet.add(performance);
                  print("added!!");
            }
          });
        },
      ),
    );
  }
}