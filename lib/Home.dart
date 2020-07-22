import 'package:flutter/material.dart';
import 'package:controle_financeiro_frontend/services/DespesaService.dart';
import 'package:controle_financeiro_frontend/services/LogoutService.dart';
import 'package:controle_financeiro_frontend/services/UsuarioService.dart';
import 'package:controle_financeiro_frontend/models/Despesa.dart';
import 'package:controle_financeiro_frontend/models/DespesaTotal.dart';
import 'package:controle_financeiro_frontend/models/User.dart';
import 'package:controle_financeiro_frontend/models/Usuario.dart';
import 'package:controle_financeiro_frontend/Profile.dart';
import 'package:controle_financeiro_frontend/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:controle_financeiro_frontend/utils/FormatUtils.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

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

  TextEditingController _descricaoController = TextEditingController();
  final _valorController = MoneyMaskedTextController();


  List<Despesa> _despesa;
  DespesaService _despesaService = DespesaService();

  LogoutService _logoutService = LogoutService();

  Usuario _usuario = new Usuario();
  UsuarioService _usuarioService = UsuarioService();

  DespesaTotal _despesaTotal = new DespesaTotal();

  User _user = new User();

  var loading = null;
  var id;

  _inserirAtualizarDespesa( {Despesa despesa} ){

    String texto = "";
    if(despesa == null){//salvar
      _descricaoController.text = "";
      _valorController.text = "";
      texto = "Adicionar";
    }else{//atualizar
      _descricaoController.text = despesa.descricao;
      _valorController.text = formatNumero(despesa.valor);
      texto = "Atualizar";
    }

    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("$texto despesa"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _descricaoController,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "Descrição",
                      hintText: "Digite a descrição"
                  ),
                ),
                TextField(
                  controller: _valorController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Valor",
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

                    //_salvarAtualizarDespesa(despesaEsc: despesa);
                    Navigator.pop(context);
                  },
                  child: Text(texto)
              )
            ],
          );
        }
    );
  }

  @override
  void initState() {
    super.initState();
    getDespesas();
    getOrcamento();
    getTotalDespesas();
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
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  loading == null ? "Carregando...":
                  "Orçamento: ${formatNumero(this._usuario.orcamento)}\n "
                      "Despesa: ${formatNumero(this._despesaTotal.total)}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ),

            SliverFillRemaining(
              child:
              Padding(padding: EdgeInsets.fromLTRB(0, 55, 0, 0),
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
                                        "R\$ ${formatNumero(despesa.valor)}",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
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
                                            _inserirAtualizarDespesa(despesa: despesa);
                                          },
                                        ),
                                        FlatButton(
                                          child: Text('Excluir'),
                                          textColor: Colors.red,
                                          onPressed: () {
                                            deleteDespesas(despesa.id);
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
        onPressed: _inserirAtualizarDespesa,
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

  void getTotalDespesas() async {
    _despesaTotal = await _despesaService.totalDespesa();
    setState(() {});
  }

  void deleteDespesas(int id) async {
    _despesa = await _despesaService.deleteDespesa(id);
    setState(() {
      getDespesas();
      getTotalDespesas();
    });
  }

  _navegaProfile(BuildContext context){
    Navigator.push(
      context, MaterialPageRoute(
        builder : (context)=> Profile()
    ),
    );
  }
}