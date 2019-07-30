import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wwtbam_flutter/database/Database.dart';
import 'package:wwtbam_flutter/models/PreguntaModel.dart';
import 'package:wwtbam_flutter/pantalla_pregunta.dart';
import 'package:wwtbam_flutter/pantalla_resultados.dart';
import 'package:wwtbam_flutter/sounds/player.dart';
import 'components/LogoSVG.dart';
import 'registro.dart';

class PageBienvenida extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Wanapo Game',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF2196f3),
        accentColor: const Color(0xFF2196f3),
        canvasColor: const Color(0xFFfafafa),
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Player.playIntro();
  }

  @override
  void dispose() { 
    WidgetsBinding.instance.removeObserver(this);  
    super.dispose();  
    // player.clearAll();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.paused:
        Player.pauseLoop();
        print('paused state');
        break;
      case AppLifecycleState.resumed:
        Player.resumeLoop();
        print('resumed state');
        break;
      case AppLifecycleState.inactive:
        print('inactive state');
        break;
      case AppLifecycleState.suspending:
        print('suspending state');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: new Container(
            decoration: BoxDecoration(
              // color: Colors.blue,
              image: DecorationImage(
                image: AssetImage("assets/images/EsquinaSup.png"),
                fit: BoxFit.none,
                alignment: new Alignment(-1.0, -1.0),
              ),
              gradient: RadialGradient(
                focalRadius: 0.5,
                radius: 1.6,
                colors: [
                  Colors.white,
                  Colors.white,
                  Colors.grey,
                ],
              ),
            ),
            child: new Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  // color: Colors.blue,
                  image: DecorationImage(
                image: AssetImage("assets/images/EsquinaInf.png"),
                fit: BoxFit.none,
                alignment: new Alignment(1.0, 1.0),
              )),
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Spacer(flex: 1),
                    new LogoSVG(width: queryData.size.width /1.2),
                    Spacer(flex: 10),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          width: queryData.size.width - 100,
                          child: new Text("PON A PRUEBA TU CONOCIMIENTO Y SELECCIONA LAS RESPUESTAS CORRECTAS",
                             textAlign: TextAlign.center,
                             style: new TextStyle(
                               color: Colors.blue,
                               fontSize: 28,
                               fontWeight: FontWeight.w900
                            ),
                          )                        
                        )
                       ],
                    ),                    
                    Spacer(flex: 10),
                    new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new RaisedButton(
                          key: null,
                          color: Colors.blue,
                          textColor: Colors.white,
                          onPressed: buttonPressed2,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)
                          ),
                          child: Text('Registro',
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
                          child: Text('Siguiente',
                            style: new TextStyle(
                                fontSize: 18
                            ),
                          ),
                        )
                      ],
                    ),

                  ]),
            )));
  }

  void buttonPressed2(){
    // Player.stop();
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => new PantallaResultados(partidaActual: null, logRespuestas: [])),
      // MaterialPageRoute(builder: (context) => Pantalla()),
    );
  }

  void buttonPressed() async {
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     // return object of type Dialog
    //     return new CupertinoAlertDialog(
    //       title: new Text("Dialog Title"),
    //       content: new Text("This is my content"),
    //       actions: <Widget>[
    //         CupertinoDialogAction(
    //           isDefaultAction: true,
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //           child: Text("Yes"),
    //         ),
    //         CupertinoDialogAction(
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //           child: Text("No"),
    //         )
    //       ],
    //     );
    //   },
    // );

    // Player.stop();

    List<Pregunta> preguntas = await DBProvider.db.getAllPreguntas();

    preguntas.shuffle();

    // Partida partida = new Partida(
    //   jugadorId: nuevoJugador.id
    // );
    Player.stop();
    // Player.playLetsPlay();
    // Navigator.pushReplacement(
    //   context,
    //   PageTransition(
    //     type: PageTransitionType.size,
    //     curve: Curves.bounceOut,
    //     duration: Duration(seconds: 1),
    //     alignment: Alignment.topCenter,
    //     child: new PantallaPregunta(logRespuestas: [], preguntas: preguntas, index: 0)
    //   ),
    // );


    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => new PantallaPregunta(logRespuestas: [], preguntas: preguntas, index: 0)),
      // MaterialPageRoute(builder: (context) => Pantalla()),
    );
  }
}
