import 'package:flutter/material.dart';
import '../widgets/appbar.dart';

class HelpFeedbackRoute extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBarOotm(
          leadingIcon: true,
          title: Text("Pomoc i feedback"),
        ),
        body: Text("Pomoc i feedback")
      );
    }
}