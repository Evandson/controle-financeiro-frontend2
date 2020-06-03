import 'package:flutter/material.dart';
import 'package:controle_financeiro_frontend/Login.dart';
import 'package:controle_financeiro_frontend/utils/AlertaUtils.dart';
import 'package:controle_financeiro_frontend/services/UsuarioService.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {

  final _ctrlNome = TextEditingController();
  final _ctrlEmail = TextEditingController();
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
                  child: Text("Cadastro de usuário",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
                _textFormField(
                    "Nome",
                    "Digite o Nome",
                    controller: _ctrlNome,
                    validator : _validaNome
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
                _raisedButton("Cadastrar", Colors.blue, context),
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

  String _validaNome(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Informe o nome";
    } else if (!regExp.hasMatch(value)) {
      return "O nome deve conter caracteres de a-z ou A-Z";
    }
    if (value.length > 100) {
      return "Permitido apenas 100 caracteres";
    }
    return null;
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
    String nome = _ctrlNome.text;
    String email = _ctrlEmail.text;
    String senha = _ctrlSenha.text;
    String confSenha = _ctrlConfSenha.text;

    print("login : $nome senha: $email" "login : $senha senha: $confSenha");

    var _confirmPassword = await UsuarioService.confirmPassword(senha, confSenha);

    if(_confirmPassword == true){
      alert(context,"As senhas informadas não conferem!", "Senha inválida");
    }

    var usuario;
    if(_confirmPassword == false) {
      usuario = await UsuarioService.newUser(nome, email, senha);
    }
    if(usuario == true){
      _navegaHome(context);
      alert(context,"Usuário Cadastrado!\n Faça o login para acessar.", "Confirmação de Cadastro");
    }else if(usuario == false){
      alert(context,"Email já cadastrado!", "Erro ao Cadastrar");
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
