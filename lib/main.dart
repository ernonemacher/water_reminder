import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:waterreminder/blocs/acesso_bloc.dart';
import 'package:waterreminder/blocs/usuario_bloc.dart';
import 'package:waterreminder/config/config_rotas.dart';
import 'package:waterreminder/config/config_tema.dart';
import 'package:waterreminder/views/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [
        Bloc((i) => AcessoBloc()),
        Bloc((i) => UsuarioBloc()),
      ],
      child: MaterialApp(
        title: 'Water Reminder',
        debugShowCheckedModeBanner: false,
        theme: ConfigTema.build(),
        routes: ConfigRotas.build(),
        home: SplashScreen(),
      ),
    );
  }
}
