import 'package:flutter/material.dart';
import 'package:controle_financeiro_frontend/services/UsuarioService.dart';
import 'package:controle_financeiro_frontend/models/Usuario.dart';
import 'package:controle_financeiro_frontend/models/User.dart';
import 'package:controle_financeiro_frontend/Home.dart';
import 'package:controle_financeiro_frontend/LoginAlt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:controle_financeiro_frontend/utils/FormatUtils.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  TextEditingController _nomeController = TextEditingController();
  final _orcamentoController = MoneyMaskedTextController();


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
          title:
          Text("Controle Financeiro", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              onPressed: () {
                _navegaHome(context);
              },
            )
          ],
        ),

        body:
        new Center(
            child: loading == null
                ? Center(
              child: CircularProgressIndicator(),
            ):
            Padding(padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                      ),
                      Center(
                        child: Text("Perfil de usuário",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                      ),
                      ListTile(
                        title: Text(
                          "Nome: ${this._usuario.nome}",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 15),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            _inserirAtualizarPerfil(
                                usuario: _usuario);
                          },
                        ),
                        subtitle: Text(
                            "Orçamento: R\$ ${formatNumero(_usuario.orcamento)}",
                            style: TextStyle(fontSize: 15, color: Colors.black)
                        ),
                      ),
                      ListTile(
                        title: Text(
                            "Email: ${this._usuario.email}",
                            style: TextStyle(fontSize: 15)
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                      ),
                      Center(
                        child: GestureDetector(
                          child: Text(
                              "Alterar senha?", style: TextStyle(
                            color: Colors.blue,
                          ),
                          ),
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginAlt()
                              )
                            );
                          },
                        ),
                      )
                    ]
                  ),
                )
            )
        )
    );
  }

  _inserirAtualizarPerfil( {Usuario usuario} ){

    String texto = "";
    if(usuario == null){//salvar
      _nomeController.text = "";
      _orcamentoController.text = "";
      texto = "Adicionar";
    }else{//atualizar
      _nomeController.text = usuario.nome;
      _orcamentoController.text = formatNumero(usuario.orcamento);
      texto = "Atualizar";
    }

    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("$texto Perfil"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _nomeController,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "Descrição",
                      hintText: "Digite a descrição"
                  ),
                ),
                TextField(
                  controller: _orcamentoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Orçamento",
                      hintText: "Digite o valor"
                  ),
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancelar")
              ),
              FlatButton(
                  onPressed: (){

                    _salvarAtualizarPerfil(usuarioEsc: usuario);
                    Navigator.pop(context);
                  },
                  child: Text(texto)
              )
            ],
          );
        }
    );
  }

  _salvarAtualizarPerfil({Usuario usuarioEsc}) async {

    String nome = _nomeController.text;
    double orcamento = _orcamentoController.numberValue;

    if (usuarioEsc == null) {//salvar
    }else{//atualizar
      int id = usuarioEsc.id;
      print("Atualizar --> nome: $nome" " valor : $orcamento id: $id");
      var _resultado = await UsuarioService.AtualizarPerfil(id, nome, orcamento);
    }
    setState(() {
      getUsuario();
    });
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
        builder : (context)=> Home()),
    );
  }
}