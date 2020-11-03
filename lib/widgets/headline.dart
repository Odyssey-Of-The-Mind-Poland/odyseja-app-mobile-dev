import 'package:flutter/material.dart';

class Headline extends StatelessWidget {
  final String text;

  const Headline({Key key, this.text}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 17.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}