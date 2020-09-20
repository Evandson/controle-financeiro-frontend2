class Despesa {
  int id;
  double valor;
  String descricao;
  String data;
  String tipoDespesa;
  int idTipoDespesa;
  double usuario;

  Despesa({this.id, this.valor, this.descricao, this.data, this.tipoDespesa, this.idTipoDespesa, this.usuario});

  factory Despesa.fromJson(Map<String, dynamic> json){
    return Despesa(
        id: json["id"],
        valor: json["valor"],
        descricao: json["descricao"],
        data: json["data"],
        idTipoDespesa: json["tipoDespesa"]["id"],
        tipoDespesa: json["tipoDespesa"]["tipo"],
        usuario: json["usuario"]["orcamento"]
    );
  }
}