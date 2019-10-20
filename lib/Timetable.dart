// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'City.dart';
import 'custom_expansion_tile.dart' as Custom;

class TimetablePage extends StatefulWidget {
  @override
  _TimetablePageState createState() => _TimetablePageState();
}
  
class _TimetablePageState extends State<TimetablePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ListTile(
            title:  TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Szukaj',
                ),
              ),
            trailing: Icon(Icons.filter_list),
          ),
          // _rawtimetable(),
          _timetable(),
          // _playBlock(),
          // _playItem(),
        ]
      )
    );
  }
  Widget _rawtimetable() {
    final chsnProvider = Provider.of<ChosenCity>(context);
    return FutureBuilder<List<Performance>>(
            future: Storage('timeTableGetAll.json').readFileTT(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                var dataSubset = snapshot.data.where(((p) => p.city == chsnProvider.chosenCity)).toList();
                // print('Podzbiór danych: ${dataSubset[0].city}');
                // print('Wybrane miasto: ${chsnProvider.chosenCity}');
                return Expanded(
                  child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int i) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Text(dataSubset[i].problem),
                              Text(dataSubset[i].age),
                              Text(dataSubset[i].stage),
                            ],
                          ),
                          Row( 
                            children: [
                              Text(dataSubset[i].play),
                              Text(dataSubset[i].team),
                              Text(dataSubset[i].spontan),
                              // Text(dataSubset.[i].id.toString()),
                              // Text(dataSubset.[i].city),
                            ]
                          ),
                          Divider(),
                        ]
                      );
                    }
                  ),
                );
              }
              else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            }
          );
  }
  Widget _timetable() {
    final chsnProvider = Provider.of<ChosenCity>(context);

    return FutureBuilder<List<Performance>>(
            future: Storage('timeTableGetAll.json').readFileTT(),
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
                        print('$pr, $ag, $st');
                        blockList.add(_playBlock(blockData));
                      }
                      // return _playBlock(blockData);
                      // return Text('data');
                    }
                  }
                }
                      // return null;
                return Expanded(
                  // child: ListView.builder(
                    // itemCount: 2,
                    // itemBuilder: (BuildContext context, int i) {
                    child: ListView(
                      children: <Widget>[...blockList],
                      // children: <Widget>[Text('lll')],
                    )
                );

                  //   }
                  // ),
                // );
              }
              else if (snapshot.hasError) {

                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            }
          );
  }
  Widget _playBlock(List<Performance> blockData) {
    List<Widget> playList = new List<Widget>();
    for (var perf in blockData) playList.add(_playItem(perf));
    return Custom.ExpansionTile(
      // backgroundColor: Colors.teal[300],
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text('Problem:'),
              Text(blockData[0].problem.substring(9,10)),
            ],
          ),
          Column(
            children: <Widget>[
              Text('Kategoria\nwiekowa:'),
              Text(blockData[0].age.substring(15)),
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
      trailing: Icon(Icons.favorite_border, size: 12.0),
      // subtitle: ,

    );
  }

  // List dataSubdivision(List dataSubset) {
    
  // }
}