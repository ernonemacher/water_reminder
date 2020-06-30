import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waterreminder/blocs/historico_bloc.dart';
import 'package:waterreminder/components/historico_tile.dart';
import 'package:waterreminder/config/config_cores.dart';
import 'package:waterreminder/model/consumo_diario.dart';

class Historico extends StatelessWidget {
  final _historicoBloc = BlocProvider.getBloc<HistoricoBloc>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Histórico completo",
                style: Theme.of(context).textTheme.title,
              ),
            ),
            Expanded(
              child: StreamBuilder<List<ConsumoDiario>>(
                  stream: _historicoBloc.historicoStream,
                  builder: (context, snapshot) {
                    return ListView.builder(
                        padding: EdgeInsets.only(top: 10),
                        itemCount: snapshot.hasData ? snapshot.data.length : 0,
                        itemBuilder: (
                          context,
                          index,
                        ) {
                          ConsumoDiario consumoDiario = snapshot.data[index];
                          return HistoricoTile(
                            consumoDiario: consumoDiario,
                          );
                        });
                  }),
            ),
          ]),
    );
  }
}
