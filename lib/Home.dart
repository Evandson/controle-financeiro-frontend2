import 'package:flutter/material.dart';
import 'package:controle_financeiro_frontend/services/DespesaService.dart';
import 'package:controle_financeiro_frontend/services/LogoutService.dart';
import 'package:controle_financeiro_frontend/services/UsuarioService.dart';
import 'package:controle_financeiro_frontend/models/Despesa.dart';
import 'package:controle_financeiro_frontend/models/TipoDespesa.dart';
import 'package:controle_financeiro_frontend/services/TipoDespesaService.dart';
import 'package:controle_financeiro_frontend/models/DespesaTotal.dart';
import 'package:controle_financeiro_frontend/models/User.dart';
import 'package:controle_financeiro_frontend/models/Usuario.dart';
import 'package:controle_financeiro_frontend/Profile.dart';
import 'package:controle_financeiro_frontend/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:controle_financeiro_frontend/utils/FormatUtils.dart';
import 'package:controle_financeiro_frontend/utils/MenuUtils.dart';
import 'package:controle_financeiro_frontend/utils/SnackbarUtils.dart';
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

  String _selection;

  List<TipoDespesa> _tipoDespesa;
  TipoDespesaService _tipoDespesaService = TipoDespesaService();

  DespesaTotal _despesaTotal = new DespesaTotal();

  User _user = new User();

  var loading = null;
  var id;

  @override
  void initState() {
    super.initState();
    getDespesas();
    getOrcamento();
    getTotalDespesas();
    getTipoDespesas();
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
                  loading  == null ? "Carregando...":
                  "${_configurarOrcamento()}\n "
                      "${_configurarDespesaTotal()}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ),

            SliverFillRemaining(
              child: Padding(padding: EdgeInsets.fromLTRB(0, 55, 0, 0),
                child: new Center(
                  child: _despesa == null
                      ? CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ):ListView.builder(
                      itemCount: _despesa.length,
                      itemBuilder: (BuildContext context, int index) {
                        Despesa despesa = _despesa[index];

                          return Padding(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Card(
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          20, 2, 20, 10),
                                    ),
                                    ListTile(
                                      title: Text(
                                          "${despesa.descricao}\n"
                                      ),
                                      trailing: Text(
                                          "R\$ ${formatNumero(despesa.valor)}",
                                          style: TextStyle(fontSize: 16,
                                              fontWeight: FontWeight.bold)
                                      ),
                                      contentPadding: EdgeInsets.only(
                                        right: 16,),
                                      leading: PopupMenuButton(
                                        onSelected: (selection) {
                                          switch (selection) {
                                            case MenuUtils.Excluir:
                                              deleteDespesa(despesa.id);
                                              snackbar(
                                                  context, "Despesa excluída");
                                              break;
                                            case MenuUtils.Editar:
                                              _inserirAtualizarDespesa(
                                                  despesa: despesa);
                                          }
                                        },
                                        itemBuilder: (BuildContext context) {
                                          return MenuUtils.opcoes.map((
                                              String opcoes) {
                                            return PopupMenuItem<String>(
                                              value: opcoes,
                                              child: Text(opcoes),
                                            );
                                          }).toList();
                                        },
                                      ),
                                      subtitle: Text(
                                          "Tipo: ${despesa
                                              .tipoDespesa}\n${despesa
                                              .data}",
                                          style: TextStyle(fontSize: 12)
                                      ),
                                      onTap: () {
                                        _inserirAtualizarDespesa(
                                            despesa: despesa);
                                      },
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          20, 2, 20, 10),
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
        backgroundColor: Colors.blueGrey,
      ),
    );
  }

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
                DropdownButton<String>(
                  isExpanded: true,
                  hint: new Text("Tipo"),
                  items: _tipoDespesa.map((item){
                    return new DropdownMenuItem(
                      child: new Text(item.tipo),
                      value: item.id.toString(),
                    );
                  }).toList(),
                  onChanged: (newVal) {
                    setState(() {
                      _selection = newVal;
                    });
                  },
                  value: _selection,
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
            contentPadding: EdgeInsets.only(
              top: 16, left: 16, right: 16, bottom: 16),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancelar")
              ),
              FlatButton(
                  onPressed: (){

                    _salvarAtualizarDespesa(despesaEsc: despesa);
                    Navigator.pop(context);
                  },
                  child: Text(texto)
              )
            ],
          );
        }
    );
  }

  _salvarAtualizarDespesa({Despesa despesaEsc}) async {

    String descricao = _descricaoController.text;
    double valor = _valorController.numberValue;

    if (despesaEsc == null) {//salvar
    }else{//atualizar
      int id = despesaEsc.id;
      print("Atualizar --> descrição: $descricao" " valor : $valor id: $id");
      var _resultado = await DespesaService.AtualizarDespesa(id, descricao, valor);
    }
    setState(() {
      getDespesas();
      getTotalDespesas();
    });
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

  void getTipoDespesas() async {
    _tipoDespesa = await _tipoDespesaService.getTipoDespesas();
    setState(() {});
  }

  void getTotalDespesas() async {

    _despesaTotal = await _despesaService.totalDespesa();
    setState(() {});
  }

  void deleteDespesa(int id) async {

    _despesa = await _despesaService.deleteDespesa(id);
    setState(() {
      getDespesas();
      getTotalDespesas();
    });
  }

  _configurarDespesaTotal() {

    if (_despesaTotal.total != null ){
      return "Despesa: "+formatNumero(_despesaTotal.total);
    }else{
      return "";
    }
  }

  _configurarOrcamento() {

    if (_usuario.orcamento != null ){
      return "Orçamento: "+formatNumero(_usuario.orcamento);
    }else{
      return "Informar Orçamento!";
    }
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

  _navegaProfile(BuildContext context){
    Navigator.push(
      context, MaterialPageRoute(
        builder : (context)=> Profile()
    ),
    );
  }
}