import 'package:flutter/material.dart';
import '../common_widgets.dart';

class HelpFeedbackRoute extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBarOotm(
          leadingIcon: true,
          title: "Pomoc i feedback",
        ),
        body: Text("Pomoc i feedback")
      );
    }
}