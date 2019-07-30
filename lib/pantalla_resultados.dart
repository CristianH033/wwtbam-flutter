import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wwtbam_flutter/pantalla_bienvenida.dart';
import 'package:wwtbam_flutter/pantalla_detalles_partida.dart';
import 'package:wwtbam_flutter/sounds/player.dart';
import 'components/LogoSVG.dart';
import 'components/label_premio.dart';
import 'components/line_painter.dart';
import 'components/list_tile.dart';
import 'components/pdf.dart';
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

    // WidgetsBinding.instance
    //     .addPostFrameCallback((_) => guardarPartida(context));
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
                new Container(
                  // height: queryData.size.height / 7,
                  child: new Center(
                    child: new LogoSVG(
                      width: (queryData.size.width / 3) + 200,
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
                  child: FutureBuilder<List<Partida>>(
                    future: DBProvider.db.getAllPartidas(),
                    builder: (BuildContext context, AsyncSnapshot<List<Partida>> partidas) {
                      if (partidas.hasData) {
                        return new Container(
                          child: ListView.separated(
                            // physics: BouncingScrollPhysics(),
                            itemCount: partidas.data.length,
                            separatorBuilder: (BuildContext context, int index) => Divider(),
                            itemBuilder: (BuildContext context, int index) {
                              Partida partida = partidas.data[index];
                              return ListTilePartida(entrarPartida, partida, partidaActual);
                            }
                          )
                        );
                      }else{
                        return new Container(
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                    })  
                ),                
                // Spacer(flex: 1),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new RaisedButton(
                      key: null,
                      color: Colors.blue,
                      textColor: Colors.white,
                      onPressed: exportarReg,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)
                      ),
                      child: Text('Exportar registros',
                        style: new TextStyle(
                          fontSize: 18
                        ),
                      ),
                    ),
                    new RaisedButton(
                      key: null,
                      color: Colors.blue,
                      textColor: Colors.white,
                      onPressed: buttonPressed,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)
                      ),
                      child: Text('Inicio',
                        style: new TextStyle(
                          fontSize: 18
                        ),
                      ),
                    )
                  ],
                ),
              ]
            ),
      )
    );
  }

  bool _allow() {
    return true;
  }

  void entrarPartida(Partida partida){
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => new PantallaPartidaDetalles(partida: partida)),
      // MaterialPageRoute(builder: (context) => Pantalla()),
    );
  }

  void guardarPartida(BuildContext context) async {
    // print(logRespuestas);
    // print("Partida actual: $partidaActual");
    // print("Guardando...");
    logRespuestas.forEach((respuesta){
      RespuestasPartida respuestaPartida = new RespuestasPartida(
        respuestaId: respuesta,
        partidaId: partidaActual
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

  void exportarReg(){
    reportePDF();
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
