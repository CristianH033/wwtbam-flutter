import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wwtbam_flutter/components/label_wrong.dart';
import 'package:wwtbam_flutter/pantalla_pregunta.dart';
import 'package:wwtbam_flutter/pantalla_premio.dart';
import 'package:wwtbam_flutter/pantalla_resultados.dart';
import 'package:wwtbam_flutter/sounds/player.dart';
import 'components/LogoSVG.dart';
import 'components/line_painter.dart';
import 'database/Database.dart';
import 'models/RespuestaModel.dart';

class PantallaWrong extends StatefulWidget {
  final logRespuestas, preguntas, index;
  PantallaWrong({Key key, @required this.logRespuestas, @required this.preguntas, @required this.index}) : super(key: key);  
  @override
  _PantallaWrongState createState() => new _PantallaWrongState();
}

class _PantallaWrongState extends State<PantallaWrong> {
  var logRespuestas, preguntas, index;
  int _correctas = 0;
  String _textoPremio = "";  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Player.stop();
    Player.playWrong();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => startUp(context));
  }
  @override
  Widget build(BuildContext context) {
    logRespuestas = widget.logRespuestas;
    preguntas = widget.preguntas;
    index = widget.index;
    MediaQueryData queryData = MediaQuery.of(context);
    return new WillPopScope(
      key: null,
      onWillPop: () {
        return Future.value(_allow()); // if true allow back else block it
      },
      child: new Scaffold(
        body: new Container(
            // decoration: BoxDecoration(
            // color: Colors.black,
            // image: DecorationImage(
            //   fit: BoxFit.cover,
            //   // alignment: new Alignment(1.0, 1.0),
            //   repeat: ImageRepeat.repeat,
            //   image: AssetImage("assets/gif/electric4.gif")),
            // ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Container(
                  height: queryData.size.height / 5,
                  child: new Center(
                    child: new LogoSVG(
                      width: (queryData.size.width / 1.7),
                    )
                  ),
                ),
                Spacer(flex: 10),
                CustomPaint(
                  painter: LinePainter(),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new LabelWorong("RESPUESTA EQUIVOCADA")
                    ],
                  )
                ),
                Spacer(flex: 10),
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
                  child: Text('Continuar',
                    style: new TextStyle(
                      fontSize: 18
                    ),
                  ),
                ),
                Spacer(flex: 1),
              ]
            ),
         )
      )
    );
  }

  bool _allow() {
    return false;
  }

  void buttonPressed() {
    if((index + 1) < preguntas.length){
      Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.size,
        curve: Curves.bounceOut,
        duration: Duration(seconds: 1),
        alignment: Alignment.topCenter,
        child: new PantallaPregunta(logRespuestas: logRespuestas, preguntas: preguntas, index: index+1)
      ),
    );
      
    }else{
      if(_correctas >= 2){
         Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          // curve: Curves.bounceOut,
          duration: Duration(seconds: 1),
          alignment: Alignment.topCenter,
          child: new PantallaPremio(logRespuestas: logRespuestas, index: index, preguntas: preguntas, textoPremio: _textoPremio,),
          ),
        );
      }else{
        Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          // curve: Curves.bounceOut,
          duration: Duration(seconds: 1),
          alignment: Alignment.topCenter,
          child: new PantallaResultados(logRespuestas: logRespuestas),
          ),
        );
      }      
    }
  }

  startUp(BuildContext context) async {
    print("asyncOne start");
    int count = 0;
    for (int id in logRespuestas){
      Respuesta r =await getRespuesta(id);
      if(r.correcta) count++;
    }
    print("asyncOne end");
    print("Correctas: $count");
    setState(() {
      _correctas = count; 
      if(_correctas >= 2){
        _textoPremio = "GANASTE UNA MANILLA";
      }

      if(_correctas >= 6){
        _textoPremio = "GANASTE UNA MOCHILA";
      }
    });
  }

  Future<Respuesta> getRespuesta(id) async {
    Respuesta r = await DBProvider.db.getRespuesta(id);
    return r;
  }
}
