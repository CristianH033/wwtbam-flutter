import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wwtbam_flutter/components/LogoSVG.dart';
import 'package:wwtbam_flutter/pantalla_pregunta.dart';
import 'package:wwtbam_flutter/pantalla_resultados.dart';
import 'package:wwtbam_flutter/sounds/player.dart';
import 'components/label_premio.dart';
import 'components/line_painter.dart';

class PantallaPremio extends StatefulWidget {
  final preguntas, index;
  PantallaPremio({Key key, @required this.preguntas, @required this.index}) : super(key: key);  
  @override
  _PantallaPremioState createState() => new _PantallaPremioState();
}

class _PantallaPremioState extends State<PantallaPremio> {
  var preguntas, index;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Player.stop();
    Player.playCorrect();   
  }
  @override
  Widget build(BuildContext context) {
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
                      new LabelPremio("¡GANASTE UNA PINZA MOSQUITO!")
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
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        // curve: Curves.bounceOut,
        duration: Duration(seconds: 1),
        alignment: Alignment.topCenter,
        child: new PantallaResultados(preguntas: preguntas),
      ),
    );
  }

  
}
