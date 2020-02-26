import 'package:flutter/material.dart';
import 'package:ootm_app/ootm_icon_pack.dart';
import 'package:provider/provider.dart';
import 'common_widgets.dart';

class HomePage extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
      final endDrawerProvider = Provider.of<EndDrawerProvider>(context);
      return Scaffold(
        appBar: AppBarOotm(
          leadingIcon: false,
          title: "Start",
          actions: <Widget>[
            IconButton(
              disabledColor: Colors.black,
              icon: Icon(OotmIconPack.menu),
              onPressed: () => endDrawerProvider.change()
            )
          ],
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
          leading: Icon(OotmIconPack.navbar_info),
          subtitle: Text("Subtitle"),
          title: Text("Title"),
        ),
        );
    }
}