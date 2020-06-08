class User {
  int id;
  String email;
  String nome;
  double orcamento;

  User({this.id, this.email, this.nome, this.orcamento});

  int get Id {
    return id;
  }
  void set Id(int id) {
    this.id = id;
  }

  String get Email {
    return email;
  }
  void set Email(String email) {
    this.email = email;
  }

  String get Nome {
    return nome;
  }
  void set Nome(String nome) {
    this.nome = nome;
  }

  double get Orcamento {
    return orcamento;
  }
  void set Orcamento(double orcamento) {
    this.orcamento = orcamento;
  }

  factory User.fromJson(Map<String, dynamic> json){
    return User(
        id: json["id"],
        email: json["email"],
        nome: json["nome"],
        orcamento: json["orcamento"]
    );
  }
}