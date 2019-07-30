    
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
  String categoria;

  Pregunta({
    this.id,
    this.texto,
    this.categoria
  });

  factory Pregunta.fromMap(Map<String, dynamic> json) => new Pregunta(
        id: json["id"],
        texto: json["texto"],
        categoria: json["categoria"]
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "texto": texto,
        "categoria": categoria
      };
}