import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wwtbam_flutter/models/RespuestasPartidaModel.dart';
import 'database/Database.dart';
import 'models/PartidaModel.dart';

class PantallaPartidaDetalles extends StatefulWidget {
  final partida;
  PantallaPartidaDetalles({Key key, @required this.partida}) : super(key: key);
  @override
  _PantallaPartidaDetallesState createState() => new _PantallaPartidaDetallesState();
}

class _PantallaPartidaDetallesState extends State<PantallaPartidaDetalles> {
  var partida;
  @override
  void initState() {
    super.initState();
    // Player.stop();
    // Player.playIntro();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => startUp(context));
  }
  @override
  Widget build(BuildContext context) {
    partida = widget.partida;
    // MediaQueryData queryData = MediaQuery.of(context);

    return new Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: DBProvider.db.getJugador(partida.jugadorId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Text("Partida ${partida.id} - ${snapshot.data.nombres} ${snapshot.data.apellidos}");
            }else{
              return Text("Cargando...");
            }
          }
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: FutureBuilder<List<RespuestasPartida>>(
        future: DBProvider.db.getRespuestasPartida(partida.id),
        builder: (BuildContext context, AsyncSnapshot<List<RespuestasPartida>> respuestas) {
          if (respuestas.hasData) {
            return new Container(
              child: ListView.separated(
                physics: BouncingScrollPhysics(),
                itemCount: respuestas.data.length,
                separatorBuilder: (BuildContext context, int index) => Divider(),
                itemBuilder: (BuildContext context, int index) {
                  RespuestasPartida respuesta = respuestas.data[index];
                  return FutureBuilder(
                    future: DBProvider.db.getRespuesta(respuesta.respuestaId),
                    builder: (BuildContext context, AsyncSnapshot rp) {
                      if(rp.hasData){
                        return ListTile(
                          title: FutureBuilder(
                            future: DBProvider.db.getPregunta(rp.data.preguntaId),
                            builder: (BuildContext context, AsyncSnapshot pregunta) {
                              if(pregunta.hasData){
                                return Text("${pregunta.data.texto}");
                              }else{
                                return Text("....");
                              }
                            }
                          ),
                          subtitle: Text("Respuesta: ${rp.data.texto}"),
                          trailing: rp.data.correcta ? Icon(Icons.check, color: Colors.green, size: 40,) : Icon(Icons.close, color: Colors.red, size: 40)
                        );
                      }else{
                        return Text("Cargando...");
                      }
                    });
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
      // new ListView(
      //   children: <Widget>[
      //     new ListTile(
      //       leading: CircleAvatar(
      //         child: Text("Texto")
      //       ),
      //       title: Text("Texto"),
      //       subtitle: Text("Texto")
      //     )
      //   ],
      // )
    );
  }

  void entrarPartida(Partida partida){

  }

  void startUp(BuildContext context) async {
    
  }

  void buttonPressed() {
    
  }
}
