import 'package:flutter/material.dart';

alertLogin(BuildContext context, String msg){
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:Text("Login"),
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

alertEmail(BuildContext context, String msg){
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:Text("Confirmação de envio"),
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

alertEmailNotFound(BuildContext context, String msg){
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:Text("Falha na solicitação"),
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