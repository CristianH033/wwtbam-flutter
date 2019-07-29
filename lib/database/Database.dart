import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wwtbam_flutter/models/JugadorModel.dart';
import 'package:wwtbam_flutter/models/PartidaModel.dart';
import 'package:wwtbam_flutter/models/PreguntaModel.dart';
import 'package:wwtbam_flutter/models/RespuestaModel.dart';
import 'package:wwtbam_flutter/models/RespuestasPartidaModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'dart:io' as io;

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    // await deleteDB();
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  deleteDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "wanapo.db");
    bool existe = await io.File(path).exists();
    // print(existe);
    if( existe ){
      await io.File(path).delete();
    }
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "wanapo.db");
    // print(path);
    return await openDatabase(
      path, 
      version: 1, 
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute(
           "CREATE TABLE 'jugadores'"
            "("
            " 'id'         INTEGER PRIMARY KEY,"
            " 'nombres'    varchar(255) NOT NULL ,"
            " 'apellidos'  varchar(255) NOT NULL ,"
            " 'correo'  varchar(255) NOT NULL ,"
            " 'fecha_creacion'   varchar(255) NOT NULL"
            ")"
        );

        await db.execute(
            "CREATE TABLE 'partidas'"
            "("
            " 'id'         INTEGER PRIMARY KEY,"
            " 'jugador_id' integer NOT NULL ,"
            " 'fecha_creacion'   varchar(255) NOT NULL,"
            " FOREIGN KEY ('jugador_id') REFERENCES 'jugadores' ('id')"
            ")"
        );

        await db.execute(
            "CREATE TABLE 'preguntas'"
            "("
            " 'id'      INTEGER PRIMARY KEY,"
            " 'texto'   varchar(255) NOT NULL ,"
            " 'puntaje' integer NOT NULL"
            ")"
        );

        await db.execute(
            "CREATE TABLE 'respuestas'"
            "("
            " 'id'          INTEGER PRIMARY KEY,"
            " 'texto'       varchar(255) NOT NULL ,"
            " 'correcta'    BIT,"
            " 'pregunta_id' integer NOT NULL ,"
            " FOREIGN KEY ('pregunta_id') REFERENCES 'preguntas' ('id')"
            ")"
        );

        await db.execute(
            "CREATE TABLE 'respuestas_partida'"
            "("
            " 'partida_id'   integer NOT NULL ,"
            " 'respuesta_id' integer NOT NULL ,"
            " 'fecha'        varchar(255) NOT NULL ,"
            " FOREIGN KEY ('partida_id') REFERENCES 'partidas' ('id'),"
            " FOREIGN KEY ('respuesta_id') REFERENCES 'respuestas' ('id')"
            ")"
        );

        // await db.execute(
        //     "INSERT INTO jugadores"
        //     "(id, nombres, apellidos, correo, fecha_creacion)"
        //     "VALUES(1057015139, 'Cristian', 'Home', 'cristian_david033@hotmail.com', 0)"
        // );

        await db.execute(
            "INSERT INTO preguntas"
            "(id, texto, puntaje)"
            "VALUES (1, 'Según los datos presentados por el censo del Dane 2005 la población aproximada de la etnia Wayuu en el territorio nacional era de aproximadamente:', 1),"
            "(2, 'Para construir Líneas de alta Tensión en Colombia se requiere:', 1),"
            "(3, 'Dentro de la cosmovisión del pueblo Wayuu se identifican diferentes tipologías de lugares las cuales presentan varias connotaciones dentro del pensamiento y las tradiciones del pueblo Wayuu, estos son:', 1),"
            "(4, 'Los Wayuu son un pueblo:', 1),"
            "(5, 'El mestizaje racial en Colombia está conformado por:', 1),"
            "(6, 'La Mayor parte de la energía en Colombia provienen de:', 1),"
            "(7, 'La práctica cultural de “Desentierro” o “Segundo Velorio” los WAYUU la realizan entre los meses de:', 1),"
            "(8, 'La palabra Energía Eléctrica en WAYUUNAIKI se escribe', 1),"
            "(9, '¿Cuál es el Nombre de la Ministra De Minas y Energía?', 1)"
        );

        await db.execute(
            "INSERT INTO respuestas"
            "(id, texto, correcta, pregunta_id)"
            "VALUES (1,'Entre 150.000 a 200.000 Personas',0,1),"
            "(2,'Entre 900.000 a 950.000 Personas',0,1),"
            "(3,'Entre 250.000 a 300.000 Personas (270.413)',1,1),"
            "(4,'Ninguna de las Anteriores',0,1),"
            "(5,'Licencia Ambiental.',0,2),"
            "(6,'Permisos Ambientales ante autoridades regionales competentes',0,2),"
            "(7,'Prospecciones Arqueológica',0,2),"
            "(8,'Todas las Anteriores',1,2),"
            "(9,'Prohibidos, Encantados, Comunales',1,3),"
            "(10,'Divinos, Prohibidos, Cementerios',0,3),"
            "(11,'Encantados, Cementerios, Divinos',0,3),"
            "(12,'Ninguna de las Anteriores',0,3),"
            "(13,'Sedentario',0,4),"
            "(14,'Nómada',1,4),"
            "(15,'Todas las anteriores',0,4),"
            "(16,'Ninguna de las Anteriores',0,4),"
            "(17,'Negros, blancos y asiáticos .',0,5),"
            "(18,'Afro descendientes, amerindios y norteamericanos.',0,5),"
            "(19,'Amerindios, blancos y negros',1,5),"
            "(20,'Pastusos, paisas y costeños',0,5),"
            "(21,'Generación Hidráulica',1,6),"
            "(22,'Generación Térmica',0,6),"
            "(23,'Generación Eólica',0,6),"
            "(24,'Generación Solar',0,6),"
            "(25,'Enero y abril',0,7),"
            "(26,'Diciembre y marzo',0,7),"
            "(27,'Noviembre y febrero',1,7),"
            "(28,'Todas las Anteriores',0,7),"
            "(29,'Sütchin lüsu',1,8),"
            "(30,'Ayuuli',0,8),"
            "(31,'Jashichii',0,8),"
            "(32,'Luma',0,8),"
            "(33,'Maria Fernanda Suárez',1,9),"
            "(34,'Maria Fernanda Perez',0,9),"
            "(35,'Maria Alejandra Perez',0,9),"
            "(36,'Ninguna de las Anteriores',0,9)"
        );
      }
    );
  }

  // Jugador
  newJugador(Jugador newJugador) async {
    final db = await database;
    var raw = await db.rawInsert(
        "INSERT Into jugadores (id, nombres, apellidos, correo, fecha_creacion)"
        "VALUES (?,?,?,?,?)",
        [newJugador.id, newJugador.nombres, newJugador.apellidos, newJugador.correo, fechaNow()]);
    return raw;
  }
  // newEstado(Estado newEstado) async {
  //   final db = await database;
  //   //get the biggest id in the table
  //   var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Estado");
  //   int id = table.first["id"];
  //   //insert to the table using the new id
  //   var raw = await db.rawInsert(
  //       "INSERT Into Estado (id,nombre,icono)"
  //       " VALUES (?,?,?)",
  //       [id, newEstado.nombre, newEstado.icono]);
  //   return raw;
  // }

  updateJugador(Jugador newJugador) async {
    final db = await database;
    var res = await db.update("jugadores", newJugador.toMap(),
        where: "id = ?", whereArgs: [newJugador.id]);
    return res;
  }

  getJugador(int id) async {
    final db = await database;
    var res = await db.query("jugadores", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Jugador.fromMap(res.first) : null;
  }

  Future<List<Jugador>> getAllJugadores() async {
    final db = await database;
    var res = await db.query("jugadores");
    List<Jugador> list = res.isNotEmpty ? res.map((c) => Jugador.fromMap(c)).toList() : [];
    return list;
  }

  deleteJugador(int id) async {
    final db = await database;
    return db.delete("jugadores", where: "id = ?", whereArgs: [id]);
  }

  deleteAllJugador() async {
    final db = await database;
    db.rawDelete("Delete * from jugadores");
  }

  // Preguntas
  // newPerfil(Perfil newPerfil) async {
  //   final db = await database;
  //   //get the biggest id in the table
  //   var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Perfil");
  //   int id = table.first["id"];
  //   //insert to the table using the new id
  //   var raw = await db.rawInsert(
  //       "INSERT Into Perfil (id, nombre)"
  //       " VALUES (?,?)",
  //       [id, newPerfil.nombre]);
  //   return raw;
  // }

  // updatePerfil(Perfil newPerfil) async {
  //   final db = await database;
  //   var res = await db.update("Perfil", newPerfil.toMap(),
  //       where: "id = ?", whereArgs: [newPerfil.id]);
  //   return res;
  // }

  getPregunta(int id) async {
    final db = await database;
    var res = await db.query("preguntas", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Pregunta.fromMap(res.first) : null;
  }

  Future<List<Pregunta>> getAllPreguntas() async {
    final db = await database;
    var res = await db.query("preguntas");
    List<Pregunta> list = res.isNotEmpty ? res.map((c) => Pregunta.fromMap(c)).toList() : [];
    return list;
  }

  // deletePerfil(int id) async {
  //   final db = await database;
  //   return db.delete("Perfil", where: "id = ?", whereArgs: [id]);
  // }

  // deleteAllPerfil() async {
  //   final db = await database;
  //   db.rawDelete("Delete * from Perfil");
  // }

  // Respuestas
  getRespuesta(int id) async {
    final db = await database;
    var res = await db.query("respuestas", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Respuesta.fromMap(res.first) : null;
  }

  Future<List<Respuesta>> getAllRespuestasPregunta(int preguntaId) async {
    final db = await database;
    var res = await db.query("respuestas", where: "pregunta_id = ?", whereArgs: [preguntaId]);
    List<Respuesta> list = res.isNotEmpty ? res.map((c) => Respuesta.fromMap(c)).toList() : [];
    return list;
  }
  
  Future<List<Respuesta>> getAllRespuestas() async {
    final db = await database;
    var res = await db.query("respuestas");
    List<Respuesta> list = res.isNotEmpty ? res.map((c) => Respuesta.fromMap(c)).toList() : [];
    return list;
  }

  // Partidas
  newPartida(Partida newPartida) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM partidas");
    int id = table.first["id"] == null ? 1 : table.first["id"];
    // print("Id de partida en DB: $id");
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into partidas (id, jugador_id, fecha_creacion)"
        " VALUES (?,?,?)",
        [id, newPartida.jugadorId, fechaNow()]);
    return raw;
  }

  updatePartida(Partida newPartida) async {
    final db = await database;
    var res = await db.update("partidas", newPartida.toMap(),
        where: "id = ?", whereArgs: [newPartida.id]);
    return res;
  }

  getPartida(int id) async {
    final db = await database;
    var res = await db.query("partidas", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Partida.fromMap(res.first) : null;
  }

  Future<List<Partida>> getAllPartidas() async {
    // print("Por aqui me llaman");
    final db = await database;
    var res = await db.query("partidas");
    List<Partida> list = res.isNotEmpty ? res.map((c) => Partida.fromMap(c)).toList() : [];
    return list;
  }

  deletePartidas(int id) async {
    final db = await database;
    return db.delete("partidas", where: "id = ?", whereArgs: [id]);
  }

  deleteAllPartidas() async {
    final db = await database;
    db.rawDelete("Delete * from partidas");
  }

  // Partidas
  newRespuestasPartida(RespuestasPartida newRespuestasPartida) async {
    final db = await database;
    var raw = await db.rawInsert(
        "INSERT Into respuestas_partida (partida_id, respuesta_id, fecha)"
        " VALUES (?,?,?)",
        [newRespuestasPartida.partidaId, newRespuestasPartida.respuestaId, fechaNow()]);
    return raw;
  }

  Future<List<RespuestasPartida>> getRespuestasPartida(int id) async {
    // print(id);
    final db = await database;
    var res = await db.query("respuestas_partida", where: "partida_id = ?", whereArgs: [id]);
    // print(res);
    List<RespuestasPartida> list = res.isNotEmpty ? res.map((c) => RespuestasPartida.fromMap(c)).toList() : [];
    // print(list);
    // print(list[0].respuestaId);
    // print(list[0].fecha);
    return list;
  }

  Future<List<RespuestasPartida>> getAllRespuestasPartidas() async {
    final db = await database;
    var res = await db.query("respuestas_partida");
    // print(res);
    List<RespuestasPartida> list = res.isNotEmpty ? res.map((c) => RespuestasPartida.fromMap(c)).toList() : [];
    // print(list);
    return list;
  }

  deleteRespuestasPartida(int id) async {
    final db = await database;
    return db.delete("respuestas_partida", where: "partida_id = ?", whereArgs: [id]);
  }

  deleteAllRespuestasPartidas() async {
    final db = await database;
    db.rawDelete("Delete * from respuestas_partida");
  }

  // // ESTADOS PERFIL
  // newEstadosPerfil(EstadosPerfil newEstadosPerfil) async {
  //   final db = await database;
  //   //get the biggest id in the table
  //   // var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM EstadosPerfil");
  //   // int id = table.first["id"];
  //   //insert to the table using the new id
  //   var raw = await db.rawInsert(
  //       "INSERT Into EstadosPerfil (estado_id, perfil_id, activo)"
  //       " VALUES (?,?,?)",
  //       [newEstadosPerfil.estadoId, newEstadosPerfil.perfilId, newEstadosPerfil.activo]);
  //   return raw;
  // }

  // activeOrDeactive(EstadosPerfil estado) async {
  //   final db = await database;

  //   EstadosPerfil activo = EstadosPerfil(
  //       estadoId: estado.estadoId,
  //       perfilId: estado.perfilId,        
  //       activo: !estado.activo
  //   );

  //   var res = await db.update("EstadosPerfil", activo.toMap(),
  //     where: "perfil_id = ? AND estado_id = ?", whereArgs: [estado.perfilId, estado.estadoId]
  //   );
  //   return res;
  // }

  // updateEstadosPerfil(EstadosPerfil newEstadosPerfil) async {
  //   final db = await database;
  //   var res = await db.update("EstadosPerfil", newEstadosPerfil.toMap(),
  //     where: "perfil_id = ? AND estado_id = ?", whereArgs: [newEstadosPerfil.perfilId, newEstadosPerfil.estadoId]    
  //   );
  //   return res;
  // }

  // getEstadosPerfil(int perfilId, int estadoId) async {
  //   final db = await database;
  //   var res = await db.query("EstadosPerfil", where: "perfil_id = ? AND estado_id = ?", whereArgs: [perfilId, estadoId]);
  //   return res.isNotEmpty ? EstadosPerfil.fromMap(res.first) : null;
  // }

  // Future<List<EstadosPerfil>> getBlockedEstadosPerfils() async {
  //   final db = await database;

  // print("works");
  //   // var res = await db.rawQuery("SELECT * FROM EstadosPerfil WHERE estado=1");
  //   var res = await db.query("EstadosPerfil", where: "activo = ? ", whereArgs: [1]);

  //   List<EstadosPerfil> list = res.isNotEmpty ? res.map((c) => EstadosPerfil.fromMap(c)).toList() : [];
  //   return list;
  // }

  // Future<List<EstadosPerfil>> getAllEstadosPerfils() async {
  //   final db = await database;
  //   var res = await db.query("EstadosPerfil");
  //   List<EstadosPerfil> list = res.isNotEmpty ? res.map((c) => EstadosPerfil.fromMap(c)).toList() : [];
  //   return list;
  // }

  // Future<List<Estado>> getTemporalPivot() async {
  //   final db = await database;
  //   var res = await db.query("Estado");
  //   List<Estado> list = res.isNotEmpty ? res.map((c) => Estado.fromMap(c)).toList() : [];
  //   return list;
  // }

  // deleteEstadosPerfil(int perfilId, int estadoId) async {
  //   final db = await database;
  //   return db.delete("EstadosPerfil", where: "perfil_id = ? AND estado_id = ?", whereArgs: [perfilId, estadoId]);
  // }

  // deleteAllEstadosPerfil() async {
  //   final db = await database;
  //   db.rawDelete("Delete * from EstadosPerfil");
  // }


  String fechaNow(){
    var now = new DateTime.now();
    var formatter = new DateFormat("yyyy/MM/dd 'a las' HH:mm:ss");
    String formatted = formatter.format(now);
    // print(formatted);
    return formatted;
  }
}