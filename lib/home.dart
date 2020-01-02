import 'package:flutter/material.dart';

import 'common_widgets.dart';

class HomePage extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: ootmAppBar("Home", false),
        body: Text("Home"));
    }
}