import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ootm_app/models/city_data_model.dart';
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
    final cityProvider = Provider.of<CityDataModel>(context);
    return FutureBuilder(
      future: Hive.openBox(cityProvider.chosenCity.hiveName),
      // initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<String> stages = snapshot.data.get("stages").cast<String>();
          List<PerformanceGroup> pfGroups = snapshot.data.get("performanceGroups").cast<PerformanceGroup>();
          return Scaffold(
            appBar: AppBarOotm(
              leadingIcon: false,
              title: Text("Ulubione"),
            ),
            body: FavouritesView(
              box: snapshot.data,
              pfGroups: pfGroups,
              stages: stages,
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      }
    );
  }
}

class FavouritesView extends StatefulWidget {
  final Box box;
  final List<PerformanceGroup> pfGroups;
  final List<String> stages;
  FavouritesView({Key key, this.box, this.pfGroups, this.stages}) : super(key: key);

  @override
  _FavouritesViewState createState() => _FavouritesViewState();
}

class _FavouritesViewState extends State<FavouritesView> {
  List<String> stageFilter = [];
  List<String> problemFilter = [];
  List<String> ageFilter = [];

  List<PerformanceGroup> filter() {
    
    return this.widget.pfGroups.where((pf) =>
      (stageFilter.isNotEmpty ? stageFilter.contains(pf.stage.toString()) : true) &&
      (problemFilter.isNotEmpty ? problemFilter.contains(pf.problem) : true) &&
      (ageFilter.isNotEmpty ? ageFilter.contains(pf.age) : true)
       
    ).toList();

  }
  @override
  Widget build(BuildContext context) {
    
    List<PerformanceGroup> filteredPfGroups = filter();
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            children: <Widget>[
              Headline(text: "Scena"),
              FilterSet(
                labels: List<String>.generate(this.widget.stages.length, (int i) => "${i+1}"),
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
              ValueListenableBuilder(
                valueListenable: widget.box.listenable(),
                builder: (context, value, child) {
                  return Column(
                    children: <Widget>[
                      ListView.builder(
                        primary: false,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: filteredPfGroups.length,
                        itemBuilder: (BuildContext context, int i) {
                          
                          List<String> groupBoxKeys = filteredPfGroups[i].performanceKeys;
                          List<Performance> performances = [for(String k in groupBoxKeys) this.widget.box.get(k)];
                          performances.retainWhere((p) => p.faved == true);
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
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}