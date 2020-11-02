import 'package:flutter/material.dart';
import 'package:ootm_app/ootm_icon_pack.dart';
// import 'package:provider/provider.dart';
import 'common_widgets.dart';

class HomePage extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
      // final endDrawerProvider = Provider.of<EndDrawerProvider>(context);
      return Scaffold(
        appBar: AppBarOotm(
          leadingIcon: false,
          title: Text("Start"),
          // actions: <Widget>[
          //   IconButton(
          //     disabledColor: Colors.black,
          //     icon: Icon(OotmIconPack.menu),
          //     onPressed: () => endDrawerProvider.change()
          //   )
          // ],
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
          leading: Icon(OotmIconPack.search),
          title: Text("Witaj w wersji testowej aplikacji Odysei Umysłu!"),
          subtitle: Text("Póki co za wiele się tutaj nie dzieje. Szukaj szczęścia na ekranach harmonogramu oraz ulubionych!"),
        ),
        );
    }
}