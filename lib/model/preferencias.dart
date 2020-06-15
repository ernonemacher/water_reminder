import 'package:firebase_database/firebase_database.dart';

class Preferencias {
  String key;
  String usuario;
  int metaDiaria;
  bool recebeLembretes;

  Preferencias({
   this.key,
   this.usuario,
   this.metaDiaria: 2000,
   this.recebeLembretes: true,
});

  Preferencias.fromSnapshot(DataSnapshot snapshot) {
    key = snapshot.key;
    usuario = snapshot.value["usuario"];
    metaDiaria = snapshot.value["metaDiaria"];
    recebeLembretes = snapshot.value["recebeLembretes"];
  }

  Map<String, dynamic> toJson() {
    final map = Map<String, dynamic>();
    map["usuario"] = this.usuario;
    map["metaDiaria"] = this.metaDiaria;
    map["recebeLembretes"] = this.recebeLembretes;
    return map;
  }
}