import 'package:flutter/material.dart';
import 'package:controle_financeiro_frontend/Login.dart';
import 'package:controle_financeiro_frontend/utils/AlertaUtils.dart';
import 'package:controle_financeiro_frontend/services/UsuarioService.dart';

class Forgot extends StatefulWidget {
  @override
  _ForgotState createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {

  final _ctrlEmail = TextEditingController();
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
                child: Text("Solicitar nova senha",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
              _textFormField(
                  "Email",
                  "Digite o Email",
                  controller: _ctrlEmail,
                  validator : _validaEmail
              ),
              Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 5)
              ),
              _raisedButton("Enviar", Colors.blue, context),
              Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10)
              ),
            ]
        ),
      ),
    );
  }

  _textFormField(
      String label,
      String hint, {
        TextEditingController controller,
        FormFieldValidator<String> validator,
      }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
      ),
    );
  }

  String _validaEmail(String texto) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\'
        r'".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(('
        r'[a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (texto.length == 0) {
      return "Digite o Email";
    } else if(!regExp.hasMatch(texto)){
      return "Email inválido";
    }else {
      return null;
    }
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

    print("login : $email");

    var usuario = await UsuarioService.forgotUser(email);

    if( usuario == true ){
      _navegaHome(context);
      alert(context,"Nova senha solicitada para: ${email}", "Confirmação de Envio");
    }else{
      alert(context,"Email não encontrado!", "Fallha na Solicitação");
    }
  }

  _navegaHome(BuildContext context){
    Navigator.push(
      context, MaterialPageRoute(
        builder : (context)=> Login()
    ),
    );
  }
}
