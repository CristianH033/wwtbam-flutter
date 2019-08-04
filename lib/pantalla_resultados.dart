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

class PantallaResultados extends StatefulWidget {
  final preguntas;
  PantallaResultados({Key key, @required this.preguntas}) : super(key: key);
  @override
  _PantallaResultadosState createState() => new _PantallaResultadosState();
}

class _PantallaResultadosState extends State<PantallaResultados> {
  var preguntas;
  @override
  void initState() {
    super.initState();
    Player.stop();
    Player.playIntro();

    // WidgetsBinding.instance.addPostFrameCallback((_) => guardarPartida(context));
  }
  @override
  Widget build(BuildContext context) {
    preguntas = widget.preguntas;
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
                new Padding(
                  padding: EdgeInsets.all(20),
                  child: new Text("Puntaje logrado: "+getPuntaje().toString(), 
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 25,
                    ),
                  ),
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
                            padding: EdgeInsets.all(10),
                            itemBuilder: (BuildContext context, int index) {
                              PreguntaRespuestas pregunta = preguntas.data[index];
                              // return ListTilePartida(entrarPartida, partida, partidaActual);
                              return Card(
                                elevation: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    ListTile(
                                      leading: Icon(Icons.check_circle, color: Colors.grey,),
                                      title: new Text(pregunta.texto, style: TextStyle(fontSize: 20),),
                                    ),                                    
                                    // new Divider(color: Colors.grey,),
                                    new Container(
                                      decoration: new BoxDecoration (
                                          color: pregunta.respuestas[0].seleccionada ? pregunta.respuestas[0].correcta ? Colors.green.shade200 : Colors.red.shade200 : Colors.white
                                      ),
                                      child: new ListTile(title: Text(pregunta.respuestas[0].texto), contentPadding: EdgeInsets.only(left: 15, right: 15, top: 3, bottom: 3))
                                    ),
                                    new Container(
                                      decoration: new BoxDecoration (
                                          color: pregunta.respuestas[1].seleccionada ? pregunta.respuestas[1].correcta ? Colors.green.shade200 : Colors.red.shade200 : Colors.white
                                      ),
                                      child: new ListTile(title: Text(pregunta.respuestas[1].texto), contentPadding: EdgeInsets.only(left: 15, right: 15, top: 3, bottom: 3)),
                                    ),
                                    new Container(
                                      decoration: new BoxDecoration (
                                          color: pregunta.respuestas[2].seleccionada ? pregunta.respuestas[2].correcta ? Colors.green.shade200 : Colors.red.shade200 : Colors.white
                                      ),
                                      child: new ListTile(title: Text(pregunta.respuestas[2].texto), contentPadding: EdgeInsets.only(left: 15, right: 15, top: 3, bottom: 3)),
                                    ),
                                  ],
                                )
                              );
                              // return ListTile(
                                // title: Text(pregunta.texto),
                                // subtitle: Text("R: "+pregunta.respuestas[0].seleccionada.toString(),
                                  // style: TextStyle(color: pregunta.respuestas[0].correcta ? Colors.green : Colors.red),
                                // ),
                              // );
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

  int getPuntaje() {
    int puntaje = 0;
    for (PreguntaRespuestas pregunta in preguntas){
      // print(pregunta.respuestas[0].seleccionada);
      Respuesta seleccionada = pregunta.respuestas.where((i) => i.seleccionada).first;
      // print(seleccionada.correcta);
      if(seleccionada.correcta){
        puntaje += 5;
      }
    }
    return puntaje;
  }

  Future<List<PreguntaRespuestas>> getPreguntasRespuestas() async{
    return preguntas;
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
