class DespesaTotal {
  double total;

  DespesaTotal({this.total});

  factory DespesaTotal.fromJson(double json){
    return DespesaTotal(
        total: json
    );
  }
}