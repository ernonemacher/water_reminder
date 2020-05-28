import 'dart:math';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:waterreminder/components/app_background.dart';
import 'package:waterreminder/components/info_card.dart';
import 'package:waterreminder/config/config_cores.dart';
import 'package:waterreminder/config/config_rotas.dart';
import 'package:waterreminder/views/home.dart';

class BoasVindas extends StatefulWidget {
  @override
  _BoasVindasState createState() => _BoasVindasState();
}

class _BoasVindasState extends State<BoasVindas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConfigCores.azulClaro,
      body: AppBackground(
        child: Center(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Transform.rotate(
                    angle: pi / 10,
                    child: Icon(
                      MdiIcons.bellRing,
                      color: ConfigCores.branco,
                      size: 60,
                    ),
                  ),
                ),
                Text(
                  "Water Reminder",
                  style: Theme.of(context).textTheme.headline,
                  textAlign: TextAlign.center,
                ),
                InfoCard(
                  icon: MdiIcons.target,
                  text: "Defina sua meta diária",
                ),
                InfoCard(
                  icon: MdiIcons.checkCircle,
                  text: "Receba Lembretes e Hidrate-se",
                ),
                InfoCard(
                  icon: MdiIcons.fire,
                  text: "Mantenha a chama acessa",
                  color: ConfigCores.vermelho,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, left: 10, right: 10),
                  child: RaisedButton(
                    onPressed: onPressed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "ACESSAR COM",
                          style: Theme.of(context)
                              .textTheme
                              .title
                              .copyWith(color: ConfigCores.azulFacebook),
                        ),
                        Container(
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            MdiIcons.facebook,
                            size: 50,
                            color: ConfigCores.azulFacebook,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onPressed() {
    Navigator.of(context).pushReplacementNamed(ConfigRotas.HOME);
  }
}
