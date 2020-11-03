import 'package:flutter/material.dart';

class GreyBox extends StatelessWidget {
  final String label;
  final double fontSize;
  final Decoration decoration;
  final GestureTapCallback onPressed;
  GreyBox({this.onPressed, @required this.label, @required this.fontSize, @required this.decoration});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RawMaterialButton(
        
        onPressed: this.onPressed,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              this.label,
              style: TextStyle(
                color: Colors.white,
                fontSize: this.fontSize,
                fontWeight: FontWeight.w500,
                ), 
              softWrap: true,
              ),
            ),
        ),
      ),
      decoration: this.decoration,
    );
  }
}