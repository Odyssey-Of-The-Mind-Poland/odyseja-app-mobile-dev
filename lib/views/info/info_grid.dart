import 'package:flutter/material.dart';

class InfoGridView extends StatelessWidget {
  final List<Widget> children;
  const InfoGridView({Key key, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 16.0,
      mainAxisSpacing: 16.0,
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      children: this.children,
    );
  }
}