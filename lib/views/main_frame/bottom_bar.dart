import 'package:flutter/material.dart';
import 'city_choice_button.dart';


class BottomAppBarItem {
  BottomAppBarItem({this.iconData, this.isActive});
  final IconData iconData;
  final bool isActive;
}


class OotmBottomAppBar extends StatefulWidget {
  final List<BottomAppBarItem> items;
  final ValueChanged<int> onTabSelected;
  final Color selectedColor;
  final double height;
  final Color color;
  final double iconSize;
  OotmBottomAppBar({
    Key key,
    this.items,
    this.onTabSelected,
    this.selectedColor,
    this.height,
    this.color,
    this.iconSize
    }) : super(key: key);

  @override
  _OotmBottomAppBarState createState() => _OotmBottomAppBarState();
}


class _OotmBottomAppBarState extends State<OotmBottomAppBar> {
  int _selectedIndex = 0;

  _updateIndex(int index) {
    widget.onTabSelected(index);
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        onPressed: _updateIndex,
      );
    });
    items.insert(items.length >> 1, _buildMiddleTabItem());

    return  BottomAppBar(
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          NavBarBackground(),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items,
          ),
        ],
      ),
      color: Colors.transparent,
      elevation: 0.0,
    );
  }

  Widget _buildTabItem({
    BottomAppBarItem item,
    int index,
    ValueChanged<int> onPressed,
    }) {
    Color color = _selectedIndex == index ? widget.selectedColor : widget.color;
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Material(
          type: MaterialType.transparency,
          child: item.isActive ? IconButton(
            icon: Icon(item.iconData),
            onPressed: () => onPressed(index),
            iconSize: widget.iconSize,
            color: color,
          ) : Icon(item.iconData, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildMiddleTabItem() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Transform.translate(
          offset: Offset(0.0, -8.0),
          child: CityButton()
        ),
      ),
    );
  }
}


class NavBarBackground extends StatelessWidget {
  final GlobalKey bottomBarKey;
  const NavBarBackground({Key key, this.bottomBarKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.0,
      decoration: BoxDecoration(
        color: Color(0xFFFAFAFA),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
          ),
        boxShadow: [
          BoxShadow(
            blurRadius: 6.0,
            offset: Offset(0.0, -3.0),
            color: Color(0x3333333D),
            )
          ],
        ),
      );
  }
}