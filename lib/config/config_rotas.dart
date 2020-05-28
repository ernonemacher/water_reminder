import 'package:waterreminder/views/boas_vindas.dart';
import 'package:waterreminder/views/home.dart';

class ConfigRotas {
  static const String BOAS_VINDAS = "/";
  static const String HOME = "/home";

  static build() {
    return {
      BOAS_VINDAS: (_) => BoasVindas(),
      HOME: (_) => Home(),
    };
  }
}