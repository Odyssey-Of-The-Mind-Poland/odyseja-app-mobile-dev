import 'package:flutter/material.dart';
import 'package:ootm_app/data/ootm_icon_pack.dart';
import 'package:ootm_app/data/performance.dart';
import 'package:ootm_app/data/performance_group.dart';
import 'package:ootm_app/models/city_data_model.dart';
import 'package:ootm_app/widgets/appbar.dart';
import 'package:ootm_app/widgets/box_decoration.dart';
import 'package:ootm_app/widgets/performance_group.dart';
import 'package:provider/provider.dart';

class SearchRoute extends StatefulWidget {
  SearchRoute({Key key}) : super(key: key);

  @override
  _SearchRouteState createState() => _SearchRouteState();
}

class _SearchRouteState extends State<SearchRoute> {
  TextEditingController controller = new TextEditingController();
  String searchQuery;
  List<Performance> pfList; 
  List<PerformanceGroup> pfGroups;

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
  @override
  Widget build(BuildContext context) {
    final cityProvider = Provider.of<CityDataModel>(context);
    pfList = cityProvider.pfList;
    pfGroups = cityProvider.pfGroups;

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
                          List<Performance> performances = this.pfGroups[i].performances;
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