import 'package:flutter/material.dart';
import 'package:controle_financeiro_frontend/Login.dart';
import 'package:controle_financeiro_frontend/Cadastro.dart';

class LogoutRedirect extends StatefulWidget {
  @override
  _LogoutRedirectState createState() => _LogoutRedirectState();
}

class _LogoutRedirectState extends State<LogoutRedirect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Controle Financeiro",
            style:
            TextStyle(
                color: Colors.white)
        ),
        centerTitle: true,
      ),
      body: _body(context),
    );
  }

  _body(BuildContext context) {
    return Form(
      child: Container(
        padding: EdgeInsets.all(50),
        child: ListView(
          children: <Widget>[
            Center(
              child: Text("Realizou logoff",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10)
            ),
            Center(
              child: GestureDetector(
                  child: Text(
                      "Fazer Login",
                      style: TextStyle(
                          color: Colors.blue
                      )
                  ),
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Login()
                        )
                    );
                  }
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10)
            ),
            Center(
              child: GestureDetector(
                  child: Text(
                      "Não tem conta? cadastre-se!",
                      style: TextStyle(
                          color: Colors.blue
                      )
                  ),
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Cadastro()
                        )
                    );
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
