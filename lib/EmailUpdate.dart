import 'package:flutter/material.dart';
import 'package:controle_financeiro_frontend/Login.dart';
import 'package:controle_financeiro_frontend/utils/AlertaUtils.dart';
import 'package:controle_financeiro_frontend/services/UsuarioService.dart';
import 'package:controle_financeiro_frontend/services/LogoutService.dart';
import 'package:shared_preferences/shared_preferences.dart';


class EmailUpdate extends StatefulWidget {
  @override
  _EmailUpdateState createState() => _EmailUpdateState();
}

class _EmailUpdateState extends State<EmailUpdate> {

  final _ctrlEmail = TextEditingController();
  final _ctrlConfEmail = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  LogoutService _logoutService = LogoutService();

  _logout()async{

    var token = _logoutService.deleteToken();
    print("Token removido: $token");
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Login()
        )
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Controle Financeiro",
            style:
            TextStyle(
                color: Colors.white
            )
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
                  child: Text("Novo e-mail",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
                _textFormField(
                    "E-mail",
                    "Digite o E-mail",
                    senha: false,
                    controller: _ctrlEmail,
                    validator : _validaEmail
                ),
                _textFormField(
                    "Confirmar E-mail",
                    "Digite o e-mail",
                    senha: false,
                    controller: _ctrlConfEmail,
                    validator : _validaConfEmail
                ),
                Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5)
                ),
                _raisedButton("Confirmar", Colors.blue, context),
              ]
          )
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
      return "Digite a Senha";
    }
    if (texto.length < 8) {
      return "Mínimo de 8 caracteres";
    }
    return null;
  }

  String _validaConfEmail(String texto) {
    if(texto.isEmpty){
      return "Digite a Senha";
    }
    if (texto.length < 8) {
      return "Mínimo de 8 caracteres";
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
    String confEmail = _ctrlConfEmail.text;

    var _confirmEmail = await UsuarioService.confirmEmail(email, confEmail);

    if(_confirmEmail == true){
      alert(context,"Os e-mails informadas não conferem!", "Email inválido");
    }

    var prefs = await SharedPreferences.getInstance();
    int id = (prefs.getInt("id") ?? "");
    print("ID: ${id}");

    var usuario;
    if(_confirmEmail == false) {
      usuario = await UsuarioService.newEmail(email, id);
    }
    if(usuario == true){
      _logout();
      alert(context,"Faça o login para acessar.", "Email atualizado!");
    }else if(usuario == false){
      alert(context,"O e-email já existe!", "Erro na solicitação");
    }
  }
}
