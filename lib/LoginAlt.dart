import 'package:flutter/material.dart';
import 'package:controle_financeiro_frontend/NewPassword.dart';
import 'package:controle_financeiro_frontend/utils/AlertaUtils.dart';
import 'package:controle_financeiro_frontend/services/LoginService.dart';

class LoginAlt extends StatefulWidget {
  @override
  _LoginAltState createState() => _LoginAltState();
}

class _LoginAltState extends State<LoginAlt> {

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
              child: Text("É necessário autenticar-se",
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
            _raisedButton("Continuar", Colors.blue, context),
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

    print("login :$email senha: $senha");

    var usuario = await LoginService.login(email,senha);

    if( usuario == true ){

      _navegaHome(context);
    }else{
      alert(context,"Login Inválido", "Login");
    }
  }

  _navegaHome(BuildContext context){
    Navigator.push(
      context, MaterialPageRoute(
        builder : (context)=> NewPassword()),
    );
  }
}