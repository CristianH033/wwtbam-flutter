import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wwtbam_flutter/models/PreguntaRespuestasModel.dart';
import 'package:wwtbam_flutter/models/RespuestaModel.dart';
import 'package:wwtbam_flutter/pantalla_pregunta.dart';
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

  void buttonPressed() async {
    // List<Pregunta> preguntas = await DBProvider.db.getAllPreguntas();

    
    

    List<PreguntaRespuestas> preguntas = new List<PreguntaRespuestas>();

    preguntas.add(new PreguntaRespuestas(id: 1, categoria: "Calostro", texto: "La brecha inmunológica se presenta a que edad:", respuestas: [
      new Respuesta(id: 1, correcta: false, seleccionada: false, preguntaId: 1, texto: "A los 5 años."),
      new Respuesta(id: 2, correcta: false, seleccionada: false, preguntaId: 1, texto: "A los 5 meses."),
      new Respuesta(id: 3, correcta: true, seleccionada: false, preguntaId: 1, texto: "A los 45 días."),    
    ] ));
    preguntas.add(new PreguntaRespuestas(id: 2, categoria: "Calostro", texto: "Qué sucede en el intestino después del estrés:", respuestas: [
      new Respuesta(id: 4, correcta: false, seleccionada: false, preguntaId: 2, texto: "No sucede nada, nadie se da cuenta."),
      new Respuesta(id: 5, correcta: false, seleccionada: false, preguntaId: 2, texto: "Le llega trabajo al veterinario."),
      new Respuesta(id: 6, correcta: true, seleccionada: false, preguntaId: 2, texto: "Cambios en microbiota intestinal, propagación de bacterias patógenas, pérdida de barrera protectora intestinal."),
    ] ));
    preguntas.add(new PreguntaRespuestas(id: 3, categoria: "Calostro", texto: "Qué es Optistar:", respuestas: [
      new Respuesta(id: 7, correcta: false, seleccionada: false, preguntaId: 3, texto: "Un invento de Purina."),
      new Respuesta(id: 8, correcta: false, seleccionada: false, preguntaId: 3, texto: "Una estrella de cine."),
      new Respuesta(id: 9, correcta: true, seleccionada: false, preguntaId: 3, texto: "Una tecnología que incluye inmunoglobulinas del calostro y antioxidantes, que ayudan a estabilizar la microbiota intestinal y mejora el estado inmunitario del cachorro."),
    ] ));
    preguntas.add(new PreguntaRespuestas(id: 4, categoria: "Calostro", texto: "Qué es Purina Pro Plan Puppy con Optistar:", respuestas: [
      new Respuesta(id: 10, correcta: false, seleccionada: false, preguntaId: 4, texto: "Un alimento que contiene carne fresca de pollo para mejor valor biológico y protección de aminoacidos esenciales; que fortalece el sistema inmune de los cachorros, mejora la absorción de nutrientes y mantiene belleza de piel y pelaje."),
      new Respuesta(id: 11, correcta: false, seleccionada: false, preguntaId: 4, texto: "Un alimento que disminuye la posibilidad de que se produzcan infecciones, diarreas e inflamaciones."),
      new Respuesta(id: 12, correcta: true, seleccionada: false, preguntaId: 4, texto: "Todas las anteriores."),

    ] ));
    preguntas.add(new PreguntaRespuestas(id: 5, categoria: "MCT", texto: "Cuáles son los principales síntomas de envejecimiento de los perros:", respuestas: [
      new Respuesta(id: 13, correcta: false, seleccionada: false, preguntaId: 5, texto: "Se pone viejo el carnet de vacunas."),
      new Respuesta(id: 14, correcta: true, seleccionada: false, preguntaId: 5, texto: "Obesidad, problemas articulares, pérdida de masa muscular, obesidad, déficit cognitivo."),
      new Respuesta(id: 15, correcta: false, seleccionada: false, preguntaId: 5, texto: "Canas en el pelaje."),

    ] ));
    preguntas.add(new PreguntaRespuestas(id: 6, categoria: "MCT", texto: "¿Qué es la Trigliceridos de cadena media (MCT)?", respuestas: [
      new Respuesta(id: 16, correcta: false, seleccionada: false, preguntaId: 6, texto: "Un tipo de cadeneta de moda para fiestas infantiles."),
      new Respuesta(id: 17, correcta: false, seleccionada: false, preguntaId: 6, texto: "Un ingrediente difícil de conseguir."),
      new Respuesta(id: 18, correcta: true, seleccionada: false, preguntaId: 6, texto: "Una grasa de fácil metabolismo para obtener energía."),

    ] ));
    preguntas.add(new PreguntaRespuestas(id: 7, categoria: "MCT", texto: "Qué es Active Mind:", respuestas: [
      new Respuesta(id: 19, correcta: false, seleccionada: false, preguntaId: 7, texto: "El nombre de un gimnasio."),
      new Respuesta(id: 20, correcta: true, seleccionada: false, preguntaId: 7, texto: "Una tecnología que ayuda a manejar los síntomas del envejecimiento, con antioxidantes, vitaminas, minerales y MCT, para una óptima nutrición del perro geronte."),
      new Respuesta(id: 21, correcta: false, seleccionada: false, preguntaId: 7, texto: "Un ingrediente para bajar de peso."),

    ] ));
    preguntas.add(new PreguntaRespuestas(id: 8, categoria: "MCT", texto: "Qué es Purina Pro Plan Active Mind 7+:", respuestas: [
      new Respuesta(id: 22, correcta: false, seleccionada: false, preguntaId: 8, texto: "Un alimento que contiene carne fresca de pollo para mejor valor biológico y protección de aminoacidos esenciales."),
      new Respuesta(id: 23, correcta: false, seleccionada: false, preguntaId: 8, texto: "Un alimento bajo en grasa, alto en proteínas, rico en antioxidantes y con MCT que controla los síntomas del envejecimiento."),
      new Respuesta(id: 24, correcta: true, seleccionada: false, preguntaId: 8, texto: "Todas las anteriores."),

    ] ));
    preguntas.add(new PreguntaRespuestas(id: 9, categoria: "Spirulina", texto: "Cuáles son los principales sistemas naturales de protección del perro:", respuestas: [
      new Respuesta(id: 25, correcta: true, seleccionada: false, preguntaId: 9, texto: "Sistema inmune y sistema gastrointestinal."),
      new Respuesta(id: 26, correcta: false, seleccionada: false, preguntaId: 9, texto: "Sistema gastrointestinal y sistema renal."),
      new Respuesta(id: 27, correcta: false, seleccionada: false, preguntaId: 9, texto: "Sistema inmune y sistema endocrino."),

    ] ));
    preguntas.add(new PreguntaRespuestas(id: 10, categoria: "Spirulina", texto: "Qué es la Spirulina:", respuestas: [
      new Respuesta(id: 28, correcta: false, seleccionada: false, preguntaId: 10, texto: "Una bacteria intestinal."),
      new Respuesta(id: 29, correcta: false, seleccionada: false, preguntaId: 10, texto: "El protagonista de la ultima producción de Netflix."),
      new Respuesta(id: 30, correcta: true, seleccionada: false, preguntaId: 10, texto: "Un alga marina activador del sistema inmune en perros."),

    ] ));
    preguntas.add(new PreguntaRespuestas(id: 11, categoria: "Spirulina", texto: "Qué es Optihealth:", respuestas: [
      new Respuesta(id: 31, correcta: false, seleccionada: false, preguntaId: 11, texto: "Un indicador de salud del perro."),
      new Respuesta(id: 32, correcta: true, seleccionada: false, preguntaId: 11, texto: "Una tecnología que ayuda a reforzar el sistema inmune, fortalece la microbiota intestinal y refuerza la barrera cutánea del perro."),
      new Respuesta(id: 33, correcta: false, seleccionada: false, preguntaId: 11, texto: "Un ingrediente para bajar de peso."),

    ] ));
    preguntas.add(new PreguntaRespuestas(id: 12, categoria: "Spirulina", texto: "Qué es Purina Pro Plan adulto con Optihealth:", respuestas: [
      new Respuesta(id: 34, correcta: false, seleccionada: false, preguntaId: 12, texto: "Un alimento que contiene carne fresca de pollo para mejor valor biológico y protección de aminoacidos esenciales."),
      new Respuesta(id: 35, correcta: false, seleccionada: false, preguntaId: 12, texto: "Un alimento que fortalece el sistema inmune y digestivo de los perros adultos y brinda belleza y fuerza al pelaje."),
      new Respuesta(id: 36, correcta: true, seleccionada: false, preguntaId: 12, texto: "Todas las anteriores."),

    ] ));

    preguntas.forEach((pregunta) => pregunta.respuestas.shuffle());
    preguntas.shuffle();

    Player.stop();
    
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => new PantallaPregunta(preguntas: preguntas, index: 0)),
      // MaterialPageRoute(builder: (context) => Pantalla()),
    );
  }
}
