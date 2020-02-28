import 'package:flutter/material.dart';
import '../common_widgets.dart';

class DataPrivacyRoute extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBarOotm(
          leadingIcon: true,
          title: Text("O aplikacji"),
        ),
        body: Text("o Aplikacji")
      );
    }
}