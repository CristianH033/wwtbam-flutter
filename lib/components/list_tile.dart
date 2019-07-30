// import 'package:flutter/material.dart';
// import 'package:wwtbam_flutter/database/Database.dart';
// // import 'package:wwtbam_flutter/models/JugadorModel.dart';
// import 'package:wwtbam_flutter/models/PartidaModel.dart';
// import 'package:wwtbam_flutter/models/RespuestaModel.dart';

// class ListTilePartida extends StatelessWidget {
//   // a property on this class
//   final Partida partida;
//   final partidaActual;
//   final void Function(Partida partida) callback;

//   // a constructor for this class
//   ListTilePartida(this.callback, this.partida, this.partidaActual);

//   Widget build(context) {
//     // Pass the text down to another widget
//     return new FutureBuilder(
//         future: DBProvider.db.getJugador(partida.jugadorId),
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           if (snapshot.hasData) {
//             return ListTile(
//                 dense: partidaActual != partida.id,
//                 onTap: () => callback(partida),
//                 contentPadding:
//                     EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//                 leading: Container(
//                   padding: EdgeInsets.only(right: 12.0),
//                   decoration: new BoxDecoration(
//                       border: new Border(
//                           right: new BorderSide(
//                               width: 1.0, color: Colors.black12))),
//                   child: Icon(Icons.timeline, color: Colors.black),
//                 ),
//                 title: Text(
//                   "Partida ${partida.id} - ${snapshot.data.nombres} ${snapshot.data.apellidos} - ${snapshot.data.id}",
//                   style: TextStyle(
//                       color: partidaActual == partida.id ? Colors.green : Colors.black, fontWeight: FontWeight.bold),
//                 ),
//                 subtitle: Row(
//                   children: <Widget>[
//                     Icon(Icons.linear_scale, color: Colors.black26),
//                     Text(partida.fechaCreacion,
//                         style: TextStyle(color: partidaActual == partida.id ? Colors.green : Colors.black38))
//                   ],
//                 ),
//                 trailing: Icon(Icons.keyboard_arrow_right,
//                     color: Colors.black38, size: 30.0));
//           } else {
//             return Text("Cargando...");
//           }
//         });
//   }
// }
