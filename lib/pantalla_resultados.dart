import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wwtbam_flutter/models/PreguntaModel.dart';
import 'package:wwtbam_flutter/models/PreguntaRespuestasModel.dart';
import 'package:wwtbam_flutter/models/RespuestaModel.dart';
import 'package:wwtbam_flutter/pantalla_bienvenida.dart';
// import 'package:wwtbam_flutter/pantalla_detalles_partida.dart';
import 'package:wwtbam_flutter/sounds/player.dart';
import 'components/LogoSVG.dart';
import 'components/label_premio.dart';
import 'components/line_painter.dart';
// import 'components/list_tile.dart';
import 'database/Database.dart';
import 'models/PartidaModel.dart';
import 'models/RespuestasPartidaModel.dart';

class PantallaResultados extends StatefulWidget {
  final partidaActual, logRespuestas;
  PantallaResultados({Key key, @required this.partidaActual, @required this.logRespuestas}) : super(key: key);
  @override
  _PantallaResultadosState createState() => new _PantallaResultadosState();
}

class _PantallaResultadosState extends State<PantallaResultados> {
  var partidaActual, logRespuestas;
  @override
  void initState() {
    super.initState();
    Player.stop();
    Player.playIntro();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => guardarPartida(context));
  }
  @override
  Widget build(BuildContext context) {
    partidaActual = widget.partidaActual;
    logRespuestas = widget.logRespuestas;
    MediaQueryData queryData = MediaQuery.of(context);

    return new WillPopScope(
      key: null,
      onWillPop: () {
        return Future.value(_allow()); // if true allow back else block it
      },
      child: new Scaffold(
        body: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Spacer(flex: 1),
                new Container(
                  // height: queryData.size.height / 7,
                  child: new Center(
                    child: new LogoSVG(
                      width: (queryData.size.width / 1.7),
                    )
                  ),
                ),
                // Spacer(flex: 1),
                CustomPaint(
                  painter: LinePainter(),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: new LabelPremio("Resultados:")
                      ,)
                    ],
                  )
                ),
                // Spacer(flex: 1),
                new Expanded(
                  child: FutureBuilder<List<PreguntaRespuestas>>(
                    future: getPreguntasRespuestas(),
                    builder: (BuildContext context, AsyncSnapshot<List<PreguntaRespuestas>> preguntas) {
                      if (preguntas.hasData) {
                        return new Container(
                          child: ListView.separated(
                            physics: BouncingScrollPhysics(),
                            itemCount: preguntas.data.length,
                            separatorBuilder: (BuildContext context, int index) => Divider(),
                            itemBuilder: (BuildContext context, int index) {
                              PreguntaRespuestas pregunta = preguntas.data[index];
                              // return ListTilePartida(entrarPartida, partida, partidaActual);
                              return ListTile(
                                title: Text(pregunta.texto),
                                subtitle: Text("R: "+pregunta.respuestas[0].texto,
                                  style: TextStyle(color: pregunta.respuestas[0].correcta ? Colors.green : Colors.red),
                                ),
                              );
                            }
                          )
                        );
                      }else{
                        return new Container(
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                    }
                  ),
                  // child: new ListView.builder(
                  //   physics: BouncingScrollPhysics(),
                  //   itemCount: logRespuestas.length,
                  //   itemBuilder: (BuildContext ctxt, int index) {
                  //    return new ListTile(title: new Text(logRespuestas[index].toString() ) );
                  //   }
                  // ),
                ),                
                // Spacer(flex: 1,),
                new RaisedButton(
                    key: null,
                    color: Colors.black,
                    textColor: Colors.white,
                    onPressed: buttonPressed,
                    padding: EdgeInsets.only(left: 30, right: 30, bottom: 10, top: 10),
                    shape: new BeveledRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0),
                      side: BorderSide(
                        color: Colors.grey, //Color of the border
                        style: BorderStyle.solid, //Style of the border
                        width: 3, //width of the border
                      ),
                    ),
                    child: Text('Inicio',
                      style: new TextStyle(
                        fontSize: 18
                      ),
                    ),
                  ),
                  // Spacer(flex: 1),
                ],
            ),
      )
    );
  }

  bool _allow() {
    return true;
  }

  Future<List<RespuestasPartida>> getResultados(){
    return DBProvider.db.getAllRespuestasPartidas();
  }

  Future<List<PreguntaRespuestas>> getPreguntasRespuestas() async{
    List<PreguntaRespuestas> preguntas = new List<PreguntaRespuestas>();
    // logRespuestas.forEach((respuesta) async{
    for(var respuesta in logRespuestas) {
      // print(respuesta);
      Respuesta r = await DBProvider.db.getRespuesta(respuesta);
      Pregunta p = await DBProvider.db.getPregunta(r.preguntaId);
      List<Respuesta> respuestas = new List<Respuesta>();
      respuestas.add(r);
      // print(r);
      preguntas.add(new PreguntaRespuestas(id: p.id, categoria: p.categoria, texto: p.texto, respuestas: respuestas ) );
      // print(preguntas.length);
    }
    // print(preguntas.length);
    return preguntas;
  }

  Future<List<Respuesta>> getRespuestas() async{
    List<Respuesta> respuestas = new List<Respuesta>();
    logRespuestas.forEach((respuesta) async{
      Respuesta r = await DBProvider.db.getRespuesta(respuesta);
      respuestas.add(r);
    });

    return respuestas;
  }

  void guardarPartida(BuildContext context) async {
    // print(logRespuestas);
    // print("Partida actual: $partidaActual");
    // print("Guardando...");
    await DBProvider.db.deleteAllRespuestasPartidas();
    await DBProvider.db.deleteAllPartidas();
    Partida nuevaPartida = new Partida();
    var idPartida = await DBProvider.db.newPartida(nuevaPartida);
    logRespuestas.forEach((respuesta){
      RespuestasPartida respuestaPartida = new RespuestasPartida(
        respuestaId: respuesta,
        partidaId: idPartida
      );
      // print(respuestaPartida);
      // print(respuestaPartida.respuestaId);
      guardarRespuesta(respuestaPartida);
    });
    // print("Guardado");
  }

  Future guardarRespuesta(RespuestasPartida r) async {
    await DBProvider.db.newRespuestasPartida(r);
  }

  void buttonPressed() {
    Player.stop();
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        curve: Curves.bounceOut,
        duration: Duration(seconds: 1),
        alignment: Alignment.topCenter,
        child: new PageBienvenida()
      ),
    );
  }
}
