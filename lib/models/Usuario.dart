class Usuario {
  int id;
  String email;
  String nome;
  String orcamento;

  Usuario({this.id, this.email, this.nome, this.orcamento});

  factory Usuario.fromJson(Map<String, dynamic> json){
    return Usuario(
      id: json["id"],
      email: json["valor"],
      nome: json["descricao"],
      orcamento: json["data"]
    );
  }
}