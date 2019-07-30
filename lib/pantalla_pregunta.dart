import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wwtbam_flutter/pantalla_correcto.dart';
import 'package:wwtbam_flutter/pantalla_timeout.dart';
import 'package:wwtbam_flutter/pantalla_wrong.dart';
import 'package:wwtbam_flutter/sounds/player.dart';
import 'components/LogoSVG.dart';
import 'components/boton_respuesta.dart';
import 'components/label_pregunta.dart';
import 'components/line_painter.dart';
import 'models/RespuestaModel.dart';
import 'package:countdown/countdown.dart';


class PantallaPregunta extends StatefulWidget {
  final preguntas, index;
  PantallaPregunta({Key key, @required this.preguntas, @required this.index}) : super(key: key);
  @override
  _PantallaPreguntaState createState() => new _PantallaPreguntaState();
}

class _PantallaPreguntaState extends State<PantallaPregunta> {
  var preguntas, index, tiempo = 32, tiempoRestante = 32, w;
  // CountDown cd = CountDown(Duration(seconds : 30));
  var sub;
  @override
  void initState() {
      super.initState();
      Player.stop();
      Player.playLetsPlay();
      Player.playMain();
      CountDown cd = CountDown(Duration(seconds : tiempo));
      sub = cd.stream.listen(null);
      sub.onData((Duration d) {
        this.setState(() {
          tiempoRestante = d.inSeconds.toInt();
        });
        // print(d.inSeconds);
      });

      sub.onDone(() {
        print("done");
        sub.cancel();
        Player.stop();
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            curve: Curves.bounceOut,
            duration: Duration(seconds: 1),
            alignment: Alignment.topCenter,
            child: PantallaTimeOut(preguntas: preguntas, index: index)
          ),
        );
      });
  }
  @override
  Widget build(BuildContext context) {
    preguntas = widget.preguntas;
    index = widget.index;
    MediaQueryData queryData = MediaQuery.of(context);
    w = (queryData.size.width * ((tiempoRestante*100)/32))/100;
    return new WillPopScope(
      key: null,
      onWillPop: () {
        return Future.value(_allow()); // if true allow back else block it
      },
      child: new Scaffold(
        body: FutureBuilder<List<Respuesta>>(
        future: gr(),
        builder: (BuildContext context, AsyncSnapshot<List<Respuesta>> respuestas) {
          if (respuestas.hasData) {
            return new Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Spacer(flex: 1),
                new Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      // Where the linear gradient begins and ends
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      // Add one stop for each color. Stops should increase from 0 to 1
                      stops: [0, 0.5, 1],
                      colors: [
                        // Colors are easy thanks to Flutter's Colors class.
                        Colors.grey,
                        Colors.white,
                        Colors.grey
                      ],
                    ),
                  ),
                  width: queryData.size.width,
                  child: new Center(
                    // child: new LogoSVG(width: queryData.size.width/1.6,)
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            new Image.asset('assets/images/${preguntas[index].categoria}.png', width: queryData.size.width/5,),
                            new Text(preguntas[index].categoria.toUpperCase(), style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),),
                          ]
                        ),
                        new LogoSVG(width: queryData.size.width/3,)
                      ],
                    )
                  ),
                ),
                Spacer(flex: 1),
                CustomPaint(
                  painter: LinePainter(),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new LabelPregunta(preguntas[index].texto)
                    ],
                  )
                ),
                Spacer(flex: 1),
                CustomPaint(
                  painter: LinePainter(),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        width: 45,
                        height: 45,
                        child: new Center(
                          child: Text("A", 
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white)
                          )
                        ),
                        decoration: new BoxDecoration(
                          color: Colors.black,
                          border: Border.all(width: 3, color: Colors.grey),
                          borderRadius: BorderRadius.all(
                              Radius.circular(50)
                          ),
                        ),
                      ),                      
                      new BotonRespuesta(buttonPressed, respuestas.data[0].texto, 0),
                      new Container(
                        width: 45,
                        height: 45,
                      )
                    ],
                  )
                ),
                Spacer(flex: 1),
                CustomPaint(
                  painter: LinePainter(),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        width: 45,
                        height: 45,
                        child: new Center(
                          child: Text("B", 
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white)
                          )
                        ),
                        decoration: new BoxDecoration(
                          color: Colors.black,
                          border: Border.all(width: 3, color: Colors.grey),
                          borderRadius: BorderRadius.all(
                              Radius.circular(50)
                          ),
                        ),
                      ),                      
                      new BotonRespuesta(buttonPressed, respuestas.data[1].texto, 1),
                      new Container(
                        width: 45,
                        height: 45,
                      )
                    ],
                  )
                ),
                Spacer(flex: 1),
                CustomPaint(
                  painter: LinePainter(),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        width: 45,
                        height: 45,
                        child: new Center(
                          child: Text("C", 
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white)
                          )
                        ),
                        decoration: new BoxDecoration(
                          color: Colors.black,
                          border: Border.all(width: 3, color: Colors.grey),
                          borderRadius: BorderRadius.all(
                              Radius.circular(50)
                          ),
                        ),
                      ),                      
                      new BotonRespuesta(buttonPressed, respuestas.data[2].texto, 2),
                      new Container(
                        width: 45,
                        height: 45,
                      )
                    ],
                  )
                ),
                Spacer(flex: 1),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Container(
                      height: 10,
                      width: w,
                      alignment: Alignment(-10, -10),
                      decoration: BoxDecoration(
                          borderRadius: new BorderRadius.all(new Radius.circular(10)),
                          boxShadow: [
                            new BoxShadow(
                              color: tiempoRestante < 10 ? Colors.red : Colors.green,
                              offset: new Offset(0.0, 0.0),
                              blurRadius: 2.0,
                            )
                          ],
                          color: tiempoRestante < 10 ? Colors.red : Colors.green
                      ),
                    ),
                    new Text('$tiempoRestante',
                      style: new TextStyle(
                          color: tiempoRestante < 10 ? Colors.red : Colors.green,
                          fontSize: 20,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ),
              ]
            );
          }else{
            return new Container(
              child: Center(child: CircularProgressIndicator()),
            );
          }
         }
        ),
      )
    );
  }

  bool _allow() {
    return false;
  }

  Future<List<Respuesta>> gr() async {
    return await this.preguntas[index].respuestas;
  }

  void buttonPressed(int idx ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        Player.playFinal();
        return new CupertinoAlertDialog(
          title: new Text("Última Palabra?"),
          content: new Text(""),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                sub.cancel();
                Player.stop();
                Navigator.of(context).pop();
                preguntas[index].respuestas[idx].seleccionada = true;
                if(preguntas[index].respuestas[idx].correcta){
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      curve: Curves.bounceOut,
                      duration: Duration(seconds: 1),
                      alignment: Alignment.topCenter,
                      child: new PantallaCorrecto(preguntas: preguntas, index: index)
                    ),
                  );
                }else{
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      curve: Curves.bounceOut,
                      duration: Duration(seconds: 1),
                      alignment: Alignment.topCenter,
                      child: PantallaWrong(preguntas: preguntas, index: index)
                    ),
                  );
                }
              },
              child: Text("Si"),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("No"),
            )
          ],
        );
      },
    );
  }
}
