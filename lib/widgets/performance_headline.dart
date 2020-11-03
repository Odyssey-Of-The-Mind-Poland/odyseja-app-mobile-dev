import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'headline.dart';


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