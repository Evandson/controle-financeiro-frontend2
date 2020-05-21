import "package:flutter/material.dart";
import 'package:controle_financeiro_frontend/Login.dart';

void main() => runApp(MyApp(

));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue
      ), //ThemeData
      home: Login(),
    ); //MaterialApp
  }
}