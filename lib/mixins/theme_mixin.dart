import 'package:flutter/material.dart';

class ThemeMixin {
  // final Shader _linearGradient = LinearGradient(    colors: <Color>[Color(0xff00f260), Color(0xff0575e6)],  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  ThemeData buildThemeData() {
    return ThemeData(
        fontFamily: 'Simplifica',
        primaryColor: Colors.white,
        errorColor: Colors.redAccent,
        highlightColor: Colors.blueAccent,
        textSelectionColor: Colors.orangeAccent,
        inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(
          fontSize: 15.0,
          color: Colors.black87,
          fontFamily: 'Simplifica',
        )));
  }

  ThemeData buildThemeData2() {
    return ThemeData(
      //primarySwatch: Colors.white,
      //fontFamily: 'Montserrat',
      primaryColor: Colors.white,
      //errorColor: Colors.redAccent,
      //highlightColor: Colors.limeAccent,
      //textSelectionColor: Colors.orangeAccent,
      //accentColor: Colors.red,
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
        buttonColor: Colors.pinkAccent, //not working
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(7.0)),
      ),
      iconTheme:
          IconThemeData(color: Colors.white, size: 30),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
          fontSize: 13.0,
          color: Color.fromRGBO(10, 10, 10, 100),
          fontFamily: 'Montserrat',
        ),
        hintStyle: TextStyle(
          fontSize: 13.0,
          color: Colors.grey,
          fontFamily: 'Montserrat',
        ),
        errorStyle: TextStyle(
          fontSize: 13.0,
          color: Colors.redAccent,
          fontFamily: 'Montserrat',
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
        ),
      ),
      primaryTextTheme: TextTheme(
        title: TextStyle(
          fontSize: 15.0,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: Colors.white,
          //fontFamily: "Simplifica",
        ), //appdata
        subtitle: TextStyle(
          fontSize: 22.0,
          color: Color.fromRGBO(10, 10, 10, 100),
          fontFamily: 'Montserrat',
        ),
        headline: TextStyle(
          fontSize: 40.0,
          color: Color.fromRGBO(10, 10, 10, 100),
          fontFamily: 'Simplifica',
        ),
        button: TextStyle(
          //fontWeight: FontWeight.w900,
          fontSize: 17.0,
          color: Colors.tealAccent,
          fontFamily: 'Simplifica',
        ),
        body1: TextStyle(
          fontSize: 18.0,
          color: Colors.pink,
          fontFamily: 'Montserrat',
        ),
        body2: TextStyle(
          fontSize: 18.0,
          color: Colors.blue,
          fontStyle: FontStyle.italic,
          decoration: TextDecoration.underline,
          fontFamily: 'Montserrat',
        ),
        display1: TextStyle(
          fontSize: 40.0,
          fontFamily: 'Montserrat',
          // foreground: Paint()..shader = _linearGradient,
        ),
        display2: // TabBarLable
            TextStyle(fontSize: 8.0),
      ),
      textTheme: TextTheme(
        title: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(10, 10, 10, 100),
        ),
        display1: TextStyle(
          fontSize: 40.0,
          color: Colors.red,
          fontFamily: 'Simplifica',
        ),
        display2: TextStyle(
          fontSize: 20.0,
          color: Colors.blueGrey.shade400,
          fontFamily: 'Montserrat',
        ),
        display3: TextStyle(
          fontSize: 16.0,
          color: Colors.green,
          fontFamily: 'Montserrat',
        ),
        display4: TextStyle(
          fontSize: 20.0,
          color: Colors.blueGrey,
          fontFamily: 'Montserrat',
        ),
      ),
    );
  }
}
