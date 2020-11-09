import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ootm_app/data/performance_group.dart';
import 'package:ootm_app/models/city_data_model.dart';
import 'package:ootm_app/widgets/appbar.dart';
import 'package:provider/provider.dart';
import '../../data/divisions.dart';
import '../../data/performance.dart';
import '../../data/problems.dart';
import '../../data/ootm_icon_pack.dart';
import '../../widgets/box_decoration.dart';
import '../../widgets/headline.dart';
import '../../widgets/performance_group.dart';
import 'schedule_tile_list.dart';

class ScheduleMenuRoute extends StatelessWidget {
  const ScheduleMenuRoute({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cityProvider = Provider.of<CityDataModel>(context);
    return FutureBuilder(
        future: Hive.openBox(cityProvider.chosenCity.hiveName),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<String> stages = snapshot.data.get("stages").cast<String>();
            List<PerformanceGroup> pfGroups = snapshot.data.get("performanceGroups")
              .cast<PerformanceGroup>();
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
                        return SearchView(box: snapshot.data);
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
        else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
        }
    );
  }

}

class SearchView extends StatefulWidget {
  final Box box;
  SearchView({Key key, this.box}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  TextEditingController controller = new TextEditingController();
  String searchQuery;
  List<Performance> pfList = []; 
  List<PerformanceGroup> pfGroups = [];

  @override
  void initState() {
    super.initState();
    final List<String> boxKeys = this.widget.box.get("performances");
    pfList = [for(String k in boxKeys) this.widget.box.get(k)];
    controller.addListener(() {
      setState(() {
        searchQuery = controller.text.toLowerCase();
      });
    });
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    List<Performance> searchResult = [];
    if (searchQuery != "" && searchQuery != null)
      searchResult = pfList.where((pf) => pf.team.toLowerCase().contains(searchQuery)).toList();

    return Scaffold(
      appBar: AppBarOotm(
        title: Container(
          decoration: whiteBoxDecoration(),
          height: 40.0,
          child: TextField(
          controller: controller,
          textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            // icon: Icon(OotmIconPack.info),
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.only(left: 16.0),
            prefixIcon: IconButton(
              icon: Icon(OotmIconPack.arrow_back),
              onPressed: () => Navigator.of(context).maybePop()
            ),
            suffixText: null,
            suffixIcon: Transform.translate(
              offset: Offset(24.0, 0.0),
              child: RawMaterialButton(
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: orangeBoxDecoration(),
                  child: Icon(OotmIconPack.search, color: Colors.white, size: 24.0,),
                ),
                onPressed: null
              ),
            ),
          ),
          autofocus: true,  
          style: TextStyle(
            fontSize: 15.0,
          ),
          ),
        ),
        leadingIcon: false,
      ),
      body: ListView.builder(
        // shrinkWrap: true,
        itemCount: searchResult.length,
        itemBuilder: (context, idx) {
          if (searchResult.isNotEmpty) {
            final List<TextSpan> children = []; 
            String team = searchResult[idx].team;
            String teamLowerCase = team.toLowerCase();
            int index = 0;
            int matchLen = searchQuery.length;
            int oldIndex;
            String preMatch;
            String match;
            while (index != -1) {
              oldIndex = index;
              index = teamLowerCase.indexOf(searchQuery, oldIndex);
              if (index >= 0) {
                preMatch = team.substring(oldIndex, index);
                // print(preMatch);
                match = team.substring(index, index + matchLen);
                // print(match);
                if (preMatch.isNotEmpty)
                  children.add(TextSpan(text: preMatch));
                children.add(
                  TextSpan(
                    text: match,
                    style: TextStyle(fontWeight: FontWeight.bold)
                  )
                );
                index += matchLen;
              } else {
                // print("koniec");
                children.add(TextSpan(text: team.substring(oldIndex)));
              }
            }
            Performance result = searchResult[idx];
            return ListTile(
              // onTap: ()=> print([searchResult[idx].team, searchResult[idx].id]),
              onTap: () {Navigator.of(context)
                .push(MaterialPageRoute<void>(builder: (BuildContext context) {
                  print(result.team);
                  pfGroups = this.widget.box.get("performanceGroups").cast<PerformanceGroup>();
                  List<PerformanceGroup> groupResults = pfGroups.where((group) => 
                  group.age == result.age &&
                  group.problem == result.problem
                  ).toList();
                  print(groupResults.length);
                  return Scaffold(
                    appBar: AppBarOotm(
                      title: Text("Wyniki"),
                      leadingIcon: true,
                    ),
                    body: ListView.builder(
                        shrinkWrap: true,
                        itemCount: groupResults.length,
                        itemBuilder: (BuildContext context, int i) {
                          List<String> groupBoxKeys = groupResults[i].performanceKeys;
                          List<Performance> performances = [for(String k in groupBoxKeys) this.widget.box.get(k)];
                          if (performances.isNotEmpty) {
                            return new PerformanceGroupWidget(
                              // key: UniqueKey(),
                              data: performances,
                              stage: groupResults[i].stage.toString(),
                              problem: groupResults[i].problem,
                              age: groupResults[i].age,
                            );
                          }
                          return SizedBox();
                        },
                      ),
                  );
                }));
              },
              title: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [...children]
                ),
              ),
              subtitle: Text("Problem ${result.problem} - Gr. wiekowa ${result.age}"),
            );
          }
          else
            return SizedBox();
        },
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
    return FutureBuilder(
      future: Hive.openBox(cityProvider.chosenCity.hiveName),
      // initialData: null,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<PerformanceGroup> pfGroups = snapshot.data.get("performanceGroups").cast<PerformanceGroup>();

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
                        List<String> groupBoxKeys = pfGroups[i].performanceKeys;
                        List<Performance> performances = [for(String k in groupBoxKeys) snapshot.data.get(k)];
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

        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
        }
    );
  }
}