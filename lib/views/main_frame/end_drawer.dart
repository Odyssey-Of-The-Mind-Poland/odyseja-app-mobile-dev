

import 'package:flutter/material.dart';
import 'package:ootm_app/data/ootm_icon_pack.dart';
import 'package:provider/provider.dart';

class OotmEndDrawer extends StatelessWidget {
  final double endDrawerAnimationOffset;
  const OotmEndDrawer({Key key, this.endDrawerAnimationOffset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final endDrawerProvider = Provider.of<EndDrawerProvider>(context);
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width * this.endDrawerAnimationOffset.abs(),
        color: Color(0xFF333333),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: ListTile(
                title: Text(
                  "Ustawienia",
                  style: TextStyle(color: Colors.white, fontSize: 23.0, fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                  icon: Icon(OotmIconPack.close, color: Colors.white),
                  onPressed: () => endDrawerProvider.change(),
                  // ,
                ),
              ),
            ),
            // ListTile(
            //   leading: Icon(
            //     OotmIconPack.sbar_notifications, color: Colors.white,
            //   ),
            //   title: Text(
            //     "Powiadomienia",
            //     style: TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold),
            //   ),
            // ),
            ListTile(
              leading: Icon(OotmIconPack.menu_onboarding,color: Colors.white,),
              title: Text(
                "Samouczek",
                style: TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: Icon(OotmIconPack.menu_help_feedback, color: Colors.white,),
              title: Text(
                "Pomoc i feedback",
                style: TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute<void>(builder: (BuildContext context) {
                //     return null;
                //   })
                // );
              },
            ),
            ListTile(
              leading: Icon(OotmIconPack.menu_privacy, color: Colors.white,),
              title: Text(
                "Dane i prywatność",
                style: TextStyle(color: Colors.white, fontSize: 17.0, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute<void>(builder: (BuildContext context) {
                //     return null;
                //   })
                // );
              },
            ),
          ],
        ),),
    );
  }
}


class EndDrawerProvider with ChangeNotifier {
  bool opened = false;

  void change() {
    opened = !opened;
    // print(opened);
    notifyListeners();
  }
}