import 'package:flutter/material.dart';
import 'config_cores.dart';

class ConfigTema {
  static ThemeData build() {
    return ThemeData(
      primaryColor: ConfigCores.azulEscuro,
      accentColor: ConfigCores.branco,
      buttonColor: ConfigCores.branco,
      toggleableActiveColor: ConfigCores.azulEscuro,
      textTheme: TextTheme(
        headline: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          color: ConfigCores.branco,
        ),
        title: TextStyle(
          fontSize: 26.0,
          fontWeight: FontWeight.w500,
          color: ConfigCores.branco,
        ),
        subhead: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.normal,
          color: ConfigCores.branco,
        ),
        body1: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.normal,
          color: ConfigCores.branco,
        ),
      ),
    );
  }
}
