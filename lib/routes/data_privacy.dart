import 'package:flutter/material.dart';
import '../common_widgets.dart';

class DataPrivacyRoute extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBarOotm(
          leadingIcon: true,
          title: "Dane i Prywatność",
        ),
        body: Text("Dane i Prywatność")
      );
    }
}