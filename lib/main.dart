import 'package:flutter/material.dart';
import 'package:padawan/screens/menu.dart';

void main() => runApp(PadawanApp());

class PadawanApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.indigo[900],
        accentColor: Colors.amber,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.amber,
          textTheme: ButtonTextTheme.primary,
        )),
      home: Menu(),
    );
  }
}