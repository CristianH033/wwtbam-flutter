import 'package:flutter/material.dart';

class LabelWorong extends StatelessWidget {
  // a property on this class
  final String text;

  // a constructor for this class
  LabelWorong(this.text);

  Widget build(context) {
    MediaQueryData queryData = MediaQuery.of(context);
    // Pass the text down to another widget
    return new Material(
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
        side: BorderSide(color: Colors.grey, width: 3),
      ),
      color: Colors.red,
      child: new Container(
        padding: EdgeInsets.only(right: 20, left: 20, bottom: 15, top: 15),
        constraints: BoxConstraints(maxWidth: queryData.size.width - 100),
        margin: const EdgeInsets.only(
            left: 40.0, right: 40.0, top: 10.0, bottom: 10.0),
        child: new Text(
          text,
          textAlign: TextAlign.center,
          style: new TextStyle(
              fontSize: 24.0,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontFamily: "Roboto"),
        ),
      ),
    );
  }
}
