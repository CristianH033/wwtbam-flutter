    
import 'dart:convert';

Partida partidaFromJson(String str) {
  final jsonData = json.decode(str);
  return Partida.fromMap(jsonData);
}

String partidaToJson(Partida data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Partida {
  int id;
  String fechaCreacion;
  
  Partida({
    this.id,
    this.fechaCreacion,
  });

  factory Partida.fromMap(Map<String, dynamic> json) => new Partida(
        id: json["id"],
        fechaCreacion: json["fecha_creacion"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "fecha_creacion": fechaCreacion
      };
}