class TipoDespesa {
  final int id;
  final String tipo;

  TipoDespesa({this.id, this.tipo});

  factory TipoDespesa.fromJson(Map<String, dynamic> json){
    return TipoDespesa(
        id: json["id"],
        tipo: json["tipo"]
    );
  }
}