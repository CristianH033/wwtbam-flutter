    
import 'dart:convert';

RespuestasPartida respuestasPartidaFromJson(String str) {
  final jsonData = json.decode(str);
  return RespuestasPartida.fromMap(jsonData);
}

String respuestasPartidaToJson(RespuestasPartida data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class RespuestasPartida {
  int partidaId;
  int respuestaId;
  String fecha;

  RespuestasPartida({
    this.partidaId,
    this.respuestaId,
    this.fecha,
  });

  factory RespuestasPartida.fromMap(Map<String, dynamic> json) => new RespuestasPartida(
        partidaId: json["partida_id"],
        respuestaId: json["respuesta_id"],
        fecha: json["fecha"],
      );

  Map<String, dynamic> toMap() => {
        "partida_id": partidaId,
        "respuesta_id": respuestaId,
        "fecha": fecha,
      };
}