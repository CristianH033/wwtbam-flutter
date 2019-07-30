import 'package:flutter/material.dart';

class BotonRespuesta extends StatelessWidget {
  // a property on this class
  final String texto;
  final int idx;
  final void Function( int idx ) callback;
  // a constructor for this class
  BotonRespuesta(this.callback, this.texto, this.idx);

  Widget build(context) {
    MediaQueryData queryData = MediaQuery.of(context);
    // Pass the text down to another widget
    return new SizedBox(
      width: (queryData.size.width/1.3) - ((10*(queryData.size.width/2))/100),
      // width: queryData.size.width - 50,
      // height: 70,
      child: RaisedButton(
        key: null,
        onPressed: () => callback(idx),
        highlightColor: Color.fromRGBO(0, 214, 46, 1),
        splashColor: Color.fromRGBO(0, 214, 46, 1),
        textColor: Colors.white,
        padding: EdgeInsets.only(right: 25, left: 25, bottom: 10, top: 10),
        shape: BeveledRectangleBorder(
            side: BorderSide(
              color: Colors.grey, //Color of the border
              style: BorderStyle.solid, //Style of the border
              width: 3, //width of the border
            ),
            borderRadius: BorderRadius.all(Radius.circular(40.0))),
        color: Colors.black,
        child: new Text(
          texto,
          textAlign: TextAlign.center,
          style: new TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w300,
              fontFamily: "Roboto"),
        )
      )
    );
  }

  
}
