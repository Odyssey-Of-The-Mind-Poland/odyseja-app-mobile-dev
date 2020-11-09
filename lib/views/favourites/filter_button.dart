import 'package:flutter/material.dart';

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