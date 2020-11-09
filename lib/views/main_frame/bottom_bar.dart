import 'package:flutter/material.dart';
import 'package:ootm_app/data/ootm_icon_pack.dart';
import 'package:provider/provider.dart';

import 'city_choice_button.dart';
import 'main_frame.dart';

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
  // GlobalKey bottomAppBarKey = GlobalKey();

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
      // key: bottomAppBarKey,
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


class OotmNavBar extends StatefulWidget {
  static const _routeList = [
    '/',
    '/info',
    '/city',
    '/schedule',
    '/favs',
    ];
  final navigatorKey;
  OotmNavBar({Key key, this.navigatorKey}) : super(key: key);

  @override
  _OotmNavBarState createState() => _OotmNavBarState();
}

class _OotmNavBarState extends State<OotmNavBar> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final citySelectorProvider = Provider.of<CitySelector>(context);
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        NavBarBackground(),
        BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        selectedItemColor: Color(0xFFFF951A),
        unselectedItemColor: Color(0xFF333333),
        currentIndex: _selected,
        onTap: (int index) {
          if(index != 2) {
            setState(() {
              _selected = index;
            });
            widget.navigatorKey.currentState.pushNamed(OotmNavBar._routeList[index]);
          } else {
            citySelectorProvider.change();
          }
        },
          items: [
            BottomNavigationBarItem(
              icon: Icon(OotmIconPack.navbar_home),
              label: 'Home'
            ),
            BottomNavigationBarItem(
              icon: Icon(OotmIconPack.navbar_info),
              label: 'Info'
            ),
            BottomNavigationBarItem(
              icon: SizedBox(),
              ),
            // BottomNavigationBarItem(
            //   icon: Transform.translate(
            //     offset: Offset(0, -8),
            //     child: SizedOverflowBox(
            //       size: Size(24.0, 24.0),
            //       child: CityButton())),
            //   label: 'City Selection',
            //   ),
            BottomNavigationBarItem(
              icon: Icon(OotmIconPack.navbar_schedule),
              label: 'Harmonogram'
            ),
            BottomNavigationBarItem(
              icon: Icon(OotmIconPack.favs_outline),
              label: 'Ulubione'
            ),
          ],
    ),
    ]
  );
  }
}

class NavBarBackground extends StatelessWidget {
  final GlobalKey bottomBarKey;
  const NavBarBackground({Key key, this.bottomBarKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final keyContext = bottomBarKey.currentContext;
    // final box = keyContext.findRenderObject() as RenderBox;
    // final pos = box.localToGlobal(Offset.zero);
    // print("BottomAppBarSize is: ${box.size.height}");
    return Container(
      // height: box.size.height,
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
      // child: Expansion(),
      );
  }
}
