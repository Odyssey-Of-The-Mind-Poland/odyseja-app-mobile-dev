// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
    return Scaffold(
      appBar: AppBarOotm(
        leadingIcon: false,
        title: "Harmonogram",
      ),
      body: FutureBuilder(
        future: Hive.openBox(cityProvider.chosenCity.hiveName),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<String> stages = snapshot.data.get('stages');
            List<PerformanceGroup> pfGroups = snapshot.data.get("performanceGroups")
              .cast<PerformanceGroup>();
            
            List<String> emptyStages = sceneShorts().where((stage) {
              return pfGroups.where((pfg) => pfg.stage.toString() == stage).isEmpty;
            }).toList();
            print(emptyStages);

            List<String> emptyProblems = problemShorts().where((problem) {
              return pfGroups.where((pfg) => pfg.problem == problem).isEmpty;
            }).toList();
            print(emptyProblems);
            
            List<String> emptyAges = ageShorts().where((age) {
              return pfGroups.where((pfg) => pfg.age == age).isEmpty;
            }).toList();
            print(emptyAges);

            return Column(
          children: <Widget>[
            Expanded(
              child: ListView(
              // padding: EdgeInsets.only(left: 8.0, top: 8.0),
              children: <Widget>[
                SearchField(box: snapshot.data),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Headline(text: "Scena"),
                ),
                ScheduleTileList(
                  labels: stages,
                  superScripts: sceneShorts(),
                  routeTitle: "Scena",
                  filterBy: "stage",
                  emptyCategories: emptyStages,
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
              isEmpty
              ? Container(color: Colors.red) 
              : GreyBox(
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
              title: title,
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
              return SearchDialog(parentKey: keyFakeSearchField);
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
                child: Icon(OotmIconPack.info, color: Colors.white,),
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
  SearchDialog({Key key, this.parentKey}) : super(key: key);

  @override
  _SearchDialogState createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  TextEditingController controller = new TextEditingController();
  String searchQuery;
  
  
  @override
  void initState() {
    super.initState();
    // controller.addListener(() {
    //   setState(() {
    //     searchQuery = controller.text;
    //   });
    // });
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final RenderBox renderBoxRed = this.widget.parentKey.currentContext.findRenderObject();
    final position = renderBoxRed.localToGlobal(Offset(-16.0, -21.0));
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
                          padding: EdgeInsets.symmetric(vertical: 60),
                          decoration: whiteBoxDecoration(),
                            child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            primary: false,
                            itemCount: 5,
                            itemBuilder: (context, idx) {
                              return Text("tada!");
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
                            child: Icon(OotmIconPack.info, color: Colors.white, size: 24.0,),
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