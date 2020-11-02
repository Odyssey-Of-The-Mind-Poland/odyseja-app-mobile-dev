// import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ootm_app/ootm_icon_pack.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'city.dart';
import 'common_widgets.dart';
import 'data.dart';
// import 'ootm_icon_pack.dart';
import 'package:quiver/iterables.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'ootm_icon_pack.dart';

class ScheduleMenuRoute extends StatelessWidget {
  const ScheduleMenuRoute({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cityProvider = Provider.of<ChosenCity>(context);
    return FutureBuilder(
        future: Hive.openBox(cityProvider.chosenCity.hiveName),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
          // TODO ticket on why it works on mobile, but not on web 
          // List<String> stages = snapshot.data.get("stages");
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



class ScheduleTileList extends StatelessWidget {
  final List<Widget> tiles = new List<Widget>();
  final List<String> labels;
  final List<String> superScripts;
  final String routeTitle;
  final String filterBy;
  final List<String> emptyCategories;
  ScheduleTileList({this.labels, this.superScripts, this.routeTitle, this.filterBy, this.emptyCategories});

  @override
  Widget build(BuildContext context) {

    for (var pair in zip([this.labels, this.superScripts])) {
      tiles.add(ScheduleCategoryTile(
        label: pair[0],
        superScript: pair[1],
        routeTitle: routeTitle + " " + pair[1],
        filterBy: this.filterBy,
        isEmpty: emptyCategories.contains(pair[1]),
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

class ScheduleViewRoute extends StatelessWidget {
  final String title;
  final String filterBy;
  final String filterValue;
  const ScheduleViewRoute({Key key, this.title, this.filterBy, this.filterValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cityProvider = Provider.of<ChosenCity>(context);
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

/*
Search field is kind of a cheat. It requires semi-transparent modal barier
and list with suggestions and seems to be easier done with fake button launching
a dialog rather than a sophisticated, proper, stacked widget. 
*/
class SearchField extends StatefulWidget {
  final Box box;
  SearchField({Key key, this.box}) : super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  GlobalKey keyFakeSearchField = GlobalKey();
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: RawMaterialButton(
        key: keyFakeSearchField,
        onPressed: () {
          setState(() {
            _isVisible = !_isVisible;
          });
          return showDialog<void>(
            /// Barrier is overriden by [Material], thus enforicing [GestureDetectors].
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return SearchDialog(parentKey: keyFakeSearchField, box: this.widget.box);
            },
          );
        },
        child: Container(
          height: 40.0,
          decoration: whiteBoxDecoration(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text("Szukaj Drużyny..."),
              ),
              Container(
                height: 40.0,
                width: 40.0,
                decoration: orangeBoxDecoration(),
                child: Icon(OotmIconPack.search, color: Colors.white,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchDialog extends StatefulWidget {
  final GlobalKey parentKey;
  final Box box;
  SearchDialog({Key key, this.parentKey, this.box}) : super(key: key);

  @override
  _SearchDialogState createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  TextEditingController controller = new TextEditingController();
  String searchQuery;
  
  
  @override
  void initState() {
    super.initState();
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

  int itemCounter(int _count) {
    if (_count < 5)
    return _count;
    else 
    return 5;
  } 

  @override
  Widget build(BuildContext context) {
    final RenderBox renderBoxRed = this.widget.parentKey.currentContext.findRenderObject();
    Offset position;
    if (kIsWeb)
      position = renderBoxRed.localToGlobal(Offset(-16.0, 0.0));
    else 
      position = renderBoxRed.localToGlobal(Offset(-16.0, -21.0));

    final List<String> boxKeys = this.widget.box.get("performances");
    final List<Performance> pfList = [for(String k in boxKeys) this.widget.box.get(k)];
    List<Performance> searchResult = [];
    if (searchQuery != "" && searchQuery != null)
      searchResult = pfList.where((pf) => pf.team.toLowerCase().contains(searchQuery)).toList();
    return GestureDetector(
      onTap: () => Navigator.of(context).maybePop(),
      child: Material(
        type: MaterialType.button,
        color: Colors.transparent,
        child: Transform.translate(
          offset: position,
          // offset: Offset(0, 0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 0.0,
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 60.0, bottom: 20.0),
                          decoration: whiteBoxDecoration(),
                            child: ListView.separated(
                              separatorBuilder: (context, index) => Divider(),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            primary: false,
                            itemCount: itemCounter(searchResult.length),
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
                                // print();
                                return GestureDetector(
                                  onTap: ()=> print([searchResult[idx].team, searchResult[idx].id]),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: RichText(
                                      text: TextSpan(
                                        style: DefaultTextStyle.of(context).style,
                                        children: [...children]
                                      ),
                                    ),
                                  ),
                                );

                              }
                              else
                                return SizedBox();
                            }
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
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
                ],
                ),
          ),
        ),
      ),
    );
  }
}