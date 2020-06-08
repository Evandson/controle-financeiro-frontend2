import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:controle_financeiro_frontend/models/Usuario.dart';
import 'package:controle_financeiro_frontend/models/User.dart';

class UsuarioService {

  static Future<bool> newUser(String nome, String email, String senha) async {
    String _urlBase = "http://localhost:8888/usuarios";

    var header = {"Content-Type": "application/json"};

    Map params = {
      "nome": nome,
      "email": email,
      "senha": senha
    };

    var _body = json.encode(params);
    //print("json enviado : $_body");

    var response = await http.post(_urlBase, headers: header,
        body: _body);

    //print('Response status: ${response.statusCode}');

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> confirmPassword(String senha, String confSenha) async {
    if (senha != confSenha) {
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
    //print("json enviado : $_body");

    var response = await http.post(_urlBase, headers: header,
        body: _body);

    //print('Response status: ${response.statusCode}');

    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  Future<Usuario> getUsuario(int id) async {
    var prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString("authorization") ?? "");

    //print("authorization : $token");

    var header = {
      "Content-Type": "application/json",
      "Authorization": "$token"
    };

    http.Response response = await http.get(
        "http://localhost:8888/usuarios/${id}", headers: header);
    return decode(response);
  }

  Usuario decode(http.Response response) {
    if (response.statusCode == 200) {
      return Usuario.fromJson(jsonDecode(response.body));
    } else {
      Exception("Falha na requisição");
    }
  }

  Future<User> getUserByEmail(String email) async {
    var prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString("authorization") ?? "");

    var header = {
      "Content-Type": "application/json",
      "Authorization": "$token"
    };

    http.Response response = await http.get(
        "http://localhost:8888/usuarios/email?value=${email}", headers: header);
    return decodeJson(response);
  }

  User decodeJson(http.Response response) {
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }else{
      Exception("Falha na requisição");
    }
  }
}