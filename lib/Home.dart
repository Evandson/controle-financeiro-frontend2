import 'package:flutter/material.dart';
import 'package:controle_financeiro_frontend/services/DespesaService.dart';
import 'package:controle_financeiro_frontend/models/Despesa.dart';

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

  @override
  void initState() {
    super.initState();
    getDespesas();
  }

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
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () {
            },
          )
        ],
      ),

      body: Center(
        child: _despesa == null
            ? CircularProgressIndicator()
            : ListView.builder(
            itemCount: _despesa.length,
            itemBuilder: (BuildContext context, int index) {
              Despesa despesa = _despesa[index];

              return Padding(padding:EdgeInsets.fromLTRB(20, 2, 20, 2) ,
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 2, 20, 5),
                        ),
                        ListTile(
                          title: Text(
                              "${despesa.descricao}\n"
                                  "Valor: ${despesa.valor}"
                          ),
                          subtitle: Text(
                              "Cadastrado: ${despesa.data}"
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
    );
  }
  void getDespesas() async {
    _despesa = await _despesaService.getDespesas();
    setState(() {});
  }
}