import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:waterreminder/blocs/consumo_diario_bloc.dart';
import 'package:waterreminder/blocs/historico_bloc.dart';
import 'package:waterreminder/blocs/preferencias_bloc.dart';
import 'package:waterreminder/components/info_card.dart';
import 'package:waterreminder/components/water_slider.dart';
import 'package:waterreminder/config/config_cores.dart';
import 'package:waterreminder/model/analise_consumo.dart';
import 'package:waterreminder/model/consumo_diario.dart';
import 'package:waterreminder/model/preferencias.dart';

class Registro extends StatefulWidget {
  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final _preferencias = BlocProvider.getBloc<PreferenciasBloc>();
  final _consumoBloc = BlocProvider.getBloc<ConsumoDiarioBloc>();
  final _historicoBloc = BlocProvider.getBloc<HistoricoBloc>();
  final date = DateFormat("d MMMM").format(DateTime.now());

  int _valueSlider = 0;

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
            StreamBuilder<ConsumoDiario>(
                stream: _consumoBloc.stream,
                initialData: ConsumoDiario(),
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 50.0),
                    child: InfoCard(
                      icon: MdiIcons.checkCircle,
                      text: "Concluido",
                      subtitle: "${snapshot.data.consumo} ml",
                      invertido: true,
                      bordaNormal: false,
                      verticalPadding: 8,
                      color: snapshot.data.atingiuMeta
                          ? ConfigCores.branco
                          : ConfigCores.branco50,
                    ),
                  );
                }),
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
                }),
            StreamBuilder<List<ConsumoDiario>>(
                stream: _historicoBloc.historicoStream,
                builder: (context, snapshot) {
                  final analiseConsumo = _historicoBloc.diasConsecutivos();
                  final plural  = analiseConsumo.diasConsecutivos  > 1 ? "s" : "";

                  if (!analiseConsumo.hasDiasConsecutivos &&
                      analiseConsumo.hasSequenciaAtual) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 50.0),
                      child: InfoCard(
                        icon: MdiIcons.fire,
                        text: "Sequência  atual",
                        subtitle:
                            "${analiseConsumo.sequenciaAtual} dias consecutivos$plural",
                        verticalPadding: 8,
                        invertido: true,
                        bordaNormal: false,
                        color: ConfigCores.vermelho,
                      ),
                    );
                  }
                  if (analiseConsumo.hasDiasConsecutivos &&
                      analiseConsumo.hasSequenciaAtual) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 50.0),
                      child: InfoCard(
                        icon: MdiIcons.fire,
                        text: "Muito bom!",
                        subtitle:
                            "${analiseConsumo.diasConsecutivos} dias consecutivos$plural",
                        verticalPadding: 8,
                        invertido: true,
                        bordaNormal: false,
                        color: ConfigCores.vermelho,
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(right: 50.0),
                    child: InfoCard(
                      icon: MdiIcons.fire,
                      text: "Atinja sua meta",
                      subtitle:
                          "e  acenda  a  chama!",
                      verticalPadding: 8,
                      invertido: true,
                      bordaNormal: false,
                      color: ConfigCores.branco50,
                    ),
                  );
                }),
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
                        value: _valueSlider,
                        divisions: 20,
                        onChanged: (value) {
                          setState(() {
                            _valueSlider = value;
                          });
                        },
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
                              onPressed: () async {
                                await _consumoBloc
                                    .adicionarConsumo(_valueSlider);
                                setState(() {
                                  _valueSlider = 0;
                                });
                              },
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
