class User {
  int id;
  String email;
  String nome;
  double orcamento;

  User({this.id, this.email, this.nome, this.orcamento});

  factory User.fromJson(Map<String, dynamic> json){
    return User(
        id: json["id"],
        email: json["email"],
        nome: json["nome"],
        orcamento: json["orcamento"]
    );
  }
}