import 'package:flutter/material.dart';

ThemeData defaultTheme() {
  return ThemeData(
    primaryColor: Color(0xFFFF951A),
    fontFamily: 'Raleway',
    primaryTextTheme: textTheme(),
  );

}

TextTheme textTheme() {
  return TextTheme(
    //   body1: TextStyle(color: Color(0xFF333333)),
    //   title: TextStyle(color: Colors.white),
  );
}