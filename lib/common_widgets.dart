import 'package:flutter/material.dart';
// import 'package:ootm_app/schedule.dart';
import 'ootm_icon_pack.dart';
import 'data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class PerformanceGroup extends StatelessWidget {
  final List<Performance> data;
  const PerformanceGroup({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> performanceCardList = new List<Widget>();
    for (Performance pf in this.data) {
      performanceCardList.add(
        // new PerformanceCard(performance: pf,)
        new SwipeStack(performance: pf,)
      );
    }
    return Column(
      children: <Widget>[
        Headline(
          text:
          """${data[0].stage} - Problem ${data[0].problem}
          """
          ),
        ...performanceCardList,
        ],
    );
  }
}


class PerformanceGroupHeadline extends StatelessWidget {

  const PerformanceGroupHeadline({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Headline(),
    );
  }
}


class SwipeStack extends StatelessWidget {
  final Performance performance;
  final bool finals;
  const SwipeStack({Key key, this.performance, this.finals}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final SlidableController slidableController = SlidableController();
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          height: 48.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Color(0xFF333333),
            // boxShadow: z,
          ),
        ),
        Slidable(
          actionPane: SlidableBehindActionPane(),
          actionExtentRatio: 0.30,
          child: PerformanceCard(performance: performance,),
          actions: <Widget>[
            RawMaterialButton(
              child: Icon(OotmIconPack.favs_outline, color: Colors.white),
              onPressed: null,
            )
          ],
          secondaryActions: <Widget>[
            Container(
              height: 48.0,
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 14.0),
              child: Text(
                "SPO ${performance.spontan}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}


class PerformanceCard extends StatefulWidget {
  final Performance performance;
  final bool finals;

  PerformanceCard({Key key, this.finals, this.performance}): super(key: key);

  @override
  _PerformanceCardState createState() => _PerformanceCardState();
}

class _PerformanceCardState extends State<PerformanceCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: 48.0,
        child: RawMaterialButton(
          onPressed: () {
            _showPerformancePopup(context);
          },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.performance.play,
                    style: TextStyle(
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.performance.team,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 13.0,
                    ),
                    overflow: TextOverflow.fade,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_right),
                  onPressed: null,
                )],
            )
            ),
            decoration: whiteBoxDecoration(),
        ),
    );
    }


  _showPerformancePopup(BuildContext context) {

    Widget _favButton = CupertinoDialogAction(
      child: Icon(OotmIconPack.favs_outline),
      onPressed: null,
    );
    Widget _closeButton = CupertinoDialogAction(
      child: Icon(OotmIconPack.close),
      onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
    );

    CupertinoAlertDialog _dialog = CupertinoAlertDialog(
      content: Text(
        """${widget.performance.team}\n
        Scena ${widget.performance.stage} - 
        Gr. wiekowa ${widget.performance.age} - 
        Problem ${widget.performance.problem}\n
        ${widget.performance.play} - Występ\n
        ${widget.performance.spontan} - Spontan
        """
        ),
      actions: <Widget>[
        _favButton,
        _closeButton,
      ],
    );
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _dialog;
      }
    );
  }
// GestureDetector(onPanUpdate: (details) {
//   if (details.delta.dx > 0) {
//     // swiping in right direction
//   }
}


class Headline extends StatelessWidget {
  final String text;

  const Headline({Key key, this.text}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 17.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}


class GreyBox extends StatelessWidget {
  final String label;
  final double fontSize;
  final GestureTapCallback onPressed;
  GreyBox({this.onPressed, @required this.label, @required this.fontSize});

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
              fontSize: this.fontSize,
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

class AppBarOotm extends StatelessWidget implements PreferredSizeWidget {
  final bool leadingIcon;
  final String title;
  const AppBarOotm({Key key, this.leadingIcon, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final endDrawerProvider = Provider.of<EndDrawerProvider>(context);
    return AppBar(
    automaticallyImplyLeading: false,
    leading: leadingIcon ?
      IconButton(
        icon: Icon(OotmIconPack.favs_outline),
        onPressed: () => Navigator.of(context).maybePop())
      : null,
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
        // onPressed: () => keyScaffold.currentState.openEndDrawer()
        onPressed: () => endDrawerProvider.change()
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(84.0);
}

class EndDrawerProvider with ChangeNotifier {
  bool opened = false;

  void change() {
    if (opened == false) {
      opened = true;
    } else {
      opened = false;
    }
    // print(opened);
    notifyListeners();
  }
}
// class OpenDrawer extends ChangeNotifier {

//   var Scaffold.of(context).OpenDrawer;// set 
// }

// PreferredSizeWidget ootmAppBar(String title, bool leadingIcon) {
//   return AppBar(
//     automaticallyImplyLeading: leadingIcon,
//     // leading: leadingIcon ? IconButton(
//     //     icon: Icon(OotmIconPack.favs_outline),
//     //     onPressed: () => Navigator.of(context).maybePop()) : null,
//     title: Text(title),
//     centerTitle: false,
//     backgroundColor: Colors.transparent,
//     elevation: 0,
//     textTheme: TextTheme(
//       title: TextStyle(
//         fontWeight: FontWeight.bold,
//         color: Colors.black,
//         fontSize: 31,
//         )
//       ),
//     actions: <Widget>[
//       IconButton(
//         disabledColor: Colors.black,
//         icon: Icon(OotmIconPack.sbar_button),
//         onPressed: null,
//         )
//       ],
//     );
// }
