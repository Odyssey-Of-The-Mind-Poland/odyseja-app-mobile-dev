import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:ootm_app/widgets/appbar.dart';
import 'package:ootm_app/widgets/box_decoration.dart';
import 'package:ootm_app/widgets/category_box.dart';

class InfoTile extends StatelessWidget {
  final String label;
  final String data;
  final String imageName;
  const InfoTile({Key key, @required this.label, this.data, this.imageName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GreyBox(
      decoration: imageBoxDecoration(this.imageName),
      label: this.label,
      fontSize: 15.0,
      onPressed: () {Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBarOotm(
              leadingIcon: true,
              title: Text(this.label),
            ),
            body: Markdown(data: this.data));
            // body: Markdown(data: "# headline \n something something",));
          })
        );
      }      // child: child,
    );
  }
}