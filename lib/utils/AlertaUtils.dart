import 'package:flutter/material.dart';

alert(BuildContext context, String msg, String titulo){
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(msg),
          actions: <Widget>[
            FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.pop(context);
                }
            )
          ],
        );
      }
  );
}