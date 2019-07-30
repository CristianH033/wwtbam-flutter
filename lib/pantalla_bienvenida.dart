import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wwtbam_flutter/database/Database.dart';
import 'package:wwtbam_flutter/models/PreguntaModel.dart';
import 'package:wwtbam_flutter/pantalla_pregunta.dart';
import 'package:wwtbam_flutter/pantalla_resultados.dart';
import 'package:wwtbam_flutter/sounds/player.dart';
import 'components/LogoSVG.dart';

class PageBienvenida extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Wanapo Game',
      theme: new ThemeData(
        fontFamily: 'Antenna',
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
            
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Spacer(flex: 1),
                    new LogoSVG(width: queryData.size.width /1.6),
                    Spacer(flex: 10),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
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
                          child: new Text("¡PON A PRUEBA TU CONOCIMIENTO!",
                             textAlign: TextAlign.center,
                             style: new TextStyle(
                               color: Colors.black,
                               fontSize: 28,
                              //  fontWeight: FontWeight.w200
                            ),
                          )                        
                        )
                       ],
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
                      child: Text('JUGAR',
                        style: new TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                    ),
                    Spacer(flex: 2),
                  ]),
            ));
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
    List<Pregunta> preguntas = await DBProvider.db.getAllPreguntas();

    preguntas.shuffle();

    Player.stop();
    
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => new PantallaPregunta(logRespuestas: [], preguntas: preguntas.take(4).toList(), index: 0)),
      // MaterialPageRoute(builder: (context) => Pantalla()),
    );
  }
}
