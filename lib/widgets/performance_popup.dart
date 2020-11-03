import 'package:flutter/material.dart';

import 'box_decoration.dart';

class OotmPopUp extends StatelessWidget {
  final Widget child;
  OotmPopUp({Key key, this.child}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return Material(
       type: MaterialType.transparency,
       child: Stack(
         children: <Widget>[
           GestureDetector(
             onTap: () => Navigator.of(context).maybePop(),
           ),
           Padding(
               padding: EdgeInsets.symmetric(horizontal: 16.0),
               child: Align(
                 alignment: Alignment.center,
                 child: Container(
                   decoration: greyBoxDecoration(),
                   child: this.child,
                 )
               )
           )
         ])
    );
  }
}