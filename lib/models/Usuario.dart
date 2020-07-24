class Usuario {
  int id;
  String email;
  String nome;
  double orcamento;

  Usuario({this.id, this.email, this.nome, this.orcamento});

  factory Usuario.fromJson(Map<String, dynamic> json){
    return Usuario(
        id: json["id"],
        email: json["email"],
        nome: json["nome"],
        orcamento: json["orcamento"]
    );
  }
}