import 'package:flutter/material.dart';
import 'package:controle_financeiro_frontend/EmailUpdate.dart';
import 'package:controle_financeiro_frontend/utils/AlertaUtils.dart';
import 'package:controle_financeiro_frontend/services/LoginService.dart';
import 'package:controle_financeiro_frontend/services/UsuarioService.dart';
import 'package:controle_financeiro_frontend/models/Usuario.dart';
import 'package:controle_financeiro_frontend/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AltLogin extends StatefulWidget {
  @override
  _AltLoginState createState() => _AltLoginState();
}

class _AltLoginState extends State<AltLogin> {

  final _ctrlSenha = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Usuario _usuario = new Usuario();
  UsuarioService _usuarioService = UsuarioService();

  User _user = new User();

  @override
  void initState() {
    super.initState();
    getUsuario();
  }

  var loading = null;

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
    return Center(
        child: loading == null
            ? Center(
          child: CircularProgressIndicator(),
        ):
        new Form(
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
                    enabled: false,
                    controller: TextEditingController(text: "${_usuario.email}"),
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
        )
    );
  }
  _textFormField(
      String label,
      String hint, {
        bool enabled = true,
        bool senha = false,
        String initialValue,
        TextEditingController controller,
        FormFieldValidator<String> validator,
      }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      enabled: enabled,
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
    String email = _usuario.email;
    String senha = _ctrlSenha.text;

    print("login :$email senha: $senha");

    var usuario = await LoginService.login(email,senha);

    if( usuario == true ){

      _navegaHome(context);
    }else{
      alert(context,"Login Inválido", "Login");
    }
  }

  void getUsuario() async {

    var prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString("login") ?? "");
    _user = await _usuarioService.getUserByEmail(email);
    _usuario = await _usuarioService.getUsuario(this._user.id);
    prefs.setInt("id", this._user.id);
    loading = 1;

    setState(() {});
  }

  _navegaHome(BuildContext context){
    Navigator.push(
      context, MaterialPageRoute(
        builder : (context)=> EmailUpdate()),
    );
  }
}