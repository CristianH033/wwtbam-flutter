    
import 'dart:convert';

Pregunta preguntaFromJson(String str) {
  final jsonData = json.decode(str);
  return Pregunta.fromMap(jsonData);
}

String preguntaToJson(Pregunta data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Pregunta {
  int id;
  String texto;
  int puntaje;

  Pregunta({
    this.id,
    this.texto,
    this.puntaje
  });

  factory Pregunta.fromMap(Map<String, dynamic> json) => new Pregunta(
        id: json["id"],
        texto: json["texto"],
        puntaje: json["puntaje"]
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "texto": texto,
        "puntaje": puntaje
      };
}