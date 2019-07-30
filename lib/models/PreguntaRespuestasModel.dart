    
import 'dart:convert';

import 'package:wwtbam_flutter/models/RespuestaModel.dart';

PreguntaRespuestas preguntaFromJson(String str) {
  final jsonData = json.decode(str);
  return PreguntaRespuestas.fromMap(jsonData);
}

String preguntaToJson(PreguntaRespuestas data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class PreguntaRespuestas {
  int id;
  String texto;
  String categoria;
  List<Respuesta> respuestas;

  PreguntaRespuestas({
    this.id,
    this.texto,
    this.categoria,
    this.respuestas,
  });

  factory PreguntaRespuestas.fromMap(Map<String, dynamic> json) => new PreguntaRespuestas(
        id: json["id"],
        texto: json["texto"],
        categoria: json["categoria"],
        respuestas: json["respuestas"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "texto": texto,
        "categoria": categoria,
        "respuestas": respuestas,
      };
}