import 'package:flutter/material.dart';
import 'schedule_category_tile.dart';
import 'package:quiver/iterables.dart';

class ScheduleTileList extends StatelessWidget {
  final List<Widget> tiles = [];
  final List<String> labels;
  final List<String> superScripts;
  final String routeTitle;
  final String filterBy;
  final List<String> emptyCategories;
  ScheduleTileList(
      {this.labels,
      this.superScripts,
      this.routeTitle,
      this.filterBy,
      this.emptyCategories});

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
