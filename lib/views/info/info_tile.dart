import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:ootm_app/data/info.dart';
import 'package:ootm_app/models/city_data_model.dart';
import 'package:ootm_app/widgets/appbar.dart';
import 'package:ootm_app/widgets/box_decoration.dart';
import 'package:ootm_app/widgets/category_box.dart';
import 'package:provider/provider.dart';

class InfoTile extends StatelessWidget {
  final String label;
  final String imageName;
  final int index;
  const InfoTile({Key key, @required this.label, this.imageName, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GreyBox(
        decoration: imageBoxDecoration(this.imageName),
        label: this.label,
        fontSize: 15.0,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute<void>(builder: (BuildContext context) {
            final cityProvider = Provider.of<CityDataModel>(context);
            List<Info> info = cityProvider.infoList;
            return Scaffold(
              appBar: AppBarOotm(
                leadingIcon: true,
                title: Text(info.elementAt(this.index).infName),
              ),
              body: Markdown(
                padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 72.0),
                // data: info.elementAt(this.index).infoText,
                data: info.elementAt(this.index).infoText,
              ),
            );
            // body: Markdown(data: "# headline \n something something",));
          }));
        } // child: child,
        );
  }
}
