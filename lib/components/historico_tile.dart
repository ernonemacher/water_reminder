import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waterreminder/config/config_cores.dart';
import 'package:waterreminder/model/consumo_diario.dart';

class HistoricoTile extends StatelessWidget {
  final ConsumoDiario consumoDiario;

  final _formatter = DateFormat("d MMMM");

  HistoricoTile({
    @required this.consumoDiario,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 24),
      height: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: consumoDiario.atingiuMeta
                      ? ConfigCores.verde
                      : ConfigCores.branco50,
                ),
                child: Icon(
                  consumoDiario.atingiuMeta ? Icons.check : Icons.close,
                  color: ConfigCores.branco,
                  size: 25,
                ),
              ),
              Container(
                width: 10,
              ),
              Expanded(
                child: Text(
                  DateTime.now().difference(consumoDiario.dia).inDays == 0
                      ? "Hoje"
                      : _formatter.format(consumoDiario.dia),
                  style: Theme.of(context)
                      .textTheme
                      .subhead
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 40,
                  padding: EdgeInsets.only(top: 12),
                  child: VerticalDivider(
                    color: ConfigCores.branco,
                    thickness: 1.0,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildDados(
                        context: context,
                        titulo: "Objetivo",
                        valor: "${consumoDiario.metaDiaria}"),
                    _buildDados(
                        context: context,
                        titulo: "Bebeu",
                        valor: "${consumoDiario.consumo}")
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDados({BuildContext context, String titulo, String valor}) {
    return Row(
      children: <Widget>[
        Container(
          width: 80,
          child: Text(
            titulo,
            style: Theme.of(context).textTheme.body1.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        Container(
          width: 70,
          child: Text(
            "$valor ml",
            style: Theme.of(context).textTheme.body1,
            textAlign: TextAlign.right,
          ),
        )
      ],
    );
  }
}
