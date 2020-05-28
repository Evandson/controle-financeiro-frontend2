import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:controle_financeiro_frontend/models/Usuario.dart';

class UsuarioService{
  static Future<bool> newUser(String nome, String email, String senha) async {

    String _urlBase = "http://localhost:8888/usuarios";

    var header = {"Content-Type": "application/json"};

    Map params = {
      "nome": nome,
      "email": email,
      "senha": senha
    };

    var _body = json.encode(params);
    print("json enviado : $_body");

    var response = await http.post(_urlBase, headers: header,
        body: _body);

    print('Response status: ${response.statusCode}');

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> forgotUser(String email) async {

    String _urlBase = "http://localhost:8888/auth/forgot";

    var header = {"Content-Type": "application/json"};

    Map params = {
      "email": email
    };

    var _body = json.encode(params);
    print("json enviado : $_body");

    var response = await http.post(_urlBase, headers: header,
        body: _body);

    print('Response status: ${response.statusCode}');

    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Usuario>> getUsuario() async {

    var prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString("authorization") ?? "");

    print("authorization : $token");

    var header = {
      "Content-Type": "application/json",
      "Authorization": "$token"
    };

    http.Response response = await http.get(
        "http://localhost:8888/usuarios", headers: header);
    return decode(response);
  }

  List<Usuario> decode(http.Response response) {
    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);

      List<Usuario> usuario = decoded.map<Usuario>((usuario) {
        return Usuario.fromJson(usuario);
      }).toList();

      print(usuario);
      return usuario;
    }
  }
}