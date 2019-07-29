    
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
  int jugadorId;
  String fechaCreacion;
  
  Partida({
    this.id,
    this.jugadorId,
    this.fechaCreacion,
  });

  factory Partida.fromMap(Map<String, dynamic> json) => new Partida(
        id: json["id"],
        jugadorId: json["jugador_id"],
        fechaCreacion: json["fecha_creacion"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "jugador_id": jugadorId,
        "fecha_creacion": fechaCreacion
      };
}