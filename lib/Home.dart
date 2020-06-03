import 'package:flutter/material.dart';
import 'package:controle_financeiro_frontend/services/DespesaService.dart';
import 'package:controle_financeiro_frontend/services/LogoutService.dart';
import 'package:controle_financeiro_frontend/models/Despesa.dart';
import 'package:controle_financeiro_frontend/Login.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(
      ),
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

  @override
  void initState() {
    super.initState();
    getDespesas();
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
      body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.account_circle,
                    color: Colors.white,
                  ),
                  onPressed: (){
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  onPressed: () {_logout();},
                )
              ],
              expandedHeight: 100.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  "Orçamento:\n Despesa:",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ),

            SliverFillRemaining(
              child: new Center(
                child: _despesa == null
                    ? CircularProgressIndicator()
                    : ListView.builder(
                    itemCount: _despesa.length,
                    itemBuilder: (BuildContext context, int index) {
                      Despesa despesa = _despesa[index];

                      return Padding(padding:EdgeInsets.fromLTRB(20, 40, 20, 2),
                          child: Card(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 2, 20, 10),
                                ),
                                ListTile(
                                  title: Text(
                                      "${despesa.descricao}\n"
                                          "Valor: ${despesa.valor}"
                                  ),
                                  subtitle: Text(
                                      "Tipo: ${despesa.tipoDespesa}\nCadastrado: ${despesa.data}"
                                  ),
                                ),
                                ButtonTheme.bar(
                                  child: ButtonBar(
                                    children: <Widget>[
                                      FlatButton(
                                        child: const Text('Acessar'),
                                        onPressed: () { /* ... */ },
                                      ),
                                      FlatButton(
                                        child: Text('Excluir'),
                                        textColor: Colors.red,
                                        onPressed: () { /* ... */ },
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(10, 2, 60, 10),
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
          ]
      ),
      floatingActionButton: new FloatingActionButton(
          elevation: 2.0,
          onPressed: _addDespesa,
          child: new Icon(Icons.add)
      ),
    );
  }
  void getDespesas() async {
    _despesa = await _despesaService.getDespesas();
    setState(() {});
  }
}