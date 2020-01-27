import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ootm_app/data.dart';
import 'package:provider/provider.dart';
import 'package:ootm_app/common_widgets.dart';
import 'package:ootm_app/main.dart';

class FavouritesPage extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
      final cityProvider = Provider.of<ChosenCity>(context);
      return FutureBuilder(
        future: Hive.openBox(cityProvider.chosenCity.hiveName),
        // initialData: InitialData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // return ;
            List<String> stages = snapshot.data.get("stages");
            List<PerformanceGroup> pfGroups = snapshot.data.get("performanceGroups").cast<PerformanceGroup>();
      return Scaffold(
        appBar: AppBarOotm(
          leadingIcon: false,
          title: "Ulubione",
        ),
        body: FavouritesView(
              // box: box,
              box: snapshot.data,
              pfGroups: pfGroups,
              stages: stages,
            ),
        // body: ValueListenableBuilder(
        //   valueListenable: Hive.box("Warszawa").listenable(),
        //   builder: (context, box, widget) {
            // List<String> stages = box.get("stages");
            // List<PerformanceGroup> pfGroups = box.get("performanceGroups").cast<PerformanceGroup>();
            // return FavouritesView(
            //   // box: box,
            //   box: snapshot.data,
            //   pfGroups: pfGroups,
            //   stages: stages,
            // );
        //   },
        // ),
      );
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
          // CupertinoSlidingSegmentedControl(
          //   backgroundColor: Colors.white,
          //   thumbColor: Color(0xFFFF951A),
          //   groupValue: _selected,
          //   onValueChanged: (int index) => _selected = index,
          //   children: {
          //     0: Text("Wszystkie"),
          //     1: Text("Filtry")
          //   },
          // ),
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
              Column(
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
                        ),
            ],
          ),
        ),
      ],
    );
  }
}

class FilterSet extends StatefulWidget {
  final List<String> labels;
  final Function filter;

  FilterSet({Key key, @required this.labels, @required this.filter}) : super(key: key);

  @override
  _FilterSetState createState() => _FilterSetState();
}

class _FilterSetState extends State<FilterSet> with AutomaticKeepAliveClientMixin{
  List<String> categoryFilter = new List<String>();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<Widget> filterChips = new List<Widget>();
    for (String label in this.widget.labels) {
        filterChips.add(
          FilterButton(
            label: label,
            selected: categoryFilter.contains(label),
            onSelected: (value) {
              print(value);
              if (value) {
                categoryFilter.add(label);
              } else {
                categoryFilter.remove(label);
              } 
              this.widget.filter(categoryFilter);
            } 
          )
        );
      }
    return Row(
      children: <Widget>[...filterChips]);
  }

  @override
  bool get wantKeepAlive => true;
}


class FilterButton extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged onSelected;
  const FilterButton({Key key, @required this.label, @required this.selected, @required this.onSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(
        this.label,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black,
          fontSize: 17.0,
          fontWeight: FontWeight.bold, 
        ),
        ),
      selectedColor: Color(0xFFFF951A),
      selectedShadowColor: Color(0xFFFF951A),
      padding: EdgeInsets.all(8.0),
      // la
      showCheckmark: false,
      selected: this.selected,
      onSelected: this.onSelected,
    );
  }
}