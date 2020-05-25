import 'package:flutter/material.dart';
import 'package:controle_financeiro_frontend/Home.dart';
import 'package:controle_financeiro_frontend/Forgot.dart';
import 'package:controle_financeiro_frontend/Cadastro.dart';
import 'package:controle_financeiro_frontend/utils/AlertaUtils.dart';
import 'package:controle_financeiro_frontend/services/LoginService.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _ctrlEmail = TextEditingController();
  final _ctrlSenha = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(50),
        child: ListView(
          children: <Widget>[
            Center(
              child: Text("Fazer login",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
            _textFormField(
                "Email",
                "Digite o Email",
                controller: _ctrlEmail,
                validator : _validaEmail
            ),
            _textFormField(
                "Senha",
                "Digite a Senha",
                senha: true,
                controller: _ctrlSenha,
                validator : _validaSenha
            ),
            Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5)
            ),
            _raisedButton("Login", Colors.blue, context),
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
            Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10)
            ),
            Center(
              child: GestureDetector(
                  child: Text(
                      "Esqueceu a senha?",
                      style: TextStyle(
                          color: Colors.blue
                      )
                  ),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Forgot()
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
  _textFormField(
      String label,
      String hint, {
        bool senha = false,
        TextEditingController controller,
        FormFieldValidator<String> validator,
      }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: senha,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
      ),
    );
  }

  String _validaEmail(String texto) {
    if(texto.isEmpty){
      return "Digite o Email";
    }
    return null;
  }

  String _validaSenha(String texto) {
    if(texto.isEmpty){
      return "Digite a Senha";
    }
    return null;
  }

  _raisedButton(
      String texto,
      Color cor,
      BuildContext context) {
    return RaisedButton(
      color: cor,
      child: Text(
        texto,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32)
      ),
      onPressed: () {
        _clickButton(context);
      },
    );
  }

  _clickButton(BuildContext context) async {
    bool formOk = _formKey.currentState.validate();

    if (!formOk) {
      return;
    }
    String email = _ctrlEmail.text;
    String senha = _ctrlSenha.text;

    print("login : $email senha: $senha");

    var usuario = await LoginService.login(email,senha);

    if( usuario == true ){

      _navegaHome(context);
    }else{
      alertLogin(context,"Login Inválido");
    }
  }

  _navegaHome(BuildContext context){
    Navigator.push(
      context, MaterialPageRoute(
        builder : (context)=> Home()),
    );
  }
}