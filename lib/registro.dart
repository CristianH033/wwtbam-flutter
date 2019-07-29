import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wwtbam_flutter/pantalla_pregunta.dart';
import 'package:wwtbam_flutter/sounds/player.dart';

import 'components/LogoSVG.dart';
import 'database/Database.dart';
import 'models/JugadorModel.dart';
import 'models/PartidaModel.dart';
import 'models/PreguntaModel.dart';

class PageRegistro extends StatefulWidget {
  PageRegistro({Key key}) : super(key: key);
  @override
  _PageRegistroState createState() => new _PageRegistroState();
}

class _PageRegistroState extends State<PageRegistro> {
  TextEditingController identificacionController = TextEditingController();
  TextEditingController nombresController = TextEditingController();
  TextEditingController apellidosController = TextEditingController();
  TextEditingController correoController = TextEditingController();

  bool _identificacionValid = true;
  bool _nombresValid = true;
  bool _apellidosValid = true;
  bool _correoValid = true;


  // _PageRegistroState();
  @override
  initState() {
    super.initState();
    getPlayers();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: new LogoSVG(width: queryData.size.width/1.6,)//Image.asset('assets/images/Logo.png'),
      ),
    );

    final id = TextField(
      keyboardType: TextInputType.number,
      autofocus: true,
      controller: identificacionController,
      onChanged: (text) {
        searchJugador();
      },
      onEditingComplete: searchJugador,
      decoration: InputDecoration(
        labelText: 'Identificación',
        hintText: 'Identificación',
        errorText: !_identificacionValid ? "El campo es requerido" : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );
    
    final nombres = TextField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: nombresController,
      decoration: InputDecoration(
        labelText: 'Nombres',
        hintText: 'Nombres',
        errorText: !_nombresValid ? "El campo es requerido" : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    final apellidos = TextField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: apellidosController,
      decoration: InputDecoration(
        labelText: 'Apellidos',
        hintText: 'Apellidos',
        errorText: !_apellidosValid ? "El campo es requerido" : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    final email = TextField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: correoController,
      decoration: InputDecoration(
        labelText: 'E-mail',
        hintText: 'E-mail',
        errorText: !_correoValid ? "El campo es requerido" : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );

    final loginButton = new RaisedButton(
      key: null,
      color: Colors.blue,
      textColor: Colors.white,
      onPressed: buttonPressed,
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(30.0)
      ),
      child: Text('A Jugar',
        style: new TextStyle(
          fontSize: 18
        ),
      ),
    );

    return new Scaffold(
      // backgroundColor: Colors.white,
      key: null,
      body: SafeArea(
          child: Container(
            child: ListView(
            padding: const EdgeInsets.all(30),
            physics: BouncingScrollPhysics(),
          // shrinkWrap: true,
          // padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            id,
            SizedBox(height: 8.0),            
            nombres,            
            SizedBox(height: 8.0),
            apellidos,
            SizedBox(height: 8.0),
            email,
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                loginButton
              ],
            ),
            SizedBox(height: queryData.size.height/2.6),
          ],
        )
        )
      ),
    );
  }

  bool _isNumeric(String str) {
    if(str == null) {
      return false;
    }
    return int.tryParse(str) != null;
  }

  bool validar(){
    setState(() {
      _identificacionValid = identificacionController.text.isNotEmpty && _isNumeric(identificacionController.text) ;
      _nombresValid = nombresController.text.isNotEmpty;
      _apellidosValid = apellidosController.text.isNotEmpty;
      _correoValid = correoController.text.isNotEmpty;
    });

    return (_identificacionValid && _nombresValid && _apellidosValid && _correoValid);
  }

  searchJugador() async {
    int id = int.tryParse(identificacionController.text);
    if(id != null){
      Jugador j = await DBProvider.db.getJugador(id);
      // print(j);
      if(j != null){
        setState(() {
          nombresController.text = j.nombres;
          apellidosController.text = j.apellidos;
          correoController.text = j.correo;
        });
      }
    }
  }

  nuevoJugador() async {    
    Jugador nuevoJugador = new Jugador(
      id: int.parse(identificacionController.text),
      nombres: nombresController.text,
      apellidos: apellidosController.text,
      correo: correoController.text);
    try {  
      return await DBProvider.db.newJugador(nuevoJugador);
    } catch (e) {
      // mostrarDialogo("Error", "El jugador ya ha sido registrado");
      // print(e); 
      var jugador = await DBProvider.db.getJugador(nuevoJugador.id);
      return jugador.id;
    }
  }

  void buttonPressed() async {
    if(!validar()) return;    

    var jugador = await nuevoJugador();
    
    if( jugador == null ){
      return;
    }

    Partida nuevaPartida = new Partida(
      jugadorId: jugador
    );

    var idPartida = await DBProvider.db.newPartida(nuevaPartida);

    // print("ID de partida en registr: $idPartida");
    
    List<Pregunta> preguntas = await DBProvider.db.getAllPreguntas();

    preguntas.shuffle();

    // Partida partida = new Partida(
    //   jugadorId: nuevoJugador.id
    // );
    Player.stop();
    // Player.playLetsPlay();
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.size,
        curve: Curves.bounceOut,
        duration: Duration(seconds: 1),
        alignment: Alignment.topCenter,
        child: new PantallaPregunta(partida: idPartida, logRespuestas: [], preguntas: preguntas, index: 0)
      ),
    );
    
    // Navigator.pushReplacement(
      // context,
      // CupertinoPageRoute(builder: (context) => Pantalla()),
      // MaterialPageRoute(builder: (context) => Pantalla()),
    // );
  }

  Future getPlayers() async {
    List<Jugador> jugadores = await DBProvider.db.getAllJugadores();
    // jugadores.forEach((n) => print(n.id));
    // print('=========');
  }

  void mostrarDialogo(String titulo, String texto){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        Player.playFinal();
        return new CupertinoAlertDialog(
          title: new Text(titulo),
          content: new Text(texto),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Ok"),
            ),
          ],
        );
      },
    );
  }
}
