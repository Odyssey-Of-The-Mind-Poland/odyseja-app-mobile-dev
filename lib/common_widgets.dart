import 'package:flutter/material.dart';
import 'ootm_icon_pack.dart';
import 'data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';



class PerformanceGroupWidget extends StatefulWidget {
  final List<Performance> data;
  final String age;
  final String problem;
  final String stage;
  final String filterBy;

  const PerformanceGroupWidget({Key key, this.data, this.age, this.problem,
  this.stage, this.filterBy}) : super(key: key);

  @override
  _PerformanceGroupWidgetState createState() => _PerformanceGroupWidgetState();
}

class _PerformanceGroupWidgetState extends State<PerformanceGroupWidget> {
  bool folded = true;
  @override
  Widget build(BuildContext context) {
  int count = widget.data.length;
  // print(count);
  // print(widget.data);
    int itemCounter(int _count) {
      if (_count < 3)
      return _count;
      else 
      return 3;
    } 


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: PerformanceGroupHeadline(
            stage: this.widget.stage,
            problem: this.widget.problem,
            age: this.widget.age,
            filterBy: this.widget.filterBy,
            ),
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          primary: false,
          shrinkWrap: true,
          padding: const EdgeInsets.all(16.0),
          itemCount: folded ? itemCounter(count) : widget.data.length,
          itemBuilder: (BuildContext context, int index) {
            return new SwipeStack(performance: widget.data[index],);
          },
        ),
        count > 3 ? RawMaterialButton(
          onPressed: () => setState(() {
            folded = !folded;
          }),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "ZOBACZ WSZYSTKO",
                style: TextStyle(
                  color: Color(0xFFFF951A)
                ),
              ),
              Icon(folded ? 
                  Icons.keyboard_arrow_down :
                  Icons.keyboard_arrow_up,
                color: Color(0xFFFF951A),
              ),
            ],
          ),
        ) : SizedBox(),
        ],
    );
  }
}



class PerformanceGroupHeadline extends StatelessWidget {
  final String stage;
  final String problem;
  final String age;
  final String filterBy;

  const PerformanceGroupHeadline({Key key, @required this.stage, @required this.problem,
  @required this.age, @required this.filterBy}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    String headline;
    String problem = "Problem ${this.problem}";
    String stage = "Scena ${this.stage}";
    String age = "Gr. wiekowa ${this.age}";
    switch (filterBy) {
      case 'stage':
        headline = "$problem - $age";
        break;
      case 'problem':
        headline = "$stage - $age";
        break;
      case 'age':
        headline = "$stage - $problem";
        break;
      default: headline = "$stage - $problem - $age";
    }
    return Headline(text: headline,);
  }
}



class SwipeStack extends StatefulWidget {
  final Performance performance;
  
  const SwipeStack({Key key, this.performance}) : super(key: key);
  @override
  _SwipeStackState createState() => _SwipeStackState();
}

class _SwipeStackState extends State<SwipeStack> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: Container(
                height: 48.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: widget.performance.faved ? 
                  Color(0xFFFF951A) : Color(0xFF333333),
                  // boxShadow: z,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 48.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xFF333333),
                ),
              ),
            )
          ],
        ),
        Slidable(
          actionPane: SlidableBehindActionPane(),
          actionExtentRatio: 0.30,
          child: RawMaterialButton(
            onPressed: () => _showPerformancePopup(context),
            child: PerformanceCard(performance: widget.performance, favColor: Color(0xFFFF951A))),
          actions: <Widget>[
            RawMaterialButton(
              child: widget.performance.faved ? 
                Icon(OotmIconPack.favs_full, color: Colors.white) :
                Icon(OotmIconPack.favs_outline, color: Colors.white),
              onPressed: () {
                setState(() =>
                widget.performance.faved = !widget.performance.faved);
                widget.performance.save();
              },
            )
          ],
          secondaryActions: <Widget>[
            Container(
              height: 48.0,
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 14.0),
              child: Text(
                "SPO ${widget.performance.spontan}",
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


  _showPerformancePopup(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            bool _faved = widget.performance.faved;
            return CupertinoAlertDialog(
              content: 
                Text(
                  """${widget.performance.team}\n
                  Scena ${widget.performance.stage} - 
                  Gr. wiekowa ${widget.performance.age} - 
                  Problem ${widget.performance.problem}\n
                  ${widget.performance.play} - Występ\n
                  ${widget.performance.spontan} - Spontan
                  """,
                  style: TextStyle(color: _faved ? Colors.white : Colors.black),
                  ),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: _faved ? 
                    Icon(OotmIconPack.favs_full) :
                    Icon(OotmIconPack.favs_outline),
                  onPressed: () {
                    setState(() =>
                      widget.performance.faved = !widget.performance.faved);
                      widget.performance.save();
                      super.setState(() {});
                  }
                ),
                CupertinoDialogAction(
                  child: Icon(OotmIconPack.close),
                  onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                ),
              ],
            );
          }
        );
      }
    );
  }
}


class PerformanceCard extends StatelessWidget {
  final Performance performance;
  final Color favColor;

  PerformanceCard({Key key, @required this.performance, @required this.favColor}): super(key: key);

  @override
  Widget build(BuildContext context) {
    bool finals;
    String day;
    if (performance.city == "Gdynia_Sobota") {
      finals = true;
      day = "Sobota";
    } else if (performance.city == "Gdynia_Niedziela"){
      finals = true;
      day = "Niedziea";
    } else {
      finals = false;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: 48.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: finals ?
              Stack(
                // overflow: Overflow.visible,
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Positioned(
                    bottom: 24.0,
                    child: Text(day, style: TextStyle(fontSize: 8.0),)),
                  Text(
                    performance.play,
                    style: TextStyle(
                      height: 1.5,
                      color: performance.faved ?
                        this.favColor
                        :
                        Colors.black,
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
              : 
              Text(
                performance.play,
                style: TextStyle(
                  color: performance.faved ?
                    this.favColor
                    :
                    Colors.black,
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Text(
                performance.team,
                softWrap: true,
                style: TextStyle(
                  color: performance.faved ?
                    this.favColor
                    :
                    Colors.black,
                  fontSize: 13.0,
                ),
                overflow: TextOverflow.fade,
              ),
            ),
            IconButton(
              icon: Icon(Icons.keyboard_arrow_right),
              onPressed: null,
              padding: EdgeInsets.all(0.0),
            )],
        ),
            decoration: whiteBoxDecoration(),
        ),
    );
  }
}


class Headline extends StatelessWidget {
  final String text;

  const Headline({Key key, this.text}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
    brightness: Brightness.light,
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
    opened = !opened;
    // print(opened);
    notifyListeners();
  }
}
