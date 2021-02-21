import 'package:flutter/material.dart';
import 'package:ootm_app/commands/change_city_command.dart';
import 'package:ootm_app/data/city.dart';
import 'package:ootm_app/data/ootm_icon_pack.dart';
import 'package:ootm_app/views/main_frame/city_buttons_controller.dart';
import 'package:ootm_app/widgets/box_decoration.dart';
import 'package:provider/provider.dart';

class CityButtonOverlay extends StatefulWidget {
  CityButtonOverlay({Key key}) : super(key: key);

  @override
  _CityButtonOverlayState createState() => _CityButtonOverlayState();
}

class _CityButtonOverlayState extends State<CityButtonOverlay>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  Animation<double> _fadeAnimation;
  AnimationController _controller;

  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 0.7).animate(_animation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Widget> cityButtons(CityButtonsController cs) {
    List<Widget> cityButtons = [];
    double _offset = -1.4166;
    List<City> cities = CitySet.cities.reversed.toList();
    bool isData = true;
    for (City city in cities) {
      isData = ["wroclaw", "poznan"].contains(city.hiveName);
      cityButtons.add(new SlideTransition(
        position: new Tween<Offset>(
          begin: Offset(0.0, 1.0),
          end: Offset(0.0, _offset),
        ).animate(new CurvedAnimation(
          curve: Curves.easeInOut,
          parent: _controller,
        )),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: RawMaterialButton(
            onPressed: isData
                ? () {
                    ChangeCityCommand().change(city);
                    cs.change();
                    // } : Scaffold.of(context).showSnackBar(SnackBar(content: Text("Prosimy uzbroić się w cierpliwość :)"))),
                  }
                : null,
            child: LimitedBox(
              maxHeight: 40.0,
              child: Container(
                alignment: Alignment.center,
                height: 40.0,
                decoration:
                    isData ? orangeBoxDecoration() : greyBoxDecoration(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      city.fullName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (!isData)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(
                          OotmIconPack.locked,
                          size: 14.0,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ));
      _offset -= 1;
    }
    return cityButtons;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Provider.of<CityButtonsController>(context, listen: true);
    if (cs.opened) {
      _isVisible = true;
      _controller.forward();
    } else {
      _controller.reverse().then((value) {
        setState(() {
          _isVisible = false;
        });
      });
    }
    return Visibility(
      visible: _isVisible,
      maintainState: true,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          FadeTransition(
            opacity: _fadeAnimation,
            child: GestureDetector(
              behavior: cs.opened
                  ? HitTestBehavior.opaque
                  : HitTestBehavior.translucent,
              onTap: cs.opened ? cs.change : null,
              child: Container(
                decoration: BoxDecoration(color: Colors.black),
              ),
            ),
          ),
          ...cityButtons(cs),
        ],
      ),
    );
  }
}
