import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ootm_app/models/city_data_model.dart';
import 'package:ootm_app/models/fav_model.dart';
import 'package:ootm_app/widgets/appbar.dart';
import 'package:provider/provider.dart';
import '../../data/divisions.dart';
import '../../data/performance.dart';
import '../../data/performance_group.dart';
import '../../data/problems.dart';
import '../../widgets/headline.dart';
import '../../widgets/performance_group.dart';
import 'filter_set.dart';

class FavouritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
          return Scaffold(
            appBar: AppBarOotm(
              leadingIcon: false,
              title: Text("Ulubione"),
            ),
            body: FavouritesView(
            ),
          );
  }
}

class FavouritesView extends StatefulWidget {
  FavouritesView({Key key}) : super(key: key);

  @override
  _FavouritesViewState createState() => _FavouritesViewState();
}

class _FavouritesViewState extends State<FavouritesView> {
  List<PerformanceGroup> pfGroups;
  List<String> stages;

  List<String> stageFilter = [];
  List<String> problemFilter = [];
  List<String> ageFilter = [];

  List<PerformanceGroup> filter() {
    return pfGroups.where((pf) =>
      (stageFilter.isNotEmpty ? stageFilter.contains(pf.stage.toString()) : true) &&
      (problemFilter.isNotEmpty ? problemFilter.contains(pf.problem) : true) &&
      (ageFilter.isNotEmpty ? ageFilter.contains(pf.age) : true)
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cityProvider = Provider.of<CityDataModel>(context);
    final favProvider = Provider.of<FavModel>(context);
    pfGroups = favProvider.favList;
    stages = cityProvider.stages;
    
    List<PerformanceGroup> filteredPfGroups = filter();
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            children: <Widget>[
              Headline(text: "Scena"),
              FilterSet(
                labels: List<String>.generate(stages.length, (int i) => "${i+1}"),
                filter: (List<String> categoryFilter) {
                  stageFilter = categoryFilter;
                  setState(() {});
                },   
              ),
              Headline(text: "Problem długoterminowy"),
              FilterSet(
                labels: problemShorts(),
                filter: (List<String> categoryFilter) {
                  problemFilter = categoryFilter;
                  setState(() {});
                },   
              ),
              Headline(text: "Grupa Wiekowa"),
              FilterSet(
                labels: ageShorts(),
                filter: (List<String> categoryFilter) {
                  ageFilter = categoryFilter;
                  setState(() {});
                },   
              ),
         Column(
                    children: <Widget>[
                      ListView.builder(
                        primary: false,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: filteredPfGroups.length,
                        itemBuilder: (BuildContext context, int i) {
                          List<Performance> performances = filteredPfGroups[i].performances;
                          if (performances.isNotEmpty) {
                            return new PerformanceGroupWidget(
                              key: UniqueKey(),
                              data: performances,
                              stage: filteredPfGroups[i].stage.toString(),
                              problem: filteredPfGroups[i].problem,
                              age: filteredPfGroups[i].age,
                            );
                          }
                          return SizedBox();
                        },
                      ),
                    ],
                  )
            ],
          ),
        ),
      ],
    );
  }
}