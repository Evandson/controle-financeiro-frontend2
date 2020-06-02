import 'package:controle_financeiro_frontend/models/TipoDespesa.dart';

class Despesa {
  int id;
  double valor;
  String descricao;
  String data;
  String tipoDespesa;

  Despesa({this.id, this.valor, this.descricao, this.data, this.tipoDespesa});

  factory Despesa.fromJson(Map<String, dynamic> json){
    return Despesa(
        id: json["id"],
        valor: json["valor"],
        descricao: json["descricao"],
        data: json["data"],
        tipoDespesa: json["tipoDespesa"]["tipo"]
    );
  }
}