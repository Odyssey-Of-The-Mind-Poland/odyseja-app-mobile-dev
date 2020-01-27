import 'package:flutter/material.dart';
import 'package:ootm_app/ootm_icon_pack.dart';

import 'common_widgets.dart';

class HomePage extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBarOotm(
          leadingIcon: false,
          title: "Start",
        ),
        // body: Text("Home"));
        // body: Padding(
        //   padding: const EdgeInsets.only(top:100.0),
        //   child: Container(
        //     height: 48.0,
        //     decoration: BoxDecoration(
        //       color: Color(0xFFFF951A)
        //     ),
        //   ),
        // )
        body: ListTile(
          leading: Icon(OotmIconPack.info),
          subtitle: Text("Subtitle"),
          title: Text("Title"),
        ),
        );
    }
}