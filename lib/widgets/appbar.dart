import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/ootm_icon_pack.dart';

class AppBarOotm extends StatelessWidget implements PreferredSizeWidget {
  final bool leadingIcon;
  final Widget customLeading;
  final Widget leading;
  final List<Widget> actions;
  final Widget title;
  final Widget bottom;
  const AppBarOotm({Key key, this.leadingIcon, this.title, this.bottom, this.actions, this.leading, this.customLeading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      bottom: this.bottom,
      automaticallyImplyLeading: false,
      leading: leadingIcon ? customLeading ??
        IconButton(
          icon: Icon(OotmIconPack.arrow_back),
          onPressed: () => Navigator.of(context).maybePop())
        : null,
      title: this.title,
      centerTitle: false,
      backgroundColor: Colors.transparent,
      brightness: Brightness.light,
      elevation: 0,
      textTheme: TextTheme(
        headline6: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 31,
          )
        ),
      actions: this.actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(84.0);
}