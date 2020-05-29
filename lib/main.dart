import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:waterreminder/blocs/acesso_bloc.dart';
import 'package:waterreminder/config/config_rotas.dart';
import 'package:waterreminder/config/config_tema.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [
        Bloc((i) => AcessoBloc()),
      ],
      child: MaterialApp(
        title: 'Water Reminder',
        debugShowCheckedModeBanner: false,
        theme: ConfigTema.build(),
        routes: ConfigRotas.build(),
      ),
    );
  }
}


