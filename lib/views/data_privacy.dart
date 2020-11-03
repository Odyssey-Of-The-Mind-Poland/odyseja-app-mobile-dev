import 'package:flutter/material.dart';
import '../widgets/appbar.dart';
class DataPrivacyRoute extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBarOotm(
          leadingIcon: true,
          title: Text("Dane i Prywatność"),
        ),
        body: Text("Dane i Prywatność")
      );
    }
}