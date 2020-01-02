
import 'package:flutter/material.dart';
import 'ootm_icon_pack.dart';

class GreyBox extends StatelessWidget {
  final String label;
  final GestureTapCallback onPressed;
  GreyBox({this.onPressed, @required this.label});

  @override
  Widget build(BuildContext context) {
  return Container(
    child: RawMaterialButton(
      onPressed: this.onPressed,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            this.label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              ), 
            softWrap: true,
            ),
          ),
      ),
    ),
    decoration: greyBoxDecoration(),
    );
  }
}


Decoration whiteBoxDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(10.0),
    color: Colors.white,
    boxShadow: [blackShadow()],
  );
}


Decoration greyBoxDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(10.0),
    color: Color(0xFF333333),
    boxShadow: [blackShadow()],
  );
}

Decoration orangeBoxDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(10.0),
    color: Color(0xFFFF951A),
    boxShadow: [orangeShadow()],
  );
}


BoxShadow blackShadow() {
  return BoxShadow(
      color: Color(0x52333333),
      blurRadius: 6.0,
      offset: Offset(0.0, 3.0),
    );
}


BoxShadow orangeShadow() {
  return BoxShadow(
      color: Color(0x52FD8800),
      blurRadius: 6.0,
      offset: Offset(0.0, 3.0),
    );
}


PreferredSizeWidget ootmAppBar(String title, bool implyLeading) {
  return AppBar(
    automaticallyImplyLeading: implyLeading,
    title: Text(title),
    centerTitle: false,
    backgroundColor: Colors.transparent,
    elevation: 0,
    textTheme: TextTheme(
      title: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontSize: 31,
        )
      ),
    actions: <Widget>[
      IconButton(
        disabledColor: Colors.black,
        icon: Icon(OotmIconPack.sbar_button),
        onPressed: null,
        )
      ],
    );
}
