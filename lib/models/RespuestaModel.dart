    
import 'dart:convert';

Respuesta respuestaFromJson(String str) {
  final jsonData = json.decode(str);
  return Respuesta.fromMap(jsonData);
}

String respuestaToJson(Respuesta data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Respuesta {
  int id;
  String texto;
  bool correcta;
  bool seleccionada;
  int preguntaId;

  Respuesta({
    this.id,
    this.texto,
    this.correcta,
    this.seleccionada,
    this.preguntaId
  });

  factory Respuesta.fromMap(Map<String, dynamic> json) => new Respuesta(
        id: json["id"],
        texto: json["texto"],
        correcta: json["correcta"] == 1,
        seleccionada: json["seleccionada"] == 1,
        preguntaId: json["pregunta_id"]
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "texto": texto,
        "correcta": correcta,
        "seleccionada": seleccionada,
        "pregunta_id": preguntaId
      };
}