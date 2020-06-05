import 'package:waterreminder/main.dart';

class Usuario {
  String key;
  String facebookId;
  String nome;
  String urlFoto;

  Usuario({this.key, this.facebookId, this.nome, this.urlFoto});

  Usuario.fromJson(String key, Map<String, dynamic> json) {
    this.key = key;
    this.facebookId = json["facebookId"];
    this.nome = json["nome"];
    this.urlFoto = json["urlFoto"];
  }

  Map<String, dynamic> toJson() {
    final map = Map<String, dynamic>();
    map["facebookId"] = this.facebookId;
    map["nome"] = this.nome;
    map["urlFoto"] = this.urlFoto;
    return map;
  }
}
