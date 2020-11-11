import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ootm_app/data/performance_group.dart';
import 'package:ootm_app/models/city_data_model.dart';
import 'package:ootm_app/widgets/appbar.dart';
import 'package:provider/provider.dart';
import '../../data/divisions.dart';
import '../../data/performance.dart';
import '../../data/problems.dart';
import '../../data/ootm_icon_pack.dart';
import '../../widgets/headline.dart';
import '../../widgets/performance_group.dart';
import 'schedule_tile_list.dart';
import 'search_route.dart';

class ScheduleMenuRoute extends StatelessWidget {
  const ScheduleMenuRoute({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cityProvider = Provider.of<CityDataModel>(context);
            List<String> stages = cityProvider.stages;
            List<PerformanceGroup> pfGroups = cityProvider.pfGroups;
            List<String> emptyProblems = problemShorts().where((problem) {
              return pfGroups.where((pfg) => pfg.problem == problem).isEmpty;
            }).toList();
            
            List<String> emptyAges = ageShorts().where((age) {
              return pfGroups.where((pfg) => pfg.age == age).isEmpty;
            }).toList();

            return Scaffold(
              appBar: AppBarOotm(
                leadingIcon: false,
                title: Text("Harmonogram"),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(OotmIconPack.search),
                    onPressed: () => Navigator.of(context)
                      .push(MaterialPageRoute<void>(builder: (context) {
                        return SearchRoute();
                      }))
                  ),
                ],
              ),
              body: Column(
          children: <Widget>[
              Expanded(
                child: ListView(
                // padding: EdgeInsets.only(left: 8.0, top: 8.0),
                children: <Widget>[
                  // SearchField(box: snapshot.data),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Headline(text: "Scena"),
                  ),
                  ScheduleTileList(
                    labels: stages,
                    superScripts: new List<String>.generate(stages.length, (i) => "${i + 1}"),
                    routeTitle: "Scena",
                    filterBy: "stage",
                    emptyCategories: [],
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
                    emptyCategories: emptyProblems,
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
                    emptyCategories: emptyAges,
                  ),
                  ],
                ),
              ),
          ],
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
    final cityProvider = Provider.of<CityDataModel>(context);
          List<PerformanceGroup> pfGroups = cityProvider.pfGroups;

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
          return Scaffold(
            appBar: AppBarOotm(
              leadingIcon: true,
              title: Text(title),
            ),
              body: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(               
                      shrinkWrap: true,
                      itemCount: pfGroups.length,
                      itemBuilder: (BuildContext context, int i) {
                        List<Performance> performances = pfGroups[i].performances;
                        return new PerformanceGroupWidget(
                          data: performances,
                          stage: pfGroups[i].stage.toString(),
                          problem: pfGroups[i].problem,
                          age: pfGroups[i].age,
                          filterBy: filterBy,
                        );
                      },
                    ),
                  ),
                ],
              ),
          );
  }
}