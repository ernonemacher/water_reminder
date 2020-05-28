import 'package:flutter/material.dart';
import 'package:waterreminder/config/config_cores.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  AppBackground({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [ConfigCores.azulClaro, ConfigCores.azulEscuro])),
    );
  }
}
