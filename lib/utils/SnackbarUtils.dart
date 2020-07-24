import 'package:flutter/material.dart';

snackbar (BuildContext context, String msg){
 final snackbar = SnackBar(
    duration: Duration(seconds: 2),
    content: Text(msg),
  );
  Scaffold.of(context).showSnackBar(snackbar);
}