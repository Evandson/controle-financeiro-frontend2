class Mensagem {
  String message;

  Mensagem({this.message});

  factory Mensagem.fromJson(Map<String, dynamic> json){
    return Mensagem(
      message: json["message"],
    );
  }
}