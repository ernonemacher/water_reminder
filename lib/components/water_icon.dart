import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:waterreminder/config/config_cores.dart';

class WaterIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Icon(
          MdiIcons.water,
          color: ConfigCores.azulEscuro,
          size: 50,
        ),
        Padding(
          padding: EdgeInsets.only(right: 0,top: 16),
          child: Icon(
            MdiIcons.water,
            color: ConfigCores.branco,
            size: 10,
          ),
        )
      ],
    );
  }
}
