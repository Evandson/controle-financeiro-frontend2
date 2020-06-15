import 'package:flutter/material.dart';
import 'package:controle_financeiro_frontend/Login.dart';
import 'package:controle_financeiro_frontend/utils/AlertaUtils.dart';
import 'package:controle_financeiro_frontend/services/UsuarioService.dart';

class NewPassword extends StatefulWidget {
  @override
  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {

  final _ctrlSenha = TextEditingController();
  final _ctrlConfSenha = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
                  child: Text("Nova senha",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
                _textFormField(
                    "Senha",
                    "Digite a Senha",
                    senha: true,
                    controller: _ctrlSenha,
                    validator : _validaSenha
                ),
                _textFormField(
                    "Confirmar Senha",
                    "Digite a Senha",
                    senha: true,
                    controller: _ctrlConfSenha,
                    validator : _validaConfSenha
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

  String _validaSenha(String texto) {
    if(texto.isEmpty){
      return "Digite a Senha";
    }
    if (texto.length < 8) {
      return "Mínimo de 8 caracteres";
    }
    return null;
  }

  String _validaConfSenha(String texto) {
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
    String senha = _ctrlSenha.text;
    String confSenha = _ctrlConfSenha.text;

    var _confirmPassword = await UsuarioService.confirmPassword(senha, confSenha);

    if(_confirmPassword == true){
      alert(context,"As senhas informadas não conferem!", "Senha inválida");
    }

    /*var usuario;
    if(_confirmPassword == false) {
      usuario = await UsuarioService.newUser(nome, email, senha);
    }
    if(usuario == true){
      _navegaHome(context);
      alert(context,"Usuário Cadastrado!\n Faça o login para acessar.", "Confirmação de Cadastro");
    }else if(usuario == false){
      alert(context,"Email já cadastrado!", "Erro ao Cadastrar");
    }
  }*/

  _navegaHome(BuildContext context){
    Navigator.push(
      context, MaterialPageRoute(
        builder : (context)=> Login()
    ),
    );
  }
  }
}
