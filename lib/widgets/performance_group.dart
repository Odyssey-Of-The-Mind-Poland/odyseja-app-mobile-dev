import 'package:flutter/material.dart';
import 'package:ootm_app/data/performance.dart';
import 'package:ootm_app/widgets/performance_headline.dart';
import 'package:ootm_app/widgets/swipe_stack.dart';

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