import 'package:flutter/material.dart';
import 'package:waterreminder/config/config_rotas.dart';
import 'package:waterreminder/config/config_tema.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Water Reminder',
      debugShowCheckedModeBanner: false,
      theme: ConfigTema.build(),
      routes: ConfigRotas.build(),
    );
  }
}


