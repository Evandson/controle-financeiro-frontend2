import 'package:flutter/material.dart';
import 'package:controle_financeiro_frontend/services/DespesaService.dart';
import 'package:controle_financeiro_frontend/services/LogoutService.dart';
import 'package:controle_financeiro_frontend/services/UsuarioService.dart';
import 'package:controle_financeiro_frontend/models/Despesa.dart';
import 'package:controle_financeiro_frontend/models/User.dart';
import 'package:controle_financeiro_frontend/models/Usuario.dart';
import 'package:controle_financeiro_frontend/Profile.dart';
import 'package:controle_financeiro_frontend/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Despesa> _despesa;
  DespesaService _despesaService = DespesaService();

  LogoutService _logoutService = LogoutService();

  Usuario _usuario = new Usuario();
  UsuarioService _usuarioService = UsuarioService();

  User _user = new User();

  var loading = null;
  var id;

  @override
  void initState() {
    super.initState();
    getDespesas();
    getOrcamento();
  }

  void _addDespesa(){
  }

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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.blue,
      body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.account_circle,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _navegaProfile(context);
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _logout();
                  },
                )
              ],
              expandedHeight: 130.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  loading == null ? "Carregando...":
                  "Orçamento: ${this._usuario.orcamento.toStringAsFixed(2)}\n "
                      "Despesa: ${this._usuario.orcamento.toStringAsFixed(2)}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ),

            SliverFillRemaining(
              child:
              Padding(padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: new Center(
                  child: _despesa == null
                      ? CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  )
                      : ListView.builder(
                      itemCount: _despesa.length,
                      itemBuilder: (BuildContext context, int index) {
                        Despesa despesa = _despesa[index];

                        return Padding(padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            child: Card(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(20, 2, 20, 10),
                                  ),
                                  ListTile(
                                    title: Text(
                                        "${despesa.descricao}\n"
                                    ),
                                    trailing: Text(
                                        "R\$ ${despesa.valor.toStringAsFixed(2)}",
                                        style: TextStyle(fontSize: 16)
                                    ),
                                    subtitle: Text(
                                        "Tipo: ${despesa.tipoDespesa}\n${despesa
                                            .data}",
                                        style: TextStyle(fontSize: 12)
                                    ),
                                    onTap: (){

                                    },
                                  ),
                                  ButtonTheme.bar(
                                    child: ButtonBar(
                                      children: <Widget>[
                                        FlatButton(
                                          child: const Text('Acessar'),
                                          onPressed: () {
                                          },
                                        ),
                                        FlatButton(
                                          child: Text('Excluir'),
                                          textColor: Colors.red,
                                          onPressed: () {
                                          },
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              10, 2, 80, 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                        );
                      }
                  ),
                ),
              ),
            )
          ]
      ),
      floatingActionButton: new FloatingActionButton(
        elevation: 2.0,
        onPressed: _addDespesa,
        child: new Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
  void getOrcamento() async {
    var prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString("login") ?? "");
    _user = await _usuarioService.getUserByEmail(email);
    _usuario = await _usuarioService.getUsuario(this._user.id);
    loading = 1;
    setState(() {});
  }
  void getDespesas() async {
    _despesa = await _despesaService.getDespesas();
    setState(() {});
  }

  _navegaProfile(BuildContext context){
    Navigator.push(
      context, MaterialPageRoute(
        builder : (context)=> Profile()),
    );
  }
}