
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'dart:async';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:wwtbam_flutter/database/Database.dart';
import 'package:wwtbam_flutter/models/JugadorModel.dart';
import 'package:wwtbam_flutter/models/PartidaModel.dart';
import 'package:wwtbam_flutter/models/PreguntaModel.dart';
import 'package:wwtbam_flutter/models/RespuestaModel.dart';
import 'package:wwtbam_flutter/models/RespuestasPartidaModel.dart';



Future reportePDF() async {
  
  final Document pdf = Document(deflate: zlib.encode);
  final List<Widget> widgets = await ListMyWidgets();

  pdf.addPage(MultiPage(
      pageFormat:
          PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
      crossAxisAlignment: CrossAxisAlignment.start,
      header: (Context context) {
        return Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            decoration: const BoxDecoration(
                border:
                    BoxBorder(bottom: true, width: 0.5, color: PdfColors.grey)),
            child: Text('Resultados juego',
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      footer: (Context context) {
        return Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: Text('Página ${context.pageNumber} de ${context.pagesCount}',
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      build: (Context context) => widgets));
  
  var xx = await getPath();
  // print(xx);

  final File file = File(xx);
  file.writeAsBytesSync(pdf.save());
  final ByteData bytes = await rootBundle.load(xx);
  await Share.file('reporte', 'resultados.pdf', bytes.buffer.asUint8List(), 'application/pdf');
  // Share.file(path: xx, mimeType: ShareType.fromMimeType('application/pdf'), title: 'Resultados', text: 'Hola!!');
}

Future<List<Widget>> ListMyWidgets() async {
  final ByteData fontByteData = await rootBundle.load("assets/font/OpenSans.ttf");
  final Uint8List fontData = fontByteData.buffer.asUint8List(fontByteData.offsetInBytes, fontByteData.lengthInBytes);
  final Font ttf = Font.ttf(fontData.buffer.asByteData());

  final List<Partida> partidas = await DBProvider.db.getAllPartidas();
  List<Widget> list = new List();
  for(Partida partida in partidas) {
    Jugador j = await DBProvider.db.getJugador(partida.jugadorId);
    List<RespuestasPartida> rps = await DBProvider.db.getRespuestasPartida(partida.id);
    print(partida.id);
    // print(j.id);
    // String nombres = ('${j.nombres} ${j.apellidos}').replaceAll(new RegExp(r'ñ'), 'n');
    list.add( new Header(level: 1, textStyle: TextStyle(font: ttf), text: '${j.nombres} ${j.apellidos}\n\nc.c ${j.id}\n\n${j.correo}\n\nPartida ${partida.id} (${partida.fechaCreacion})') );
    // list.add( new Header(level: 1, text: 'CC: ${j.id} - ${j.nombres} ${j.apellidos} - ${j.correo}') );
    // list.add( new Header(level: 1, text: 'Partida ${partida.id} - ${j.nombres} ${j.apellidos} - ${j.id}') );
    for (RespuestasPartida rp in rps){
      Respuesta respuesta = await DBProvider.db.getRespuesta(rp.respuestaId);
      Pregunta pregunta = await DBProvider.db.getPregunta(respuesta.preguntaId);
      // print(pregunta.id);
      // print(pregunta.texto);
      // String pt = pregunta.texto.replaceAll(new RegExp(r'“'), '"');
      // pt = pt.replaceAll(new RegExp(r'”'), '"');
      // pt = pt.replaceAll(new RegExp(r'ñ'), 'n');
      // pt = String.fromCharCodes(utf8.encode(pt));
      list.add(Header(level: 2, text: 'Pregunta: ${pregunta.texto}', textStyle: TextStyle(font: ttf)));
      list.add(Bullet(text: 'Respuesta: ${respuesta.texto} ${respuesta.correcta ? "(Correcta)" : "(Incorrecta)"}.', style:  TextStyle(font: ttf) ) );
    }
    list.add(Padding(padding: const EdgeInsets.all(10)));
  }
  return list;
}

Future<String> getPath() async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  return path.join(documentsDirectory.path, "example.pdf");
}