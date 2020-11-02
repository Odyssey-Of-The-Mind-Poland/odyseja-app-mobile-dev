import 'package:flutter/material.dart';
import 'ootm_icon_pack.dart';
import 'data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


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

class _PerformanceGroupWidgetState extends State<PerformanceGroupWidget> with AutomaticKeepAliveClientMixin{
  bool folded = true;
    int itemCounter(int _count) {
      if (_count < 3)
      return _count;
      else 
      return 3;
    } 
  @override
  Widget build(BuildContext context) {
  super.build(context);
  int count = widget.data.length;
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
                folded 
                ? "ZOBACZ WSZYSTKO"
                : "ZWIŃ",
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

  @override
  bool get wantKeepAlive => true;
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


  _showPerformancePopup(context) async {
    bool isChange = false;
    bool _faved = widget.performance.faved;
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return OotmPopUp(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // Nazwa drużyny
                      Text(
                        "${widget.performance.team}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _faved ? Color(0xFFFF951A) : Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 8.0),
                      // parametry: scena - gr. wiekowa - problem
                      Text(
                        "Scena ${widget.performance.stage.substring(6,7)} - Gr. wiekowa ${widget.performance.age} - Problem ${widget.performance.problem}",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: _faved ? Color(0xFFFF951A) : Colors.white),
                      ),
                      SizedBox(height: 16.0),
                      // godzina występu
                      Text(
                        "${widget.performance.play} - Występ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _faved ? Color(0xFFFF951A) : Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      // info o stawieniu się
                      SizedBox(height: 8.0),
                      Text(
                        "(Drużyna powinna się stawić na 15 minut przed występem)",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _faved ? Color(0xFFFF951A) : Colors.white,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      // godzina spontana
                      Text("${widget.performance.spontan} - Spontan",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      SizedBox(height: 8.0),
                      // info o stawieniu się
                      Text(
                        "(Drużyna powinna się stawić na 20 minut przed występem)",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        isChange = !isChange;
                        _faved = !_faved;
                        setState(() {});
                      },
                      child: _faved ? 
                        Icon(OotmIconPack.favs_full, color: Color(0xFFFF951A)) :
                        Icon(OotmIconPack.favs_outline, color: Colors.white),
                    ),
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Icon(OotmIconPack.close, color: Colors.white, size: 16.0,),
                    ),
                  ],
                )
              ],
            ),
          );
          },
        );
      }
    ).then((value) {
      if (isChange) {
        widget.performance.faved = !widget.performance.faved;
        widget.performance.save();
        super.setState(() {});
      }
    });
  }
}


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
      day = "Niedziela";
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
                      color: Colors.black,
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
                  color: Colors.black,
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
  final Decoration decoration;
  final GestureTapCallback onPressed;
  GreyBox({this.onPressed, @required this.label, @required this.fontSize, @required this.decoration});

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
      decoration: this.decoration,
    );
  }
}

Decoration imageBoxDecoration(imageName) {
  return BoxDecoration(
    image: DecorationImage(image: AssetImage(imageName)),
    // borderRadius: BorderRadius.circular(10.0),
    // color: Color(0xFF333333),
    boxShadow: [blackShadow()]
  );
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

class EndDrawerProvider with ChangeNotifier {
  bool opened = false;

  void change() {
    opened = !opened;
    // print(opened);
    notifyListeners();
  }
}
