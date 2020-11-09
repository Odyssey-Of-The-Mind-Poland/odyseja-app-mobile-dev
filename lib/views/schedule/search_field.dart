import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ootm_app/data/ootm_icon_pack.dart';
import 'package:ootm_app/widgets/box_decoration.dart';

import 'search_dialog.dart';


/*
Search field is kind of a cheat. It requires semi-transparent modal barier
and list with suggestions and seems to be easier done with fake button launching
a dialog rather than a sophisticated, proper, stacked widget. 
*/
class SearchField extends StatefulWidget {
  final Box box;
  SearchField({Key key, this.box}) : super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  GlobalKey keyFakeSearchField = GlobalKey();
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: RawMaterialButton(
        key: keyFakeSearchField,
        onPressed: () {
          setState(() {
            _isVisible = !_isVisible;
          });
          return showDialog<void>(
            /// Barrier is overriden by [Material], thus enforicing [GestureDetectors].
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return SearchDialog(parentKey: keyFakeSearchField, box: this.widget.box);
            },
          );
        },
        child: Container(
          height: 40.0,
          decoration: whiteBoxDecoration(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text("Szukaj Drużyny..."),
              ),
              Container(
                height: 40.0,
                width: 40.0,
                decoration: orangeBoxDecoration(),
                child: Icon(OotmIconPack.search, color: Colors.white,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}