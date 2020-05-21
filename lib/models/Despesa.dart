class Despesa {
  int id;
  double valor;
  String descricao;
  String data;

  Despesa({this.id, this.valor, this.descricao, this.data});

  factory Despesa.fromJson(Map<String, dynamic> json){
    return Despesa(
        id: json["id"],
        valor: json["valor"],
        descricao: json["descricao"],
        data: json["data"],
    );
  }
}