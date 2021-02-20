import 'package:flutter/material.dart';
import 'filter_button.dart';

class FilterSet extends StatefulWidget {
  final List<String> labels;
  final Function filter;

  FilterSet({Key key, @required this.labels, @required this.filter})
      : super(key: key);

  @override
  _FilterSetState createState() => _FilterSetState();
}

class _FilterSetState extends State<FilterSet>
    with AutomaticKeepAliveClientMixin {
  List<String> categoryFilter = [];
  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<Widget> filterChips = [];
    for (String label in this.widget.labels) {
      filterChips.add(FilterButton(
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
          }));
    }
    return Row(children: <Widget>[...filterChips]);
  }

  @override
  bool get wantKeepAlive => true;
}
