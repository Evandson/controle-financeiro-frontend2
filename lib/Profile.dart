import 'package:flutter/material.dart';
import 'package:controle_financeiro_frontend/services/UsuarioService.dart';
import 'package:controle_financeiro_frontend/models/Usuario.dart';
import 'package:controle_financeiro_frontend/models/User.dart';
import 'package:controle_financeiro_frontend/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

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
            Padding(padding: EdgeInsets.fromLTRB(10, 0, 10,0),
                child: Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          "Nome: ${this._usuario.nome}",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 15),
                        ),
                        trailing: Text(
                          "Orçamento: ${this._usuario.orcamento}",
                          textAlign: TextAlign.center,
                        ),
                        subtitle: Text(
                          "Email: ${this._usuario.email}",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 15),

                        ),
                      ),
                      ButtonTheme.bar(
                        child: ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              child: const Text('Editar'),
                              onPressed: () {
                                /* ... */
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
            )
        )
    );
  }
  void getUsuario() async {
    var prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString("login") ?? "");
    _user = await _usuarioService.getUserByEmail(email);
    _usuario = await _usuarioService.getUsuario(this._user.id);
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