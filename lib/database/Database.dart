import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
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
            "CREATE TABLE 'partidas'"
            "("
            " 'id'  INTEGER PRIMARY KEY,"
            " 'fecha_creacion'  varchar(255) NOT NULL"
            ")"
        );

        await db.execute(
            "CREATE TABLE 'preguntas'"
            "("
            " 'id'        INTEGER PRIMARY KEY,"
            " 'texto'     varchar(255) NOT NULL,"
            " 'categoria' varchar(255) NOT NULL"
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

        await db.execute(
            "INSERT INTO preguntas"
            "(id, texto, categoria)"
            "VALUES" 
            "(1, 'La brecha inmunológica se presenta a que edad:', 'Calostro'),"
            "(2, 'Qué sucede en el intestino después del estrés:', 'Calostro'),"
            "(3, 'Qué es Optistar:', 'Calostro'),"
            "(4, 'Qué es Purina Pro Plan Puppy con Optistar:', 'Calostro'),"
            "(5, 'Cuáles son los principales síntomas de envejecimiento de los perros:', 'MCT'),"
            "(6, '¿Qué es la Trigliceridos de cadena media (MCT)?', 'MCT'),"
            "(7, 'Qué es Active Mind:', 'MCT'),"
            "(8, 'Qué es Purina Pro Plan Active Mind 7+:', 'MCT'),"
            "(9, 'Cuáles son los principales sistemas naturales de protección del perro:', 'Spirulina'),"
            "(10, 'Qué es la Spirulina:', 'Spirulina'),"
            "(11, 'Qué es Optihealth:', 'Spirulina'),"
            "(12, 'Qué es Purina Pro Plan adulto con Optihealth:', 'Spirulina')"
        );

        await db.execute(
            "INSERT INTO respuestas"
            "(id, texto, correcta, pregunta_id)"
            "VALUES "
            "(1,'A los 5 años.',0,1),"
            "(2,'A los 5 meses.',0,1),"
            "(3,'A los 45 días.',1,1),"
            "(4,'No sucede nada, nadie se da cuenta.',0,2),"
            "(5,'Le llega trabajo al veterinario.',0,2),"
            "(6,'Cambios en microbiota intestinal, propagación de bacterias patógenas, pérdida de barrera protectora intestinal.',1,2),"
            "(7,'Un invento de Purina.',0,3),"
            "(8,'Una estrella de cine.',0,3),"
            "(9,'Una tecnología que incluye inmunoglobulinas del calostro y antioxidantes, que ayudan a estabilizar la microbiota intestinal y mejora el estado inmunitario del cachorro.',1,3),"
            "(10,'Un alimento que contiene carne fresca de pollo para mejor valor biológico y protección de aminoacidos esenciales; que fortalece el sistema inmune de los cachorros, mejora la absorción de nutrientes y mantiene belleza de piel y pelaje.',0,4),"
            "(11,'Un alimento que disminuye la posibilidad de que se produzcan infecciones, diarreas e inflamaciones.',0,4),"
            "(12,'Todas las anteriores.',1,4),"
            "(13,'Se pone viejo el carnet de vacunas.',0,5),"
            "(14,'Obesidad, problemas articulares, pérdida de masa muscular, obesidad, déficit cognitivo.',1,5),"
            "(15,'Canas en el pelaje.',0,5),"
            "(16,'Un tipo de cadeneta de moda para fiestas infantiles.',0,6),"
            "(17,'Un ingrediente difícil de conseguir.',0,6),"
            "(18,'Una grasa de fácil metabolismo para obtener energía.',1,6),"
            "(19,'El nombre de un gimnasio.',0,7),"
            "(20,'Una tecnología que ayuda a manejar los síntomas del envejecimiento, con antioxidantes, vitaminas, minerales y MCT, para una óptima nutrición del perro geronte.',1,7),"
            "(21,'Un ingrediente para bajar de peso.',0,7),"
            "(22,'Un alimento que contiene carne fresca de pollo para mejor valor biológico y protección de aminoacidos esenciales.',0,8),"
            "(23,'Un alimento bajo en grasa, alto en proteínas, rico en antioxidantes y con MCT que controla los síntomas del envejecimiento.',0,8),"
            "(24,'Todas las anteriores.',1,8),"
            "(25,'Sistema inmune y sistema gastrointestinal.',1,9),"
            "(26,'Sistema gastrointestinal y sistema renal.',0,9),"
            "(27,'Sistema inmune y sistema endocrino.',0,9),"
            "(28,'Una bacteria intestinal.',0,10),"
            "(29,'El protagonista de la ultima producción de Netflix.',0,10),"
            "(30,'Un alga marina activador del sistema inmune en perros.',1,10),"
            "(31,'Un indicador de salud del perro.',0,11),"
            "(32,'Una tecnología que ayuda a reforzar el sistema inmune, fortalece la microbiota intestinal y refuerza la barrera cutánea del perro.',1,11),"
            "(33,'Un ingrediente para bajar de peso.',0,11),"
            "(34,'Un alimento que contiene carne fresca de pollo para mejor valor biológico y protección de aminoacidos esenciales.',0,12),"
            "(35,'Un alimento que fortalece el sistema inmune y digestivo de los perros adultos y brinda belleza y fuerza al pelaje.',0,12),"
            "(36,'Todas las anteriores.',1,12)"
        );
      }
    );
  }

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
      "INSERT Into partidas (id, fecha_creacion)"
      " VALUES (?,?)",
      [id, fechaNow()]);
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
    db.rawDelete("Delete from partidas");
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
    db.rawDelete("Delete from respuestas_partida");
  }

  String fechaNow(){
    var now = new DateTime.now();
    var formatter = new DateFormat("yyyy/MM/dd 'a las' HH:mm:ss");
    String formatted = formatter.format(now);
    // print(formatted);
    return formatted;
  }
}