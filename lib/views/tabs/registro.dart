import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:waterreminder/blocs/preferencias_bloc.dart';
import 'package:waterreminder/components/info_card.dart';
import 'package:waterreminder/components/water_slider.dart';
import 'package:waterreminder/config/config_cores.dart';
import 'package:waterreminder/model/preferencias.dart';

class Registro extends StatelessWidget {
  final _preferencias = BlocProvider.getBloc<PreferenciasBloc>();
  final date = DateFormat("d MMMM").format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Hoje $date",
                style: Theme.of(context).textTheme.title,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 50.0),
              child: InfoCard(
                icon: MdiIcons.checkCircle,
                text: "Concluido",
                subtitle: "0 ml",
                invertido: true,
                bordaNormal: false,
                verticalPadding: 8,
                color: ConfigCores.branco50,
              ),
            ),
            StreamBuilder<Preferencias>(
              stream: _preferencias.preferenciasStream,
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.only(left: 50.0),
                  child: InfoCard(
                    icon: MdiIcons.target,
                    subtitle: "${snapshot?.data?.metaDiaria ?? 0} ml",
                    verticalPadding: 8,
                    bordaNormal: false,
                    text: "Meta diária",
                    color: ConfigCores.branco50,
                  ),
                );
              }
            ),
            Padding(
              padding: const EdgeInsets.only(right: 50.0),
              child: InfoCard(
                icon: MdiIcons.fire,
                text: "Atinja sua meta",
                subtitle: "E acenda a chama!",
                verticalPadding: 8,
                invertido: true,
                bordaNormal: false,
                color: ConfigCores.vermelho,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8.0),
              decoration: BoxDecoration(
                  color: ConfigCores.branco,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  )),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: WaterSlider(
                        min: 0,
                        max: 500,
                        value: 0,
                        divisions: 20,
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: SizedBox(
                            width: 55,
                            height: 55,
                            child: RaisedButton(
                              color: ConfigCores.azulEscuro,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              onPressed: () {},
                              child: Icon(
                                MdiIcons.cup,
                                color: ConfigCores.branco,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
