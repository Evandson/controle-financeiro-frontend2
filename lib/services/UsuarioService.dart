import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

class UsuarioService{
  static Future<bool> newUser(String nome, String email, String senha) async {

    String _urlBase = "http://localhost:8888/login";

    var header = {"Content-Type": "application/json"};

    Map params = {
      "email": email,
      "senha": senha
    };

    var prefs = await SharedPreferences.getInstance();

    var _body = json.encode(params);
    print("json enviado : $_body");

    var response = await http.post(_urlBase, headers: header,
        body: _body);

    print('Response status: ${response.statusCode}');

    String token = response.headers['authorization'];
    print("authorization $token");

    if (response.statusCode == 200 && token != null) {
      prefs.setString("authorization", token);
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> forgotUser(String email) async {

    String _urlBase = "http://localhost:8888/login";

    var header = {"Content-Type": "application/json"};

    Map params = {
      "email": email
    };

    var prefs = await SharedPreferences.getInstance();

    var _body = json.encode(params);
    print("json enviado : $_body");

    var response = await http.post(_urlBase, headers: header,
        body: _body);

    print('Response status: ${response.statusCode}');

    String token = response.headers['authorization'];
    print("authorization $token");

    if (response.statusCode == 200 && token != null) {
      prefs.setString("authorization", token);
      return true;
    } else {
      return false;
    }
  }
}