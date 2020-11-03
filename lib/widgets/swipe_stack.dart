import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ootm_app/data/ootm_icon_pack.dart';
import 'package:ootm_app/data/performance.dart';
import 'performance_card.dart';
import 'performance_popup.dart';

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