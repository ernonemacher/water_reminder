import 'dart:convert';

class ConsumoDiario {
  String key;
  DateTime dia;
  int metaDiaria;
 int consumo;
 String usuario;

 ConsumoDiario({
   this.key,
   this.dia,
   this.metaDiaria: 0,
   this.consumo: 0,
   this.usuario,
});
bool get atingiuMeta => consumo >= metaDiaria;

 Map<String,dynamic> toJson() {
   final map = Map<String, dynamic>();
   map["dia"] = this.dia.millisecondsSinceEpoch;
   map["metaDiaria"] = this.metaDiaria;
   map["consumo"] = this.consumo;
   map["usuario"] = this.usuario;

   return map;
 }

 ConsumoDiario.fromJson(String key, Map<String,dynamic> json) {
   this.key = key;

   metaDiaria = json['metaDiaria'];
   consumo = json['consumo'];
   usuario = json['usuario'];
   dia = DateTime.fromMillisecondsSinceEpoch(json['dia']);
 }

}